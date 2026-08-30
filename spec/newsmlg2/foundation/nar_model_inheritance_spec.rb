# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'foundation: NarModel inheritance and group-mixin composition' do
  let(:attribute_group) do
    Module.new do
      def self.included(klass)
        klass.class_eval do
          attribute :id, :string
          xml do
            map_attribute 'id', to: :id
          end
        end
      end
    end
  end

  let(:element_group) do
    Module.new
  end

  let(:child_class) do
    group = attribute_group
    Class.new(Newsmlg2::NarModel) do
      include group

      attribute :own, :string
      xml do
        element 'child'
        map_element 'own', to: :own
      end
    end
  end

  let(:grandchild_class) do
    parent = child_class
    Class.new(parent) do
      xml do
        element 'grandchild'
      end
    end
  end

  it 'inherits the NAR namespace from NarModel without redeclaring it' do
    expect(child_class.new(id: 'a1', own: 'v').to_xml).to eq(
      "<child xmlns=\"http://iptc.org/std/nar/2006-10-01/\" id=\"a1\">\n  " \
      "<own>v</own>\n" \
      '</child>'
    )
  end

  it 'carries mixin attribute mappings into subclasses' do
    xml = grandchild_class.new(id: 'a2', own: 'v2').to_xml
    expect(xml).to eq(
      "<grandchild xmlns=\"http://iptc.org/std/nar/2006-10-01/\" id=\"a2\">\n  " \
      "<own>v2</own>\n" \
      '</grandchild>'
    )
  end

  it 'parses mixin-declared attributes and own elements' do
    model = child_class.from_xml(
      '<child xmlns="http://iptc.org/std/nar/2006-10-01/" id="z"><own>w</own></child>'
    )
    expect(model.id).to eq('z')
    expect(model.own).to eq('w')
  end
end
