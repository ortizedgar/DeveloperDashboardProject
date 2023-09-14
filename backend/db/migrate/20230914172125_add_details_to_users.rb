class AddDetailsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :github_token, :string
    add_column :users, :news_topic, :string
  end
end
