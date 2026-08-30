# frozen_string_literal: true

module Newsmlg2
  # A reference to a target item or Web resource. Official IPTC examples
  # carry media characteristics (width, height, …) on itemRef.
  class ItemRef < Newsmlg2::Types::Link1Type
    include Newsmlg2::Base::NewsContentCharacteristics

    xml do
      element 'itemRef'
    end
  end
end
