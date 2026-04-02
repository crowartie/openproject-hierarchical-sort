require_relative "../field_matcher"
require_relative "../sql_builder"

module OpenProject
  module HierarchicalSort
    module Patches
      module CustomFieldOrderStatementsPatch
        def order_statements
          return hierarchical_order_statements if FieldMatcher.hierarchical_candidate?(self)
          super
        end

        # Compatibility shim for OpenProject variants that may call singular form.
        def order_statement
          order_statements
        end

        private

        def hierarchical_order_statements
          [
            SqlBuilder.hierarchical_validity_statement(self),
            SqlBuilder.hierarchical_array_statement(self),
            SqlBuilder.fallback_string_statement(self)
          ]
        end
      end
    end
  end
end
