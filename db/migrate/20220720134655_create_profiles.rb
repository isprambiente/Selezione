class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.references :area, null: false, foreign_key: true
      t.string :code, null: false, default: ''
      t.string :title, null: false, default: true
      t.boolean :careers_enabled, null: false, default: true
      t.integer :careers_requested, null: false, default: 0
      t.boolean :qualifications_enabled, null: false, default: true
      t.string :qualifications_requested, array: true, null: false, default: []
      t.string :qualifications_alternative, array: true, null: false, default: []
      t.boolean :others_enabled, null: false, default: true

      t.timestamps
    end
    add_index :profiles, :code
    add_index :profiles, :title
  end
end
