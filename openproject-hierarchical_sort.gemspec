require_relative "lib/open_project/hierarchical_sort/version"

Gem::Specification.new do |spec|
  spec.name          = "openproject-hierarchical_sort"
  spec.version       = OpenProject::HierarchicalSort::VERSION
  spec.authors       = ["OpenClaw"]
  spec.email         = ["noreply@example.invalid"]
  spec.summary       = "Natural sorting for dotted numeric string custom fields in OpenProject"
  spec.description   = "Adds segment-aware natural sorting for OpenProject string custom fields validated as dotted numeric identifiers"
  spec.homepage      = "https://example.invalid/openproject-hierarchical_sort"
  spec.license       = "GPL-3.0-or-later"
  spec.files         = Dir.chdir(File.expand_path(__dir__)) { Dir["README.md", "lib/**/*.rb"] }
  spec.require_paths = ["lib"]
end
