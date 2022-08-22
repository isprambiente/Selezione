class CreateRequests < ActiveRecord::Migration[7.0]
  def change
    create_enum 'request_statuses', ['editing','sended', 'aborted','rejected','accepted','valutated']

    create_table :requests do |t|
      t.references :user, null: false, foreign_key: true
      t.references :profile, null: false, foreign_key: true
      t.enum :status, enum_type: 'request_statuses', default: 'editing', null: false

      t.timestamps
    end
  end
end
