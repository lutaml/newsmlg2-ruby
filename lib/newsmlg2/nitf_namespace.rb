# frozen_string_literal: true

module Newsmlg2
  # The NITF namespace, embedded in NewsML documents via inlineXML.
  class NitfNamespace < Lutaml::Xml::Namespace
    uri 'http://iptc.org/std/NITF/2006-10-18/'
    prefix_default 'nitf'
  end
end
