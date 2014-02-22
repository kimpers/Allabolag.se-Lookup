class ChangeSearchFieldNames < ActiveRecord::Migration
  def self.up
    rename_column :searches, :company_name, :company_name
    rename_column :searches, :org_number, :org_number
  end
end
