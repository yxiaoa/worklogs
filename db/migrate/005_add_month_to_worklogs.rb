#encoding: utf-8
class AddMonthToWorklogs < Rails.version < '5.1' ? ActiveRecord::Migration : ActiveRecord::Migration[5.2]
  def up
    add_column :worklogs, :month, :integer
    add_column :worklogs, :year, :integer
  end

  def down
    remove_column :worklogs, :month
    remove_column :worklogs, :year
  end
end