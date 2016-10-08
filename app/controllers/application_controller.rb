class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :require_login
  helper_method :current_spotify_user, :current_github_user

  private

  def current_github_user
    @current_github_user ||= GithubUser.find_by(id: session[:github_user_id])
  end

  def current_spotify_user
    @current_spotify_user ||= SpotifyUser.find_by(id: session[:spotify_user_id])
  end

  def require_login
    unless current_github_user.present?
      session[:github_user_id] = nil
      redirect_to login_path
      return
    end
    unless current_spotify_user.present?
      session[:spotify_user_id] = nil
      redirect_to login_path
      return
    end
  end
end
