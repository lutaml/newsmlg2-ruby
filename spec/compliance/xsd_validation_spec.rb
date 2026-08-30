# frozen_string_literal: true

# Port of the official IPTC NewsML-G2 unit test suite
# (iptc/newsml-g2 tests/runtests.py): every should_pass file must validate
# against every schema version the runner checks it with, and every
# should_fail file must be rejected. The file x schema matrix is vendored
# from runtests.py as spec/fixtures/iptc/test_matrix.json.
require 'spec_helper'
require 'nokogiri'

RSpec.describe 'IPTC official XSD validation suite' do
  ROOT = Pathname.new('spec/fixtures/iptc')
  MATRIX = JSON.parse(File.read(ROOT.join('test_matrix.json')))

  def schema_for(version)
    @schemas ||= {}
    @schemas[version] ||= Nokogiri::XML::Schema(
      File.open(ROOT.join('schema_versions', MATRIX.fetch(version)['schema_file']))
    )
  end

  def validation_errors(version, path)
    document = Nokogiri::XML(File.read(path), &:strict)
    schema_for(version).validate(document)
  end

  # 2.23 is skipped exactly as in runtests.py (RightsML/ODRL dependency).
  (MATRIX.keys - %w[2.23]).sort.each do |version|
    config = MATRIX.fetch(version)

    describe "schema #{version}" do
      config['pass'].each do |folder|
        pass_dir = ROOT.join('unit_test_files', folder)
        next unless pass_dir.directory?

        Dir[pass_dir.join('*.xml')].each do |path|
          it "#{folder}/#{File.basename(path)} validates" do
            errors = validation_errors(version, path)
            expect(errors.map(&:message)).to be_empty,
                                             "expected valid, got: #{errors.map(&:message).join(' | ')}"
          end
        end
      end

      config['fail'].each do |folder|
        fail_dir = ROOT.join('unit_test_files', folder)
        next unless fail_dir.directory?

        Dir[fail_dir.join('*.xml')].each do |path|
          it "#{folder}/#{File.basename(path)} is rejected" do
            errors = validation_errors(version, path)
            expect(errors).not_to be_empty
          end
        end
      end
    end
  end
end
