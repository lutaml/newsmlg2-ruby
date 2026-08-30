# frozen_string_literal: true

module Newsmlg2
  # A rendition of the content using an XML language; the content is
  # captured raw (any XML language, e.g. NITF).
  class InlineXML < Newsmlg2::NarModel
    include Newsmlg2::Base::NewsContentAttributes
    include Newsmlg2::Base::NewsContentTypeAttributes
    include Newsmlg2::Base::NewsContentCharacteristics
    include Newsmlg2::Base::I18NAttributes

    attribute :content, :string

    xml do
      element 'inlineXML'
      map_all to: :content
    end
  end

  # A rendition of the content using plain-text or encoded inline data.
  class InlineData < Newsmlg2::NarModel
    include Newsmlg2::Base::NewsContentAttributes
    include Newsmlg2::Base::NewsContentTypeAttributes
    include Newsmlg2::Base::NewsContentCharacteristics
    include Newsmlg2::Base::I18NAttributes

    xml_attributes content_encoding: 'encoding', encodinguri: 'encodinguri'

    attribute :content, :string

    xml do
      element 'inlineData'
      map_content to: :content
    end
  end

  # Information about a specific content channel.
  class Channel < Newsmlg2::NarModel
    include Newsmlg2::Base::CommonPowerAttributes
    include Newsmlg2::Base::NewsContentCharacteristics

    xml_attributes :chnlid, :type, :typeuri, :role, :roleuri, :language, :g2flag

    xml do
      element 'channel'
    end
  end

  # An alternative location of the content.
  class AltLoc < Newsmlg2::NarModel
    include Newsmlg2::Base::CommonPowerAttributes

    xml_content

    xml_attributes :type, :typeuri, :role, :roleuri

    xml do
      element 'altLoc'
    end
  end

  # A rendition of the content using a reference to a resource representing
  # the content data at a remote location.
  class RemoteContent < Newsmlg2::NarModel
    include Newsmlg2::Base::NewsContentAttributes
    include Newsmlg2::Base::TargetResourceAttributes
    include Newsmlg2::Base::TimeValidityAttributes
    include Newsmlg2::Base::NewsContentCharacteristics

    xml_attributes :language

    xml_element :channels, xml: 'channel',
                           type: Newsmlg2::Channel, collection: true
    xml_element :alt_ids, xml: 'altId',
                          type: Newsmlg2::Types::AltId, collection: true
    xml_element :alt_locs, xml: 'altLoc',
                           type: Newsmlg2::AltLoc, collection: true
    xml_element :hashes, xml: 'hash',
                         type: Newsmlg2::Types::Hash, collection: true
    xml_element :signals, xml: 'signal',
                          type: Newsmlg2::Types::Signal, collection: true
    xml_element :remote_content_ext_properties, xml: 'remoteContentExtProperty',
                                                type: Newsmlg2::Types::Flex2ExtPropType, collection: true

    xml do
      element 'remoteContent'
    end
  end

  # A set of alternate renditions of the Item content (a choice of
  # inlineXML | inlineData | remoteContent+).
  class ContentSet < Newsmlg2::NarModel
    include Newsmlg2::Base::CommonPowerAttributes

    xml_attributes :original

    xml_element :inlinexml, xml: 'inlineXML',
                            type: Newsmlg2::InlineXML, collection: true
    xml_element :inlinedata, xml: 'inlineData',
                             type: Newsmlg2::InlineData, collection: true
    xml_element :remote_contents, xml: 'remoteContent',
                                  type: Newsmlg2::RemoteContent, collection: true

    xml do
      element 'contentSet'
    end
  end

  # An Item containing news-related information.
  class NewsItem < AnyItem
    xml_element :content_meta, xml: 'contentMeta',
                               type: Newsmlg2::ContentMeta
    xml_element :part_metas, xml: 'partMeta',
                             type: Newsmlg2::PartMeta, collection: true
    xml_element :asserts, xml: 'assert',
                          type: Newsmlg2::Assert, collection: true
    xml_element :inline_refs, xml: 'inlineRef',
                              type: Newsmlg2::InlineRef, collection: true
    xml_element :derived_from, xml: 'derivedFrom',
                               type: Newsmlg2::DerivedFrom, collection: true
    xml_element :derived_from_values, xml: 'derivedFromValue',
                                      type: Newsmlg2::DerivedFromValue, collection: true
    xml_element :content_set, xml: 'contentSet',
                              type: Newsmlg2::ContentSet

    xml do
      element 'newsItem'
    end
  end
end
