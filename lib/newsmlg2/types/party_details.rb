# frozen_string_literal: true

module Newsmlg2
  module Types
    # The date the person was born.
    class Born < TruncatedDateTimePropType
      xml do
        element 'born'
      end
    end

    # The date the person died.
    class Died < TruncatedDateTimePropType
      xml do
        element 'died'
      end
    end

    # The type for an electronic address.
    class ElectronicAddressType < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes

      xml_attributes :role, :roleuri

      xml_content
    end

    # The type for an electronic address with a technical qualifier.
    class ElectronicAddressTechType < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes

      xml_attributes :role, :roleuri, :tech, :techuri

      xml_content
    end

    # An email address.
    class Email < ElectronicAddressType
      xml do
        element 'email'
      end
    end

    # An instant messaging address.
    class Im < ElectronicAddressTechType
      xml do
        element 'im'
      end
    end

    # A phone number, preferred in an international format.
    class Phone < ElectronicAddressTechType
      xml do
        element 'phone'
      end
    end

    # A fax number, preferred in an international format.
    class Fax < ElectronicAddressType
      xml do
        element 'fax'
      end
    end

    # A web address.
    class Web < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes

      xml_attributes :role, :roleuri

      xml_content

      xml do
        element 'web'
      end
    end

    # A line of address information.
    class AddressLine < IntlStringType
      xml_attributes :role, :roleuri

      xml do
        element 'line'
      end
    end

    # A subdivision of a country part of the address.
    class Area < Flex1RolePropType
    end

    # A postal code part of the address.
    class PostalCode < IntlStringType
      xml do
        element 'postalCode'
      end
    end

    # A country part of the address.
    class Country < Flex1PropType
    end

    # A city/town/village etc. part of the address.
    class Locality < Flex1RolePropType
    end

    # A world region part of an address.
    class WorldRegion < Flex1PropType
    end

    # A postal address for the location of a Point Of Interest.
    class Address < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes

      xml_attributes :role, :roleuri

      xml_element :lines, xml: 'line',
                          type: Newsmlg2::Types::AddressLine, collection: true
      xml_element :world_region, xml: 'worldRegion',
                                 type: Newsmlg2::Types::WorldRegion
      xml_element :localities, xml: 'locality',
                               type: Newsmlg2::Types::Locality, collection: true
      xml_element :areas, xml: 'area',
                          type: Newsmlg2::Types::Area, collection: true
      xml_element :country, xml: 'country',
                            type: Newsmlg2::Types::Country
      xml_element :postal_code, xml: 'postalCode',
                                type: Newsmlg2::Types::PostalCode

      xml do
        element 'address'
      end
    end

    # The type for information to get in contact with a party.
    class ContactInfoType < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes

      xml_attributes :role, :roleuri

      xml_element :emails, xml: 'email',
                           type: Newsmlg2::Types::Email, collection: true
      xml_element :ims, xml: 'im',
                        type: Newsmlg2::Types::Im, collection: true
      xml_element :phones, xml: 'phone',
                           type: Newsmlg2::Types::Phone, collection: true
      xml_element :faxes, xml: 'fax',
                          type: Newsmlg2::Types::Fax, collection: true
      xml_element :webs, xml: 'web',
                         type: Newsmlg2::Types::Web, collection: true
      xml_element :addresses, xml: 'address',
                              type: Newsmlg2::Types::Address, collection: true
      xml_element :notes, xml: 'note',
                          type: Newsmlg2::Types::Note, collection: true

      xml do
        element 'contactInfo'
      end
    end

    # The date the organisation was founded/established.
    class OrganisationFounded < TruncatedDateTimePropType
      xml do
        element 'founded'
      end
    end

    # The date the organisation was dissolved.
    class OrganisationDissolved < TruncatedDateTimePropType
      xml do
        element 'dissolved'
      end
    end

    # A place where the organisation is located.
    class OrganisationLocation < FlexLocationPropType
      xml do
        element 'location'
      end
    end

    # A financial instrument which is related to a company.
    class HasInstrument < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes

      xml_attributes(
        :symbol, :symbolsrc, :symbolsrcuri, :market, :marketuri,
        :marketlabel, :marketlabelsrc, :marketlabelsrcuri,
        :type, :typeuri, :rank
      )

      xml do
        element 'hasInstrument'
      end
    end

    # A group of properties specific to an organisation.
    class OrganisationDetails < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes

      xml_element :founded, xml: 'founded',
                            type: Newsmlg2::Types::OrganisationFounded
      xml_element :dissolved, xml: 'dissolved',
                              type: Newsmlg2::Types::OrganisationDissolved
      xml_element :locations, xml: 'location',
                              type: Newsmlg2::Types::OrganisationLocation, collection: true
      xml_element :contact_infos, xml: 'contactInfo',
                                  type: Newsmlg2::Types::ContactInfoType, collection: true
      xml_element :has_instruments, xml: 'hasInstrument',
                                    type: Newsmlg2::Types::HasInstrument, collection: true

      xml do
        element 'organisationDetails'
      end
    end

    # An affiliation of a person or an organisation with an organisation.
    # Composed (rather than subclassing a flex organisation type) so the
    # flex prop types and the detail types never reference each other's
    # class bodies. python-newsmlg2 models this as two identical classes
    # (PersonAffiliationType, OrganisationAffiliationType).
    class Affiliation < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes
      include Newsmlg2::Base::QualifyingAttributes
      include Newsmlg2::Base::I18NAttributes
      include Newsmlg2::Base::TimeValidityAttributes
      include Newsmlg2::Base::ConceptDefinitionGroup
      include Newsmlg2::Base::ConceptRelationshipsGroup

      xml_element :organisation_details, xml: 'organisationDetails',
                                         type: Newsmlg2::Types::OrganisationDetails

      xml do
        element 'affiliation'
      end
    end

    class OrganisationDetails
      xml_element :affiliations, xml: 'affiliation',
                                 type: Newsmlg2::Types::Affiliation, collection: true
    end

    # A set of properties specific to a person.
    class PersonDetails < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes

      xml_element :born, xml: 'born', type: Newsmlg2::Types::Born
      xml_element :died, xml: 'died', type: Newsmlg2::Types::Died
      xml_element :affiliations, xml: 'affiliation',
                                 type: Newsmlg2::Types::Affiliation, collection: true
      xml_element :contact_infos, xml: 'contactInfo',
                                  type: Newsmlg2::Types::ContactInfoType, collection: true

      xml do
        element 'personDetails'
      end
    end
  end
end
