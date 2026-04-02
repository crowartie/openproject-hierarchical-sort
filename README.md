# OpenProject Hierarchical Sort Plugin

Adds natural sorting for OpenProject **string custom fields** whose validation regexp is exactly one of:

- `^(\\d+)(\\.\\d+)*$`
- `^(\d+)(\.\d+)*$`

This is intended for dotted numeric identifiers such as:

- `1`
- `1.2`
- `2.1.3.10`

## What it changes

For matching custom fields, sorting becomes segment-aware:

- `1`
- `1.1`
- `1.2`
- `2`
- `2.1`
- `2.1.3.2`
- `2.1.3.10`

instead of lexical sorting.

## What it does not do

- It does **not** repair broken work package hierarchies.
- It does **not** infer `parent_id` from the custom field value.
- It does **not** affect fields whose regexp does not match the dotted-numeric pattern above.

## Install

1. Copy plugin to:
   - `/opt/plugins/openproject-hierarchical_sort`
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

- OpenProject with PostgreSQL
- Custom field type: `string`
- Custom field regexp set to dotted numeric pattern

## Notes

The plugin is universal by field definition, not by field ID or name.
Any matching string custom field will use natural sort automatically.
