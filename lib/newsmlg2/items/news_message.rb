# frozen_string_literal: true

module Newsmlg2
  # The type of a plain string value (NewsMessage local type): content plus
  # common attributes.
  class StringType < Newsmlg2::NarModel
    include Newsmlg2::Base::CommonPowerAttributes

    xml_content
  end

  # The date-and-time of transmission of the message.
  class Sent < Newsmlg2::Types::DateTimePropType
    xml do
      element 'sent'
    end
  end

  # The sender of the items, which may be an organisation or a person.
  class Sender < StringType
    include Newsmlg2::Base::QualifyingAttributes
  end

  # The transmission identifier associated with the message.
  class TransmitId < StringType
    xml do
      element 'transmitId'
    end
  end

  # The priority of this message in the overall transmission process (1 =
  # highest, 9 = lowest).
  class Priority < Newsmlg2::NarModel
    include Newsmlg2::Base::CommonPowerAttributes

    xml_content

    xml do
      element 'priority'
    end
  end

  # The point of origin of the transmission of this message.
  class Origin < StringType
    include Newsmlg2::Base::QualifyingAttributes
  end

  # A date-and-time associated with the message, other than the
  # date-and-time the message was sent.
  class MessageTimestamp < Newsmlg2::Types::DateTimePropType
    xml_attributes :role

    xml do
      element 'timestamp'
    end
  end

  # A point of destination for this message.
  class Destination < StringType
    include Newsmlg2::Base::QualifyingAttributes
  end

  # A transmission channel used by the message.
  class MessageChannel < StringType
    include Newsmlg2::Base::QualifyingAttributes

    xml_attributes :g2flag
  end

  # A group of properties providing information about the exchange.
  class Header < Newsmlg2::NarModel
    xml_element :sent, xml: 'sent', type: Newsmlg2::Sent
    xml_element :catalog_refs, xml: 'catalogRef',
                               type: Newsmlg2::CatalogRef, collection: true
    xml_element :catalogs, xml: 'catalog',
                           type: Newsmlg2::Catalog, collection: true
    xml_element :sender, xml: 'sender', type: Newsmlg2::Sender
    xml_element :transmit_id, xml: 'transmitId',
                              type: Newsmlg2::TransmitId
    xml_element :priority, xml: 'priority',
                           type: Newsmlg2::Priority
    xml_element :origin, xml: 'origin', type: Newsmlg2::Origin
    xml_element :timestamps, xml: 'timestamp',
                             type: Newsmlg2::MessageTimestamp, collection: true
    xml_element :destinations, xml: 'destination',
                               type: Newsmlg2::Destination, collection: true
    xml_element :channels, xml: 'channel',
                           type: Newsmlg2::MessageChannel, collection: true
    xml_element :signals, xml: 'signal',
                          type: Newsmlg2::Types::Signal, collection: true
    xml_element :header_ext_properties, xml: 'headerExtProperty',
                                        type: Newsmlg2::Types::Flex2ExtPropType, collection: true

    xml do
      element 'header'
    end
  end

  # The set of items to be exchanged. The XSD models itemSet content as
  # xs:any over NewsML-G2 items; each carried item type is mapped with its
  # own element rule and a registry-resolved symbol type (the plurimath/mml
  # CommonElements pattern — element names live only in this DSL).
  class ItemSet < Newsmlg2::NarModel
    include Newsmlg2::Base::CommonPowerAttributes

    attribute :news_items, :newsItem, collection: true
    attribute :package_items, :packageItem, collection: true
    attribute :concept_items, :conceptItem, collection: true
    attribute :knowledge_items, :knowledgeItem, collection: true
    attribute :catalog_items, :catalogItem, collection: true
    attribute :planning_items, :planningItem, collection: true
    attribute :news_messages, :newsMessage, collection: true

    xml do
      element 'itemSet'
      map_element 'newsItem', to: :news_items
      map_element 'packageItem', to: :package_items
      map_element 'conceptItem', to: :concept_items
      map_element 'knowledgeItem', to: :knowledge_items
      map_element 'catalogItem', to: :catalog_items
      map_element 'planningItem', to: :planning_items
      map_element 'newsMessage', to: :news_messages
    end

    # All carried items (grouped by item type — the model keeps per-type
    # collections, as lutaml-model mappings are name-keyed).
    def items
      news_items + package_items + concept_items + knowledge_items +
        catalog_items + planning_items + news_messages
    end
  end

  # A container to exchange one or more items.
  class NewsMessage < Newsmlg2::NarModel
    xml_element :header, xml: 'header', type: Newsmlg2::Header
    xml_element :item_set, xml: 'itemSet', type: Newsmlg2::ItemSet

    xml do
      element 'newsMessage'
    end
  end
end
