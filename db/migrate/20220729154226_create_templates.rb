class CreateTemplates < ActiveRecord::Migration[7.0]
  def change
    create_table :templates do |t|
      t.string :title, null: false, default: true
      t.jsonb :data, null: false, default: {}

      t.timestamps
    end
    add_index :templates, :title
  end
end
