require "open_project/plugins"
require_relative "field_matcher"
require_relative "sql_builder"
require_relative "patches/custom_field_order_statements_patch"
require_relative "patches/query_results_patch"

module OpenProject
  module HierarchicalSort
    class Engine < ::Rails::Engine
      engine_name :openproject_hierarchical_sort

      include OpenProject::Plugins::ActsAsOpEngine

      register "openproject-hierarchical_sort",
               author_url: "https://example.invalid",
               bundled: false do
        name "OpenProject Hierarchical Sort"
        author "OpenClaw"
        description "Natural sorting for dotted numeric custom fields"
        version OpenProject::HierarchicalSort::VERSION
      end

      config.to_prepare do
        if defined?(CustomField::OrderStatements) &&
           !CustomField::OrderStatements.ancestors.include?(OpenProject::HierarchicalSort::Patches::CustomFieldOrderStatementsPatch)
          CustomField::OrderStatements.prepend(OpenProject::HierarchicalSort::Patches::CustomFieldOrderStatementsPatch)
        end

        if defined?(Query::Results) &&
           !Query::Results.ancestors.include?(OpenProject::HierarchicalSort::Patches::QueryResultsPatch)
          Query::Results.prepend(OpenProject::HierarchicalSort::Patches::QueryResultsPatch)
        end
      end
    end
  end
end
