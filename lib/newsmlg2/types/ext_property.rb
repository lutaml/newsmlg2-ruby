# frozen_string_literal: true

module Newsmlg2
  module Types
    # Flexible generic PCL-type for controlled, uncontrolled and arbitrary
    # values (extension property base).
    class Flex1ExtPropType < Flex1PropType
      include Newsmlg2::Base::ArbitraryValueAttributes
    end

    # Flexible generic PCL-type for controlled, uncontrolled and arbitrary
    # values, with a mandatory relationship. All per-parent "ext property"
    # elements (itemMetaExtProperty, rightsInfoExtProperty, …) use this type;
    # their element names are declared at the usage site.
    class Flex2ExtPropType < Flex1ExtPropType
      include Newsmlg2::Base::TimeValidityAttributes

      xml_attributes :rel, :reluri
    end
  end
end
