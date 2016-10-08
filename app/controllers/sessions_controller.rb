class SessionsController < ApplicationController
  skip_before_action :require_login

  def new
    redirect_to root_path if current_github_user.present? && current_spotify_user.present?
  end

  def create
    case params[:provider]
    when "spotify"
      create_spotify
    when "github"
      create_github
    end
  end

  private

  def create_spotify
    user = SpotifyUser.find_or_initialize_by(id: auth_hash.uid)
    user.assign_attributes(spotify_credentials)
    user.save!
    session[:spotify_user_id] = user.id
    redirect_to root_path
  end

  def spotify_credentials
    {
      access_token: credentials.token,
      refresh_token: credentials.refresh_token,
      access_token_expires_at: Time.at(credentials.expires_at).utc.to_datetime
    }
  end

  def create_github
    user = GithubUser.find_or_initialize_by(id: auth_hash.uid)
    user.access_token = credentials.token
    user.save!
    session[:github_user_id] = user.id
    redirect_to root_path
  end

  def auth_hash
    request.env["omniauth.auth"]
  end

  def credentials
    auth_hash.credentials
  end
end
