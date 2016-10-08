class CreateLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :links do |t|
      t.string :spotify_user_id, null: false, index: true
      t.bigint :github_user_id, null: false, index: true
      t.string :spotify_playlist_id, null: false
      t.bigint :github_repo_id, null: false
      t.string :github_file_path, null: false
      t.timestamps
    end
    add_foreign_key :links, :spotify_users
    add_foreign_key :links, :github_users
    add_index :links, [:spotify_playlist_id, :github_repo_id], unique: true
    add_index :links, [:spotify_playlist_id], unique: true
  end
end
