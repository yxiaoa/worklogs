#encoding: utf-8
class CreateTasklogs < Rails.version < '5.1' ? ActiveRecord::Migration : ActiveRecord::Migration[5.2]
  def change
    create_table :tasklogs do |t|
      t.string :project
      t.string :responsible
      t.text :task_description
      t.string :start
      t.string :due
      t.text :task_log
      t.text :schedule
      t.text :bottleneck
      t.references :worklog, foreign_key: true

      t.timestamps
    end
  end
end
