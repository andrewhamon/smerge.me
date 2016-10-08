class CreateSpotifyUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :spotify_users, id: false do |t|
      t.string :id, primary_key: true
      t.string :access_token, null: false
      t.string :refresh_token, null: false
      t.datetime :access_token_expires_at, null: false
      t.timestamps
    end
  end
end
