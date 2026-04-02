# OpenProject Hierarchical Sort Plugin

OpenProject plugin that adds **natural sorting** for string custom fields containing dotted numeric identifiers such as:

- `1`
- `1.2`
- `2.1.3.2`
- `2.1.3.10`

Without this plugin, such values are often sorted lexically, which produces undesirable results like:

- `2.1.3.10`
- `2.1.3.2`

With this plugin, sorting becomes segment-aware, so the order is:

- `2.1.3.2`
- `2.1.3.10`

## What fields it affects

The plugin is intentionally **universal by field definition**, not by field ID or name.

It only activates for custom fields that satisfy all of the following:

- field type is `string`
- field regexp is exactly one of:
  - `^(\\d+)(\\.\\d+)*$`
  - `^(\d+)(\.\d+)*$`

That means the plugin targets fields validated as dotted numeric identifiers.

## How it works

The plugin patches OpenProject sorting for matching custom fields and builds a PostgreSQL sort expression with three layers:

1. **Validity bucket**
   - values matching `^\d+(\.\d+)*$` are sorted before non-matching values

2. **Normalized segment sort**
   - the field value is split by `.` using PostgreSQL `string_to_array(..., '.')`
   - each numeric segment is left-padded with zeros using `lpad(part, 8, '0')`
   - padded segments are joined back into a comparable string

3. **Fallback string sort**
   - original string value is used as a final fallback for stable ordering

So for example:

- `2.1.3.2` becomes roughly comparable as `00000002.00000001.00000003.00000002`
- `2.1.3.10` becomes roughly comparable as `00000002.00000001.00000003.00000010`

Because `00000002 < 00000010`, the natural order is preserved.

## Why `Query::Results` is also patched

In some OpenProject paths, string custom-field sorting may be wrapped in case-insensitive handling such as `LOWER(...)`.
That can interfere with custom SQL expressions for natural sorting.

For matching hierarchical fields, this plugin bypasses that wrapping so the generated SQL sort expression stays intact.

## What it does not do

This plugin does **not**:

- repair broken work package hierarchies
- infer `parent_id` from custom field values
- transform arbitrary strings into hierarchy
- affect fields whose regexp does not match the dotted-numeric pattern

It only changes **sorting behavior** for matching fields.

## Installation

1. Copy plugin to:

   `/opt/plugins/openproject-hierarchical_sort`

2. Add to `/opt/openproject/Gemfile.plugins`:

```ruby
group :opf_plugins do
  gem "openproject-hierarchical_sort",
      path: "/opt/plugins/openproject-hierarchical_sort",
      require: "openproject_hierarchical_sort"
end
```

3. Restart OpenProject web services.

## Requirements

- OpenProject
- PostgreSQL
- string custom field with dotted-numeric regexp

## Repository status

Current version: `0.1.0`

## License

GPL-3.0-or-later
