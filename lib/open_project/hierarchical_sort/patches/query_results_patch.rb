require_relative "../field_matcher"

module OpenProject
  module HierarchicalSort
    module Patches
      module QueryResultsPatch
        def case_insensitive_condition(column_key, condition, columns_hash)
          return condition if hierarchical_sort_custom_field?(column_key)

          super
        end

        private

        def hierarchical_sort_custom_field?(column_key)
          column = query.sortable_columns.detect { |candidate| candidate.name.to_s == column_key.to_s }
          return false unless column&.respond_to?(:custom_field)

          custom_field = column.custom_field
          return false unless custom_field

          FieldMatcher.hierarchical_candidate?(custom_field)
        end
      end
    end
  end
end
