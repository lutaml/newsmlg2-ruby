# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Newsmlg2::Base do
  def model_for(*groups, &block)
    Class.new(Newsmlg2::NarModel) do
      groups.each { |g| include g }
      class_eval(&block) if block
    end
  end

  it 'merges CommonPowerAttributes wire names' do
    klass = model_for(Newsmlg2::Base::CommonPowerAttributes) do
      xml { element 'holder' }
    end
    model = klass.from_xml(
      '<holder xmlns="http://iptc.org/std/nar/2006-10-01/" id="i1" creator="c1" ' \
      'creatoruri="http://ex.test/c1" modified="2020-06-22" custom="true" ' \
      'how="h" howuri="http://ex.test/h" why="w" whyuri="http://ex.test/w" ' \
      'pubconstraint="p1" pubconstrainturi="http://ex.test/p1"/>'
    )
    expect(model.id).to eq('i1')
    expect(model.creatoruri).to eq('http://ex.test/c1')
    expect(model.pubconstraint).to eq('p1')
    xml = model.to_xml
    expect(xml).to include('creatoruri="http://ex.test/c1"')
    expect("<r>#{xml}</r>").to be_xml_equivalent_to(
      "<r>#{klass.from_xml(model.to_xml).to_xml}</r>"
    )
  end

  it 'maps xml:lang through I18NAttributes' do
    klass = model_for(Newsmlg2::Base::I18NAttributes) do
      xml { element 'holder' }
    end
    model = klass.from_xml(
      '<holder xmlns="http://iptc.org/std/nar/2006-10-01/" xml:lang="de" dir="ltr"/>'
    )
    expect(model.xml_lang).to eq('de')
    expect(model.dir).to eq('ltr')
    expect(model.to_xml).to include('xml:lang="de" dir="ltr"')
  end

  it 'stacks multiple attribute groups' do
    klass = model_for(
      Newsmlg2::Base::CommonPowerAttributes,
      Newsmlg2::Base::QuantifyAttributes,
      Newsmlg2::Base::RankingAttributes
    ) do
      xml { element 'holder' }
    end
    model = klass.from_xml(
      '<holder xmlns="http://iptc.org/std/nar/2006-10-01/" id="i" ' \
      'confidence="80" relevance="90" rank="2"/>'
    )
    expect(model.confidence).to eq('80')
    expect(model.relevance).to eq('90')
    expect(model.rank).to eq('2')
  end

  it 'declares the full NewsContentCharacteristics attribute surface' do
    klass = model_for(Newsmlg2::Base::NewsContentCharacteristics) do
      xml { element 'holder' }
    end
    xml = klass.from_xml(
      '<holder xmlns="http://iptc.org/std/nar/2006-10-01/" charcount="1234" ' \
      'resolution="300" videoscan="progressive" audiobitrate="128000"/>'
    )
    expect(xml.charcount).to eq('1234')
    expect(xml.videoscan).to eq('progressive')
    expect(xml.audiobitrate).to eq('128000')
  end

  it 'covers Flex and Qualifying attribute sets' do
    flex = model_for(Newsmlg2::Base::FlexAttributes) { xml { element 'a' } }
    m = flex.from_xml('<a xmlns="http://iptc.org/std/nar/2006-10-01/" qcode="ninat:text" type="t" typeuri="http://x.test/t" literal="L"/>')
    expect(m.qcode).to eq('ninat:text')
    expect(m.literal).to eq('L')

    qual = model_for(Newsmlg2::Base::QualifyingAttributes) { xml { element 'b' } }
    q = qual.from_xml('<b xmlns="http://iptc.org/std/nar/2006-10-01/" role="r" roleuri="http://x.test/r" qcode="medtop:1"/>')
    expect(q.role).to eq('r')
    expect(q.qcode).to eq('medtop:1')
  end
end
