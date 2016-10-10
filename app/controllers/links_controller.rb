class LinksController < ApplicationController
  before_action :set_link, only: [:show, :edit, :update, :destroy]

  def index
    @links = Link.where(github_user_id: current_github_user&.id)
                 .or(Link.where(spotify_user_id: current_spotify_user&.id))
  end

  def show
  end

  def new
    fetch_playlists
    fetch_repos
    @link = Link.new
  end

  def edit
    fetch_playlists
    fetch_repos
  end

  def create
    initialize_link
    if @link.save
      InstallWebhook.call(link: @link)
      redirect_to @link, notice: "Link was successfully created."
    else
      fetch_playlists
      fetch_repos
      render :new
    end
  end

  def update
    if @link.update(link_params)
      redirect_to @link, notice: "Link was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @link.destroy
    redirect_to links_url, notice: "Link was successfully destroyed."
  end

  private

  def initialize_link
    @link = Link.new(link_params)
    @link.spotify_user_id = current_spotify_user.id
    @link.github_user_id = current_github_user.id
  end

  def set_link
    @link = Link.where(github_user_id: current_github_user&.id)
                .or(Link.where(spotify_user_id: current_spotify_user&.id))
                .find(params[:id])
  end

  def link_params
    params.require(:link).permit(:spotify_playlist_id, :github_repo_id, :github_file_path)
  end

  def fetch_playlists
    authenticator = SpotifyAuthenticationWrapper.new(user: current_spotify_user)
    client = Spotify.new(authenticator: authenticator, user_id: current_spotify_user.id)
    @playlists = client.playlists
    @playlists = @playlists.map { |item| [item["name"], item["id"]] }
  end

  def fetch_repos
    client = Octokit::Client.new(access_token: current_github_user.access_token)
    @repos = client.repositories(nil, per_page: 100).select { |r| r[:permissions][:admin] }
    @repos = @repos.map { |r| [r[:full_name], r[:id]] }
  end
end
