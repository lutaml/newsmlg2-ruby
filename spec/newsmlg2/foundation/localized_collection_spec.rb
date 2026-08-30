# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'foundation: localized content collections' do
  let(:name_class) do
    Class.new(Newsmlg2::NarModel) do
      attribute :lang, Newsmlg2::Types::XmlLang
      attribute :text, :string

      xml do
        element 'name'
        map_attribute 'lang', to: :lang
        map_content to: :text
      end
    end
  end

  let(:holder_class) do
    name = name_class
    Class.new(Newsmlg2::NarModel) do
      attribute :names, name, collection: true

      xml do
        element 'holder'
        map_element 'name', to: :names
      end
    end
  end

  it 'parses per-element xml:lang in collections' do
    holder = holder_class.from_xml(
      '<holder xmlns="http://iptc.org/std/nar/2006-10-01/">' \
      '<name xml:lang="en">Berlin</name><name xml:lang="de">Berlin</name>' \
      '</holder>'
    )
    expect(holder.names.map { |n| [n.lang, n.text] })
      .to eq([%w[en Berlin], %w[de Berlin]])
  end

  it "serializes collections with each element's xml:lang" do
    holder = holder_class.new(
      names: [name_class.new(lang: 'en', text: 'Berlin'),
              name_class.new(lang: 'de', text: 'Berlin')]
    )
    expect(holder.to_xml).to eq(
      "<holder xmlns=\"http://iptc.org/std/nar/2006-10-01/\">\n  " \
      "<name xml:lang=\"en\">Berlin</name>\n  " \
      "<name xml:lang=\"de\">Berlin</name>\n" \
      '</holder>'
    )
  end
end
