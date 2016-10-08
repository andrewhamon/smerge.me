class Link < ApplicationRecord
  belongs_to :github_user
  belongs_to :spotify_user

  validates :spotify_playlist_id, uniqueness: true
end
