# frozen_string_literal: true

module Newsmlg2
  module Types
    # Flexible person data type for both controlled and uncontrolled values.
    class FlexPersonPropType < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes
      include Newsmlg2::Base::FlexAttributes
      include Newsmlg2::Base::I18NAttributes
      include Newsmlg2::Base::ConceptDefinitionGroup
      include Newsmlg2::Base::ConceptRelationshipsGroup

      xml_element :person_details, xml: 'personDetails',
                                   type: Newsmlg2::Types::PersonDetails
    end

    # Flexible party (person or organisation) PCL-type for both controlled
    # and uncontrolled values.
    class FlexPartyPropType < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes
      include Newsmlg2::Base::FlexAttributes
      include Newsmlg2::Base::I18NAttributes
      include Newsmlg2::Base::ConceptDefinitionGroup
      include Newsmlg2::Base::ConceptRelationshipsGroup

      xml_element :person_details, xml: 'personDetails',
                                   type: Newsmlg2::Types::PersonDetails
      xml_element :organisation_details, xml: 'organisationDetails',
                                         type: Newsmlg2::Types::OrganisationDetails
    end

    # A party involved in a hop of the Hop History.
    class Party < FlexPartyPropType
      xml do
        element 'party'
      end
    end

    # FlexPartyPropType with a role refinement.
    class Flex1PartyPropType < FlexPartyPropType
      xml_attributes :role, :roleuri
    end

    # Flexible author (creator or contributor) PCL-type.
    class FlexAuthorPropType < FlexPartyPropType
      xml_attributes :role, :roleuri, :jobtitle, :jobtitleuri
    end
  end
end
