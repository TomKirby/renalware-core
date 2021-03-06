class AddPolymorphicFieldsToPathologyRequestsGlobalRules < ActiveRecord::Migration[4.2]
  def change
    rename_column :pathology_requests_global_rules, :global_rule_set_id, :rule_set_id
    change_column :pathology_requests_global_rules, :rule_set_id, :integer, null: true

    add_column :pathology_requests_global_rules, :rule_set_type, :string, null: false
  end
end
