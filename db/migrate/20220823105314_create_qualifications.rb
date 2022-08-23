# frozen_string_literal: true

# Migration for {Qualification} model
class CreateQualifications < ActiveRecord::Migration[7.0]
  def change
    create_enum 'qualification_categories', ['dsg','lvo','lb','lm','phd','training']

    create_table :qualifications do |t|
      t.references :request, null: false, foreign_key: true
      t.enum :category, enum_type: 'qualification_categories', default: 'dsg'
      t.string :title, null: false, default: ''
      t.string :vote, null: false, default: ''
      t.string :vote_type, null: false, default: ''
      t.integer :year, limit: 2
      t.string :istitute, null: false, default: ''
      t.string :duration, null: false, default: ''
      t.string :duration_type, null: false, default: ''

      t.timestamps
    end
    add_index :qualifications, :category
  end
end
