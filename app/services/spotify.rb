# frozen_string_literal: true
class Spotify
  BASE_URL = "https://api.spotify.com/v1/".freeze
  attr_reader :access_token, :authenticator, :user_id

  def initialize(authenticator:, user_id:)
    @authenticator = authenticator
    @user_id = user_id
  end

  def playlists
    result = []
    next_url = "/me/playlists?limit=50"

    while next_url
      res = get(next_url)
      result.concat(res.body["items"])
      next_url = res.body["next"]
    end
    result
  end

  def clean_tracks(tracks)
    tracks.each_slice(50).map { |batch| clean_track_batch(batch) }.flatten
  end

  def replace_playlist(target_playlist_id, tracks:)
    batch = tracks.shift(90)
    query = { uris: batch.join(",") }.to_query
    put("/users/#{user_id}/playlists/#{target_playlist_id}/tracks?#{query}")

    append_to_playlist(target_playlist_id, tracks: tracks)
  end

  def append_to_playlist(target_playlist_id, tracks:)
    tracks.each_slice(90) do |batch|
      query = { uris: batch.join(",") }.to_query
      post("/users/#{user_id}/playlists/#{target_playlist_id}/tracks?#{query}")
    end
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

  def post(path)
    res = authenticator.post(path)
    Spotify::Response.new(status: res.code, headers: res.to_hash, raw_body: res.body)
  end

  def id_from_uri(uri)
    uri.split(":").last
  end

  def clean_track_batch(batch)
    ids = batch.map { |uri| id_from_uri(uri) }
    query = { ids: ids.join(",") }.to_query
    get("/tracks?#{query}").body["tracks"].compact.map { |track| track["uri"] }
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
