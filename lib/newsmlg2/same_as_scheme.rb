# frozen_string_literal: true

module Newsmlg2
  # A URI identifying another scheme whose concepts use the same codes and are
  # semantically equivalent to the concepts of this scheme.
  class SameAsScheme < Newsmlg2::NarModel
    include Newsmlg2::Base::CommonPowerAttributes

    xml_content

    xml do
      element 'sameAsScheme'
    end
  end
end
