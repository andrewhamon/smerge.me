# frozen_string_literal: true
class SpotifyAuthenticationWrapper
  BASE_URL = "https://api.spotify.com/v1/".freeze
  SPOTIFY_CLIENT_ID = ENV.fetch("SPOTIFY_CLIENT_ID")
  SPOTIFY_CLIENT_SECRET = ENV.fetch("SPOTIFY_CLIENT_SECRET")

  attr_reader :user, :client

  def initialize(user:)
    @user = user

    @client = Faraday.new do |builder|
      builder.response :json
      builder.use Faraday::HttpCache,
                  serializer: Marshal,
                  shared_cache: false,
                  store: Rails.cache,
                  logger: Rails.logger
      builder.adapter Faraday.default_adapter
    end
  end

  def get(path)
    request_with_retry(uri_from_path(path), method: :get)
  end

  def put(path)
    request_with_retry(uri_from_path(path), method: :put)
  end

  def post(path)
    request_with_retry(uri_from_path(path), method: :post)
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
    return path if path.start_with? "http"
    File.join(BASE_URL, path)
  end

  def request_with_retry(url, should_retry = true, method:)
    refresh_access_token if user.access_token_expires_at.past?

    res = client.public_send(method) do |req|
      req.url url
      add_common_headers(req)
    end

    if unauthorized?(res) && should_retry
      refresh_access_token
      res = request_with_retry(url, false, method: method)
    end
    res
  end

  def add_common_headers(req)
    req.headers["Authorization"] = "Bearer #{user.access_token}"
    req.headers["Content-Type"] = "application/json"
    req
  end

  def unauthorized?(res)
    res.status == 401
  end

  def spotify_client_id
    SPOTIFY_CLIENT_ID
  end

  def spotify_client_secret
    SPOTIFY_CLIENT_SECRET
  end
end
