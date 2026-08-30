# frozen_string_literal: true

module Newsmlg2
  module Types
    # The PCL-type of a link from the current Item to a target Item or Web
    # resource.
    class Link1Type < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes
      include Newsmlg2::Base::TargetResourceAttributes
      include Newsmlg2::Base::TimeValidityAttributes
      include Newsmlg2::Base::I18NAttributes
      include Newsmlg2::Base::DeprecatedLinkAttributes

      xml_attributes :rel, :reluri, :rank

      # Link1Type permits arbitrary inline content (xs:any) — e.g. the
      # referenced item's metadata preview inside package itemRef.
      attribute :content, :string

      xml do
        map_all to: :content
      end
    end

    # A link from the current Item to a target Item or Web resource.
    class Link < Link1Type
      xml do
        element 'link'
      end
    end

    # A link to an item or a web resource which provides information about
    # the concept.
    class RemoteInfo < Link1Type
      xml do
        element 'remoteInfo'
      end
    end
  end
end
