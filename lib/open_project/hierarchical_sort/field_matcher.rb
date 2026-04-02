module OpenProject
  module HierarchicalSort
    module FieldMatcher
      module_function

      VALUE_MATCH_SQL = "^\\d+(\\.\\d+)*$".freeze
      SOURCE_PATTERNS = [
        "^(\\d+)(\\.\\d+)*$",
        "^(\\\\d+)(\\\\.\\\\d+)*$"
      ].freeze

      def hierarchical_candidate?(custom_field)
        return false unless custom_field.respond_to?(:field_format)
        return false unless custom_field.field_format == "string"

        regexp = custom_field.respond_to?(:regexp) ? custom_field.regexp.to_s.strip : ""
        SOURCE_PATTERNS.include?(regexp)
      end
    end
  end
end
