# frozen_string_literal: true

module Newsmlg2
  # The NewsML-G2 (NAR) namespace. NewsML documents use it as the default
  # (unprefixed) namespace; child elements inherit it (qualified form).
  class NarNamespace < Lutaml::Xml::Namespace
    uri 'http://iptc.org/std/nar/2006-10-01/'
    element_form_default :qualified
  end
end
