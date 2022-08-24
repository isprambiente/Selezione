class CreateCareers < ActiveRecord::Migration[7.0]
  def change
    create_enum 'career_categories', ['ti', 'td', 'cc', 'co', 'ar', 'stage', 'other']
    create_table :careers do |t|
      t.references :request, null: false, foreign_key: true
      t.string :employer
      t.enum :category, enum_type: 'career_categories', default: 'ti'
      t.text :description, null: false, default: ''
      t.date :start_on, null: false
      t.date :stop_on, null: false

      t.timestamps
    end
    add_index :careers, :category
    add_index :careers, :start_on
  end
end
