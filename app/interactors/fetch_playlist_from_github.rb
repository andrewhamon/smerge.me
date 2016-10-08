class FetchPlaylistFromGithub
  attr_reader :github_user, :link

  def initialize(link:)
    @link = link
    @github_user = link.github_user
  end

  def call
    client = Octokit::Client.new(access_token: github_user.access_token)
    res = client.contents(link.github_repo_id, path: link.github_file_path)
    content = Base64.decode64(res["content"])
    TrackParser.call(data: content)
  end

  def self.call(link:)
    new(link: link).call
  end
end
