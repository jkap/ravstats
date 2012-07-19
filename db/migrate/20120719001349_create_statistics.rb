class CreateStatistics < ActiveRecord::Migration
  def change
    create_table :statistics do |t|
      t.string :statistic_type
      t.string :statistic_value
      t.integer :user_id

      t.timestamps
    end
  end
end
