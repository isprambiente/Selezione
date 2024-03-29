class CreateAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :answers do |t|
      t.references :request, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.text :value

      t.timestamps
    end
    add_index :answers, [:request_id, :question_id], unique: true
  end
end
