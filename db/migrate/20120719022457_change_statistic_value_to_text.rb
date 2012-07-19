class ChangeStatisticValueToText < ActiveRecord::Migration
  def up
    change_column :statistics, :statistic_value, :text
  end
end
