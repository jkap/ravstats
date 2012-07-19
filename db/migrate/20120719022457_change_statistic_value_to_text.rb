class ChangeStatisticValueToText < ActiveRecord::Migration
  def up
    change_column :statistics, :statistic_value, :text, limit: nil
  end
end
