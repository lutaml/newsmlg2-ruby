# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'foundation: raw foreign content via map_all' do
  let(:inline_class) do
    Class.new(Newsmlg2::NarModel) do
      attribute :content, :string

      xml do
        element 'inlineXML'
        map_all to: :content
      end
    end
  end

  NAR = 'http://iptc.org/std/nar/2006-10-01/'

  let(:nitf_body) do
    '<nitf:nitf xmlns:nitf="http://iptc.org/std/NITF/2006-10-18/">' \
      '<nitf:body><nitf:body.content><p>Hello</p></nitf:body.content></nitf:body>' \
      '</nitf:nitf>'
  end

  let(:source) { "<inlineXML xmlns=\"#{NAR}\">#{nitf_body}</inlineXML>" }

  it 'captures foreign-namespace children verbatim' do
    inline = inline_class.from_xml(source)
    expect(inline.content).to include('nitf:nitf')
    expect(inline.content).to include('<p>Hello</p>')
  end

  it 'round-trips foreign content semantically' do
    inline = inline_class.from_xml(source)
    expect("<r>#{inline.to_xml}</r>").to be_xml_equivalent_to("<r>#{source}</r>")
  end
end
