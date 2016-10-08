# frozen_string_literal: true
class Spotify
  BASE_URL = "https://api.spotify.com/v1/".freeze
  attr_reader :access_token, :authenticator, :user_id

  def initialize(authenticator:, user_id:)
    @authenticator = authenticator
    @user_id = user_id
  end

  def playlists
    get("/me/playlists").body["items"]
  end

  def tracks
    get("/me/playlists").body["items"]
  end

  def replace_playlist(target_playlist_id, tracks:)
    query = { uris: tracks.join(",") }.to_query
    put("/users/#{user_id}/playlists/#{target_playlist_id}/tracks?#{query}")
  end

  private

  def get(path)
    res = authenticator.get(path)
    Spotify::Response.new(status: res.code, headers: res.to_hash, raw_body: res.body)
  end

  def put(path)
    res = authenticator.put(path)
    Spotify::Response.new(status: res.code, headers: res.to_hash, raw_body: res.body)
  end
end

class Spotify
  class Response
    attr_reader :status, :headers, :body, :raw_body

    def initialize(status:, headers:, raw_body:)
      @status = status
      @headers = headers
      @raw_body = raw_body
      @body = JSON.parse(raw_body)
    rescue JSON::ParserError
      @body = nil
    end
  end
end
