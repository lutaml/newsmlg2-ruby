# frozen_string_literal: true

module Newsmlg2
  module Types
    # The recommended file name for this Item.
    class FileName < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes

      xml_content

      xml do
        element 'fileName'
      end
    end

    # The name and version of the software tool used to generate the Item.
    class Generator < VersionedStringType
      xml_attributes :role, :roleuri

      xml do
        element 'generator'
      end
    end

    # An instruction to the processor that the content requires special
    # handling.
    class Signal < Flex1PropType
      xml_attributes :severity, :severityuri

      xml do
        element 'signal'
      end
    end

    # An IRI which, upon dereferencing, provides an alternative
    # representation of the Item.
    class AltRep < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes
      include Newsmlg2::Base::TimeValidityAttributes
      include Newsmlg2::Base::NewsContentTypeAttributes

      xml_content

      xml_attributes :representation, :representationuri, :size

      xml do
        element 'altRep'
      end
    end

    # An IRI which, upon dereferencing, provides the original representation
    # of the Item.
    class OrigRep < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes

      xml_content

      xml_attributes :accesstype, :accesstypeuri, :reposrole, :reposroleuri

      xml do
        element 'origRep'
      end
    end

    # The identifier of an incoming feed.
    class IncomingFeedId < QCodePropType
      xml_attributes :role, :roleuri

      xml do
        element 'incomingFeedId'
      end
    end
  end
end
