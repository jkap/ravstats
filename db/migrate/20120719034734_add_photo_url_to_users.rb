class AddPhotoUrlToUsers < ActiveRecord::Migration
  def change
    add_column :users, :photo_url, :string, limit: 255
  end
end
