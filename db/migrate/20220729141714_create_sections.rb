class CreateSections < ActiveRecord::Migration[7.0]
  def change
    create_table :sections do |t|
      t.references :profile, null: false, foreign_key: true
      t.string :title, null: false, default: ''
      t.integer :weight, null: false, dafault: 0

      t.timestamps
    end
    add_index :sections, :weight
  end
end
