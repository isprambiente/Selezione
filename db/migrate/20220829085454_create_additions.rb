class CreateAdditions < ActiveRecord::Migration[7.0]
  def change
    create_table :additions do |t|
      t.references :request, null: false, foreign_key: true
      t.text :description, null: false, default: ''
      t.string :url, null: false, default: ''

      t.timestamps
    end
  end
end
