class CreateContests < ActiveRecord::Migration[7.0]
  def change
    create_table :contests do |t|
      t.string :code, null: false, limit: 10
      t.string :title, null: false
      t.datetime :start_at, null: false
      t.datetime :stop_at, null: false
      t.integer :areas_max_choice, null: false, default: 1
      t.integer :areas_count, null: false, default: 0

      t.timestamps
    end

    add_index :contests, :code
    add_index :contests, :title
    add_index :contests, :start_at
    add_index :contests, :stop_at
  end
end
