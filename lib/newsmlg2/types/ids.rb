# frozen_string_literal: true

module Newsmlg2
  module Types
    # An alternative identifier assigned to the content.
    class AltId < IntlStringType2
      xml_attributes(
        :type, :typeuri, :environment, :environmenturi,
        :idformat, :idformaturi, :role, :roleuri, :version
      )

      xml do
        element 'altId'
      end
    end

    # Hash value of parts of an item as defined by the hashscope attribute.
    class Hash < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes

      xml_attributes :hashtype, :hashtypeuri, :scope, :scopeuri

      xml do
        element 'hash'
      end
    end
  end
end
