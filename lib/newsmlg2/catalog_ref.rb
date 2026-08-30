# frozen_string_literal: true

module Newsmlg2
  # A reference to a remote catalog: a hyperlink to a set of scheme alias
  # declarations.
  class CatalogRef < Newsmlg2::NarModel
    xml_attributes :title, :href

    xml do
      element 'catalogRef'
    end
  end
end
