# frozen_string_literal: true

module Newsmlg2
  module Types
    # The editorial urgency of the content (1-9), as scoped by the parent
    # element.
    class Urgency < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes

      xml_content

      xml do
        element 'urgency'
      end
    end

    # Indicates the source type from which the content was created.
    class DigitalSourceType < FlexPropType
    end

    # An iconic visual identification of the content.
    class Icon < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes
      include Newsmlg2::Base::TargetResourceAttributes
      include Newsmlg2::Base::MediaContentCharacteristics1

      xml_attributes :rendition, :renditionuri

      xml do
        element 'icon'
      end
    end

    # The type covering all qualifiers for an audience property.
    class AudienceType < Flex1PropType
      include Newsmlg2::Base::QuantifyAttributes

      xml_attributes :significance
    end

    # An intended audience for the content.
    class Audience < AudienceType
    end

    # An excluded audience for the content.
    class ExclAudience < AudienceType
    end

    # Expresses the rating of the content of this item by a party.
    class Rating < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes

      xml_attributes(
        :value, :valcalctype, :valcalctypeuri,
        :scalemin, :scalemax, :scaleunit, :scaleunituri,
        :raters, :ratertype, :ratertypeuri, :ratingtype, :ratingtypeuri
      )
    end

    # Reflects a specific kind of user interaction with the content.
    class UserInteraction < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes

      xml_attributes :interactions, :interactiontype, :interactiontypeuri
    end

    # A name for a concept assigned as property value of a language.
    class LanguageName < IntlStringType
    end

    # A language used by the news content.
    class Language < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes
      include Newsmlg2::Base::RankingAttributes

      xml_attributes :tag, :role, :roleuri

      xml_element :names, xml: 'name',
                          type: Newsmlg2::Types::LanguageName, collection: true

      xml do
        element 'language'
      end
    end

    # A nature, intellectual or journalistic form of the content.
    class Genre < Flex1ConceptPropType
      include Newsmlg2::Base::RankingAttributes
    end

    # Free-text term for indexing or finding the content.
    class Keyword < IntlStringType
      include Newsmlg2::Base::RankingAttributes

      xml_attributes :role, :roleuri, :confidence, :relevance

      xml do
        element 'keyword'
      end
    end

    # An important topic of the content; what the content is about.
    class Subject < Flex1ConceptPropType
      include Newsmlg2::Base::RankingAttributes
    end

    # A sequence of tokens associated with the content.
    class Slugline < IntlStringType
      include Newsmlg2::Base::RankingAttributes

      xml_attributes :separator, :role, :roleuri, :confidence, :relevance

      xml do
        element 'slugline'
      end
    end

    # A brief and snappy introduction to the content.
    class Headline < Label1Type
      include Newsmlg2::Base::RankingAttributes

      xml_attributes :confidence, :relevance

      xml do
        element 'headline'
      end
    end

    # A natural-language statement of the date and/or place of creation of
    # the content.
    class Dateline < Label1Type
      include Newsmlg2::Base::RankingAttributes
    end

    # A natural-language statement about the creator of the content.
    class By < Label1Type
      include Newsmlg2::Base::RankingAttributes
    end

    # A free-form expression of the credit(s) for the content.
    class Creditline < IntlStringType
      include Newsmlg2::Base::RankingAttributes
    end

    # A free-form textual description of the content of the item.
    class ContentDescription < BlockType
      include Newsmlg2::Base::RankingAttributes

      xml_attributes :confidence, :relevance
    end
  end
end
