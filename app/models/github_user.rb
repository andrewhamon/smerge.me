class GithubUser < ApplicationRecord
  validates :access_token, presence: true

  has_many :links
end
