#encoding: utf-8
class CreateWorklogs < Rails.version < '5.1' ? ActiveRecord::Migration : ActiveRecord::Migration[5.2]
  def change
    create_table :worklogs do |t|
      t.integer :user_id
      t.integer :typee, :default => 0 #0日报；1周报；2月报
      t.string :day
      t.integer :week
      t.text :do
      t.text :todo
      t.integer :status, :default => 0 #准时，晚点，缺失
      
      t.timestamp :created_at
    end
  end
end
