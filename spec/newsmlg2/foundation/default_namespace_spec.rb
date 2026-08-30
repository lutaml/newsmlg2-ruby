# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'foundation: default NAR namespace and attribute basics' do
  let(:model_class) do
    Class.new(Newsmlg2::NarModel) do
      attribute :guid, :string
      attribute :lang, Newsmlg2::Types::XmlLang
      attribute :standard, :string, default: -> { 'NewsML-G2' }

      xml do
        element 'newsItem'
        map_attribute 'guid', to: :guid
        map_attribute 'lang', to: :lang
        map_attribute 'standard', to: :standard, render_default: true
      end
    end
  end

  it 'parses an element in the default NAR namespace' do
    model = model_class.from_xml(
      '<newsItem xmlns="http://iptc.org/std/nar/2006-10-01/" guid="g1" xml:lang="en-GB"/>'
    )
    expect(model.guid).to eq('g1')
    expect(model.lang).to eq('en-GB')
    expect(model.standard).to eq('NewsML-G2')
  end

  it 'serializes with the default xmlns and xml:lang, defaults rendered' do
    xml = model_class.new(guid: 'g1', lang: 'en-GB').to_xml
    expect(xml).to eq(
      '<newsItem xmlns="http://iptc.org/std/nar/2006-10-01/" ' \
      'guid="g1" xml:lang="en-GB" standard="NewsML-G2"/>'
    )
  end

  it 'omits nil attributes' do
    expect(model_class.new.to_xml)
      .to eq('<newsItem xmlns="http://iptc.org/std/nar/2006-10-01/" standard="NewsML-G2"/>')
  end

  it 'emits an XML declaration on demand' do
    xml = model_class.new.to_xml(declaration: true)
    expect(xml).to start_with("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n")
  end

  it 'tolerates unknown child elements on parse' do
    model = model_class.from_xml(
      '<newsItem xmlns="http://iptc.org/std/nar/2006-10-01/" guid="g1">' \
      '<unknownExtension>dropped</unknownExtension></newsItem>'
    )
    expect(model.guid).to eq('g1')
  end
end
