class UpdateSpotifyPlaylist
  attr_reader :spotify_user, :link, :tracks

  def initialize(link:, tracks:)
    @link = link
    @spotify_user = link.spotify_user
    @tracks = tracks
  end

  def call
    authenticator = SpotifyAuthenticationWrapper.new(user: spotify_user)
    client = Spotify.new(authenticator: authenticator, user_id: spotify_user.id)
    clean_tracks = client.clean_tracks(tracks)
    client.replace_playlist(link.spotify_playlist_id, tracks: clean_tracks)
  end

  def self.call(link:, tracks:)
    new(link: link, tracks: tracks).call
  end
end
