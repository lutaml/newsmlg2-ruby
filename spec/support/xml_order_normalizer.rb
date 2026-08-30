# frozen_string_literal: true

require 'nokogiri'

# Spec support: canonicalizes XML for semantic comparison —
# - drops whitespace-only text nodes and comments (indentation differs
#   between source files and our canonical 2-space output; comments are not
#   semantic),
# - sorts siblings by name so comparison is order-insensitive (official IPTC
#   examples legitimately deviate from the XSD's element sequence; our
#   serializer always emits XSD order).
module XmlOrderNormalizer
  module_function

  def normalize(xml, strip_namespaces: false)
    doc = Nokogiri::XML(
      xml.gsub(%r{xmlns:([\w.-]+)="(?!urn:|https?://|/)[^"]*"}) do
        "xmlns:#{::Regexp.last_match(1)}=\"urn:relative:#{::Regexp.last_match(2)}\""
      end
    )
    doc.remove_namespaces! if strip_namespaces
    strip_nodes(doc.root)
    sort_node(doc.root)
    doc.root.to_xml
  end

  def strip_nodes(node)
    node.children.select(&:comment?).each(&:remove)
    node.children.select do |child|
      child.text? && child.text.strip.empty?
    end.each(&:remove)
    node.element_children.each { |child| strip_nodes(child) }
  end

  def sort_node(node)
    children = node.element_children
    children.each { |child| sort_node(child) }
    reordered = reordered(children)
    return if reordered.nil?

    reordered.each { |child| node.add_child(child) }
  end

  def sort_key(child)
    [child.name,
     child.attributes.map { |k, v| "#{k}=#{v.value}" }.sort.join,
     child.to_xml.length]
  end

  # The sorted child list, or nil when there is nothing to reorder.
  def reordered(children)
    return nil unless children.size > 1

    sorted = children.sort_by { |child| sort_key(child) }
    return nil if sorted.map(&:to_xml) == children.map(&:to_xml)

    sorted
  end
end
