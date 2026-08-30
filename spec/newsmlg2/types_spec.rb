# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Newsmlg2::Types do
  let(:holder_class) do
    Class.new(Newsmlg2::NarModel) do
      attribute :version_created, Newsmlg2::Types::DateTimePropType
      attribute :title, Newsmlg2::Types::IntlStringType, collection: true
      attribute :name, Newsmlg2::Types::ConceptNameType, collection: true

      xml do
        element 'holder'
        map_element 'versionCreated', to: :version_created
        map_element 'title', to: :title
        map_element 'name', to: :name
      end
    end
  end

  it 'parses a content-bearing property with common attributes' do
    holder = holder_class.from_xml(
      '<holder xmlns="http://iptc.org/std/nar/2006-10-01/">' \
      '<versionCreated id="vc1" modified="2020-06-22">2020-06-22T12:00:00+03:00</versionCreated>' \
      '</holder>'
    )
    expect(holder.version_created.text).to eq('2020-06-22T12:00:00+03:00')
    expect(holder.version_created.id).to eq('vc1')
    expect(holder.version_created.modified).to eq('2020-06-22')
  end

  it 'round-trips typed content properties' do
    xml = '<holder xmlns="http://iptc.org/std/nar/2006-10-01/">' \
          '<versionCreated>2020-06-22T12:00:00+03:00</versionCreated></holder>'
    expect("<r>#{holder_class.from_xml(xml).to_xml}</r>").to be_xml_equivalent_to("<r>#{xml}</r>")
  end

  it 'parses internationalized strings with xml:lang and dir' do
    holder = holder_class.from_xml(
      '<holder xmlns="http://iptc.org/std/nar/2006-10-01/">' \
      '<title xml:lang="ar" dir="rtl">عنوان</title><title xml:lang="en">Title</title>' \
      '</holder>'
    )
    expect(holder.title.map { |t| [t.xml_lang, t.dir, t.text] })
      .to eq([%w[ar rtl عنوان], ['en', nil, 'Title']])
  end

  it 'parses concept names with role/part refinements and validity' do
    holder = holder_class.from_xml(
      '<holder xmlns="http://iptc.org/std/nar/2006-10-01/">' \
      '<name xml:lang="en" role="nrol:short" part="nprt:given" ' \
      'validfrom="2020-01-01">Bob</name></holder>'
    )
    name = holder.name.first
    expect(name.text).to eq('Bob')
    expect(name.role).to eq('nrol:short')
    expect(name.part).to eq('nprt:given')
    expect(name.validfrom).to eq('2020-01-01')
    expect(name).to be_a(Newsmlg2::Types::Name)
  end

  it 'supports VersionedStringType versioninfo attribute' do
    klass = Class.new(Newsmlg2::NarModel) do
      attribute :generator, Newsmlg2::Types::VersionedStringType

      xml do
        element 'holder'
        map_element 'generator', to: :generator
      end
    end
    model = klass.from_xml(
      '<holder xmlns="http://iptc.org/std/nar/2006-10-01/">' \
      '<generator versioninfo="2">AcmeGen</generator></holder>'
    )
    expect(model.generator.text).to eq('AcmeGen')
    expect(model.generator.versioninfo).to eq('2')
  end
end
