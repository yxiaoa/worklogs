#encoding: utf-8
class AddFeelToWorklogs < Rails.version < '5.1' ? ActiveRecord::Migration : ActiveRecord::Migration[5.2]
  def up
    add_column :worklogs, :feel, :text
  end

  def down
    remove_column :worklogs, :feel
  end
end