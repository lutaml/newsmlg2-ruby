# frozen_string_literal: true

require_relative 'lib/newsmlg2/version'

Gem::Specification.new do |spec|
  spec.name          = 'newsmlg2'
  spec.version       = Newsmlg2::VERSION
  spec.authors       = ['Ribose Inc.']
  spec.email         = ['open.source@ribose.com']

  spec.summary       = 'NewsML-G2 — IPTC News Architecture (NewsML-G2) for Ruby.'
  spec.description   = 'Newsmlg2 provides a lutaml-model-based Ruby object model for IPTC ' \
                       'NewsML-G2 (NAR). Parse, manipulate, build and serialize NewsML-G2 ' \
                       'XML with full round-trip fidelity, including a builder DSL.'
  spec.homepage      = 'https://github.com/lutaml/newsmlg2-ruby'
  spec.license       = 'BSD-2-Clause'
  spec.required_ruby_version = Gem::Requirement.new('>= 3.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/lutaml/newsmlg2-ruby'
  spec.metadata['changelog_uri'] = 'https://github.com/lutaml/newsmlg2-ruby/blob/main/CHANGELOG.md'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features|tools)/})
    end
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'lutaml-model', '~> 0.8.0'
end
