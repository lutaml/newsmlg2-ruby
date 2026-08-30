# frozen_string_literal: true

module Newsmlg2
  module Types
    # An expression of rights in natural language or as a reference to
    # remote information.
    class RightsBlockType < BlockType
      xml_attributes :href
    end

    # Any necessary copyright notice for claiming the intellectual property
    # for the content.
    class CopyrightNotice < RightsBlockType
    end

    # A natural-language statement about the usage terms pertaining to the
    # content.
    class UsageTerms < RightsBlockType
    end

    # A rights expression serialized using XML encoding (content is a raw
    # fragment of the rights expression language).
    class RightsExpressionXML < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes

      xml_attributes :langid

      attribute :content, :string

      xml do
        element 'rightsExpressionXML'
        map_all to: :content
      end
    end

    # A rights expression serialized using any specific encoding except XML.
    class RightsExpressionData < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes

      xml_attributes :langid, :enctype

      attribute :content, :string

      xml do
        element 'rightsExpressionData'
        map_all to: :content
      end
    end

    # A set of properties representing the rights associated with the Item.
    # copyrightHolder/accountable/dataMining reuse the flex party/person/prop
    # types directly — python-newsmlg2's subclasses added no structure.
    class RightsInfo < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes
      include Newsmlg2::Base::I18NAttributes
      include Newsmlg2::Base::TimeValidityAttributes

      xml_attributes :idrefs, :scope, :scopeuri, :aspect, :aspecturi

      xml_element :accountable, xml: 'accountable',
                                type: Newsmlg2::Types::FlexPersonPropType
      xml_element :copyright_holder, xml: 'copyrightHolder',
                                     type: Newsmlg2::Types::FlexPartyPropType
      xml_element :copyright_notices, xml: 'copyrightNotice',
                                      type: Newsmlg2::Types::CopyrightNotice, collection: true
      xml_element :usage_terms, xml: 'usageTerms',
                                type: Newsmlg2::Types::UsageTerms, collection: true
      xml_element :links, xml: 'link',
                          type: Newsmlg2::Types::Link, collection: true
      xml_element :rights_info_ext_properties, xml: 'rightsInfoExtProperty',
                                               type: Newsmlg2::Types::Flex2ExtPropType, collection: true
      xml_element :rights_expression_xmls, xml: 'rightsExpressionXML',
                                           type: Newsmlg2::Types::RightsExpressionXML, collection: true
      xml_element :rights_expression_datas, xml: 'rightsExpressionData',
                                            type: Newsmlg2::Types::RightsExpressionData, collection: true
      xml_element :data_mining, xml: 'dataMining',
                                type: Newsmlg2::Types::FlexPropType

      xml do
        element 'rightsInfo'
      end
    end
  end
end
