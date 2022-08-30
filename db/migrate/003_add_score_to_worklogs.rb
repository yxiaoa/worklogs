#encoding: utf-8
class AddScoreToWorklogs < Rails.version < '5.1' ? ActiveRecord::Migration : ActiveRecord::Migration[5.2]
  def up
    add_column :worklogs, :score, :integer
    add_column :worklogs, :good, :text
    add_column :worklogs, :nogood, :text
  end

  def down
    remove_column :worklogs, :score
    remove_column :worklogs, :good
    remove_column :worklogs, :nogood
  end
end