# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Newsmlg2 do
  it 'has a semver version' do
    expect(Newsmlg2::VERSION).to match(/\A\d+\.\d+\.\d+/)
  end
end
