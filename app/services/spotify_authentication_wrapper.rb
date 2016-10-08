# frozen_string_literal: true
class SpotifyAuthenticationWrapper
  BASE_URL = "https://api.spotify.com/v1/".freeze
  SPOTIFY_CLIENT_ID = ENV.fetch("SPOTIFY_CLIENT_ID")
  SPOTIFY_CLIENT_SECRET = ENV.fetch("SPOTIFY_CLIENT_SECRET")

  attr_reader :user, :client

  def initialize(user:)
    @user = user

    uri = URI(BASE_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    @client = http
  end

  def get(path, _should_retry = true)
    req = Net::HTTP::Get.new(uri_from_path(path))
    request_with_retry(req)
  end

  def put(path, _should_retry = true)
    req = Net::HTTP::Put.new(uri_from_path(path))
    request_with_retry(req)
  end

  private

  def refresh_access_token
    res = request_new_access_token
    user.access_token = res["access_token"]
    user.access_token_expires_at = res["expires_in"].to_i.seconds.from_now
    user.save!
  end

  def request_new_access_token
    req = Net::HTTP::Post.new(URI("https://accounts.spotify.com/api/token"))
    req.basic_auth(spotify_client_id, spotify_client_secret)
    req.add_field "Content-Type", "application/x-www-form-urlencoded; charset=utf-8"
    req.body = URI.encode_www_form(grant_type: :refresh_token,
                                   refresh_token: user.refresh_token)
    res = client.request(req)
    JSON.parse(res.body)
  end

  def uri_from_path(path)
    URI(File.join(BASE_URL, path))
  end

  def request_with_retry(req, should_retry = true)
    refresh_access_token if user.access_token_expires_at.past?
    add_common_headers(req)
    res = client.request(req)
    if unauthorized?(res) && should_retry
      refresh_access_token
      request_with_retry(duplicate_request(req), false)
    else
      res
    end
  end

  def add_common_headers(req)
    req.add_field "Authorization", "Bearer #{user.access_token}"
    req.add_field "Content-Type", "application/json"
    req
  end

  def duplicate_request(req)
    req.class.new(req.uri)
  end

  def unauthorized?(res)
    res.code.to_i == 401
  end

  def spotify_client_id
    SPOTIFY_CLIENT_ID
  end

  def spotify_client_secret
    SPOTIFY_CLIENT_SECRET
  end
end
