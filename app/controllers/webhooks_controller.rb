class WebhooksController < ActionController::Base
  def github
    repo_id = params["repository"]["id"]
    links = Link.where(github_repo_id: repo_id)

    links.find_each do |link|
      tracks = FetchPlaylistFromGithub.call(link: link)
      UpdateSpotifyPlaylist.call(link: link, tracks: tracks)
    end
    render nothing: true
  end
end
