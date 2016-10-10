class Link < ApplicationRecord
  belongs_to :github_user
  belongs_to :spotify_user

  validates :spotify_playlist_id, uniqueness: true

  def github_repo_name
    client = Octokit::Client.new(access_token: github_user.access_token)
    client.repository(github_repo_id)["full_name"]
  end
end
