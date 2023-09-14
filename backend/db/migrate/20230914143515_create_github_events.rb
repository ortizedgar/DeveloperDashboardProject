class CreateGithubEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :github_events do |t|
      t.string :event_type
      t.json :payload

      t.timestamps
    end
  end
end
