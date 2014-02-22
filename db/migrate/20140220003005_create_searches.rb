class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :company_name
      t.string :org_number

      t.timestamps
    end
  end
end
