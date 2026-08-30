# frozen_string_literal: true

require 'newsmlg2'

require 'lutaml/model'
Lutaml::Model::Config.configure do |config|
  config.xml_adapter_type = :nokogiri
end

require 'canon'
Canon::Config.configure do |config|
  config.xml.match.profile = :spec_friendly
  config.xml.diff.algorithm = :semantic
  config.xml.diff.max_node_count = 50_000
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.run_all_when_everything_filtered = true
  config.example_status_persistence_file_path = 'spec/examples.txt'
  config.disable_monkey_patching!
  config.warnings = true
  config.default_formatter = 'doc' if config.files_to_run.one?

  config.profile_examples = 10
  config.order = :random
  Kernel.srand config.seed
end
