module OpenProject
  module HierarchicalSort
    module SqlBuilder
      module_function

      def hierarchical_validity_statement(custom_field)
        <<~SQL.squish
          COALESCE((SELECT CASE WHEN cv_sort.value ~ '#{FieldMatcher::VALUE_MATCH_SQL}' THEN '0' ELSE '1' END
                    FROM #{CustomValue.quoted_table_name} cv_sort
                    WHERE #{cv_sort_only_custom_field_condition_sql(custom_field)}
                    LIMIT 1), '1')
        SQL
      end

      def hierarchical_array_statement(custom_field)
        <<~SQL.squish
          COALESCE((SELECT CASE
                     WHEN cv_sort.value ~ '#{FieldMatcher::VALUE_MATCH_SQL}' THEN (
                       SELECT string_agg(lpad(part, 8, '0'), '.' ORDER BY ord)
                       FROM unnest(string_to_array(cv_sort.value, '.')) WITH ORDINALITY AS parts(part, ord)
                     )
                     ELSE '' END
                    FROM #{CustomValue.quoted_table_name} cv_sort
                    WHERE #{cv_sort_only_custom_field_condition_sql(custom_field)}
                    LIMIT 1), '')
        SQL
      end

      def fallback_string_statement(custom_field)
        <<~SQL.squish
          COALESCE((SELECT cv_sort.value
                    FROM #{CustomValue.quoted_table_name} cv_sort
                    WHERE #{cv_sort_only_custom_field_condition_sql(custom_field)}
                    LIMIT 1), '')
        SQL
      end

      def cv_sort_only_custom_field_condition_sql(custom_field)
        <<~SQL.squish
          cv_sort.customized_type='#{custom_field.class.customized_class.name}'
          AND cv_sort.customized_id=#{custom_field.class.customized_class.quoted_table_name}.id
          AND cv_sort.custom_field_id=#{custom_field.id}
        SQL
      end
    end
  end
end
