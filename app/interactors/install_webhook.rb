# frozen_string_literal: true
class InstallWebhook
  WEBHOOK_URL = ENV.fetch("WEBHOOK_URL")
  attr_reader :github_user, :link

  def initialize(link:)
    @link = link
    @github_user = link.github_user
  end

  def call
    client = Octokit::Client.new(access_token: github_user.access_token)
    webhook_config = { url: webhook_url, content_type: "json" }
    webhook_params = { events: ["push"], active: true }
    client.create_hook(link.github_repo_id, "web", webhook_config, webhook_params)
  end

  def self.call(link:)
    new(link: link).call
  end

  private

  def webhook_url
    WEBHOOK_URL + "?link_id=#{link.id}"
  end
end
