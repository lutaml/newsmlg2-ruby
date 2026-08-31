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

    # One collection attribute + element rule per registered item type,
    # generated from the registry (newsItem -> news_items): the single
    # source of truth for the carried item types. Registration order is
    # declaration order, so serialized child order is stable.
    ITEM_ELEMENTS = Newsmlg2::Configuration.models.map do |model_id, _klass|
      [model_id, :"#{Newsmlg2::Configuration.snake(model_id)}s"]
    end.freeze

    ITEM_ATTRIBUTES = ITEM_ELEMENTS.map(&:last).freeze

    ITEM_ELEMENTS.each do |model_id, plural|
      attribute plural, model_id, collection: true
      xml { map_element model_id.to_s, to: plural }
    end

    xml do
      element 'itemSet'
    end

    # All carried items (grouped by item type — the model keeps per-type
    # collections, as lutaml-model mappings are name-keyed).
    def items
      ITEM_ATTRIBUTES.flat_map { |name| send(name) }
    end
  end

  # A container to exchange one or more items.
  class NewsMessage < Newsmlg2::NarModel
    xml_element :header, xml: 'header', type: Newsmlg2::Header
    xml_element :item_set, xml: 'itemSet', type: Newsmlg2::ItemSet

    xml do
      element 'newsMessage'
    end

    # The elements of this message that carry catalogs and catalogRefs for
    # the document's CatalogStore (a newsMessage carries them on its header).
    def catalog_holders
      header ? [header] : []
    end
  end
end
