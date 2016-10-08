class SpotifyUser < ApplicationRecord
  validates :access_token, presence: true
  validates :refresh_token, presence: true
  validates :access_token_expires_at, presence: true

  has_many :links
end
