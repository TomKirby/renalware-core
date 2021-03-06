class CreateConsultSites < ActiveRecord::Migration[5.1]
  def change
    create_table :admission_consult_sites do |t|
      t.string :name, index: :unique
    end

    remove_column :admission_consults, :hospital_unit_id
    add_column :admission_consults, :other_site_or_ward, :string
    add_reference :admission_consults,
                  :consult_site,
                  references: :admission_consult_sites,
                  index: true
  end
end
