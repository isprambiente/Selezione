class CreateAreas < ActiveRecord::Migration[7.0]
  def change
    create_table :areas do |t|
      t.references :contest, null: false, foreign_key: true
      t.string :code, null: false, default: ''
      t.string :title, null: false, default: ''
      t.integer :profiles_max_choice, null: false, default: 1
      t.integer :profiles_count, null: false, default: 0

      t.timestamps
    end
    add_index :areas, :title
    add_index :areas, :code
  end
end
