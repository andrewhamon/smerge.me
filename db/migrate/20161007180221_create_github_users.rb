class CreateGithubUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :github_users, id: false do |t|
      t.bigint :id, primary_key: true
      t.string :access_token, null: false
      t.timestamps
    end
  end
end
