# frozen_string_literal: true

# Regenerates the golden documents of the newsmlg2-fixtures repository —
# the cross-implementation conformance fixtures whose serialization shape
# this gem defines (the TypeScript codec's mirror suite consumes them).
# Run standalone from a checkout (defaults to the sibling
# newsmlg2-fixtures/golden), or through the fixtures repo's bin/regenerate,
# which sets OUT to its own golden/ directory.
$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'lutaml/model'

# Goldens are byte-stable fixtures consumed by other implementations, so
# generation pins the canonical adapter rather than trusting whatever the
# environment happens to have configured.
Lutaml::Model::Config.configure do |config|
  config.xml_adapter_type = :nokogiri
end

require 'newsmlg2'
require 'fileutils'

OUT = ENV.fetch('OUT') { File.expand_path('../../newsmlg2-fixtures/golden', __dir__) }
FileUtils.mkdir_p(OUT)

# 1. Full-featured item: all fields the network contract maps, inline XHTML + renditions
full = Newsmlg2.build_news_item(guid: 'urn:ribose:news:2026-09-01:pubid:pubid-1-0-released', lang: 'en') do |i|
  i.item_meta do |meta|
    meta.item_class qcode: 'ninat:text'
    meta.provider(qcode: 'nprov:pubid') { |p| p.name 'PubID' }
    meta.version_created '2026-09-01T09:00:00+00:00'
  end
  i.content_meta do |cm|
    cm.content_created '2026-09-01T08:00:00+00:00'
    cm.headline 'PubID 1.0 released'
    cm.slugline 'PubID 1.0'
    cm.description 'The PubID library reaches 1.0'
    cm.by 'PubID team'
    cm.located { |l| l.name 'Hong Kong, HK' }
  end
end
File.write(File.join(OUT, 'newsitem-full.xml'), full.to_xml)

# 2. Minimal item
min = Newsmlg2.build_news_item(guid: 'urn:ribose:news:2026-09-01:pubid:minimal') do |i|
  i.item_meta do |meta|
    meta.item_class qcode: 'ninat:text'
    meta.provider(qcode: 'nprov:pubid') { |p| p.name 'PubID' }
    meta.version_created '2026-09-01T09:00:00+00:00'
  end
  i.content_meta { |cm| cm.headline 'Minimal' }
end
File.write(File.join(OUT, 'newsitem-minimal.xml'), min.to_xml)

# 3. Index message (metadata-only items) — the spoke index shape
msg = Newsmlg2.build_news_message do |m|
  m.header do |h|
    h.sent '2026-09-01T09:00:00+00:00'
    h.sender 'Ribose'
  end
end
msg.item.item_set = Newsmlg2::ItemSet.new(news_items: [full.item, min.item])
File.write(File.join(OUT, 'newsmessage-index.xml'), msg.to_xml)

puts "goldens written: #{Dir.children(OUT).sort.inspect}"
