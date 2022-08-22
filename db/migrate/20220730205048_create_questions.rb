class CreateQuestions < ActiveRecord::Migration[7.0]
  def change
    create_enum 'question_categories', ['string', 'text', 'select', 'multiselect', 'radio', 'checkbox', 'file']
    create_table :questions do |t|
      t.references :section, null: false, foreign_key: true
      t.text :title, null: false, default: ''
      t.integer :weight, null: false, default: 0
      t.enum :category, enum_type: 'question_categories', default: 'string', null: false
      t.boolean :mandatory, null: false, default: false
      t.integer :max_select, null: false, default: 1

      t.timestamps
    end
    add_index :questions, :weight
    add_index :questions, :mandatory
    add_index :questions, :category
  end
end
