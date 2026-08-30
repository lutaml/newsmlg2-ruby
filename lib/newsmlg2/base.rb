# frozen_string_literal: true

module Newsmlg2
  # Shared XSD attribute groups and element groups, ported module-by-module
  # from python-newsmlg2's attributegroups.py and the *Group element lists.
  # Each mixin contributes attributes and mapping rules to the including
  # NarModel subclass, in include order.
  module Base
    autoload :AdministrativeMetadataGroup, 'newsmlg2/base/administrative_metadata_group'
    autoload :ArbitraryValueAttributes, 'newsmlg2/base/arbitrary_value_attributes'
    autoload :AuthorityAttributes, 'newsmlg2/base/authority_attributes'
    autoload :CommonPowerAttributes, 'newsmlg2/base/common_power_attributes'
    autoload :ConceptDefinitionGroup, 'newsmlg2/base/concept_definition_group'
    autoload :ConceptRelationshipsGroup, 'newsmlg2/base/concept_relationships_group'
    autoload :ConfirmationStatusAttributes, 'newsmlg2/base/confirmation_status_attributes'
    autoload :DeprecatedLinkAttributes, 'newsmlg2/base/deprecated_link_attributes'
    autoload :DescriptiveMetadataCoreGroup, 'newsmlg2/base/descriptive_metadata_group'
    autoload :DescriptiveMetadataGroup, 'newsmlg2/base/descriptive_metadata_group'
    autoload :EntityDetailsGroup, 'newsmlg2/base/entity_details_group'
    autoload :FlexAttributes, 'newsmlg2/base/flex_attributes'
    autoload :I18NAttributes, 'newsmlg2/base/i18n_attributes'
    autoload :ItemManagementGroup, 'newsmlg2/base/item_management_group'
    autoload :MediaContentCharacteristics1, 'newsmlg2/base/media_content_characteristics1'
    autoload :NewsContentAttributes, 'newsmlg2/base/news_content_attributes'
    autoload :NewsContentCharacteristics, 'newsmlg2/base/news_content_characteristics'
    autoload :NewsContentTypeAttributes, 'newsmlg2/base/news_content_type_attributes'
    autoload :PersistentEditAttributes, 'newsmlg2/base/persistent_edit_attributes'
    autoload :QualifyingAttributes, 'newsmlg2/base/qualifying_attributes'
    autoload :QuantifyAttributes, 'newsmlg2/base/quantify_attributes'
    autoload :RankingAttributes, 'newsmlg2/base/ranking_attributes'
    autoload :RecurrenceRuleAttributes, 'newsmlg2/base/recurrence_rule_attributes'
    autoload :TargetResourceAttributes, 'newsmlg2/base/target_resource_attributes'
    autoload :TimeValidityAttributes, 'newsmlg2/base/time_validity_attributes'
  end
end
