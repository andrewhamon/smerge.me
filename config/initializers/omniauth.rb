Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify,
           ENV.fetch("SPOTIFY_CLIENT_ID"),
           ENV.fetch("SPOTIFY_CLIENT_SECRET"),
           scope: "playlist-read-private playlist-modify-public playlist-modify-private"

  provider :github,
           ENV.fetch("GITHUB_CLIENT_ID"),
           ENV.fetch("GITHUB_CLIENT_SECRET"),
           scope: "repo,write:repo_hook"
end
