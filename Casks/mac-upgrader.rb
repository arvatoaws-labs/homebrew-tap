require "download_strategy"

# Downloads a release asset from a PRIVATE GitHub repository.
#
# GitHub's browser download URL (github.com/OWNER/REPO/releases/download/...)
# returns 404 when authenticated with a personal access token, so this resolves
# the asset via the REST API and downloads it from the API asset endpoint, which
# honours `Authorization` together with `Accept: application/octet-stream`.
#
# Requires HOMEBREW_GITHUB_API_TOKEN with read access to the repository.
class GitHubPrivateReleaseDownloadStrategy < CurlDownloadStrategy
  def initialize(url, name, version, **meta)
    super
    unless (match = @url.match(%r{^https://github\.com/([^/]+)/([^/]+)/releases/download/([^/]+)/(\S+)$}))
      raise CurlDownloadStrategyError, "Unexpected GitHub release URL: #{@url}"
    end

    @owner, @repo, @tag, @filename = match.captures
  end

  private

  def _fetch(url:, resolved_url:, timeout:)
    curl_download("https://api.github.com/repos/#{@owner}/#{@repo}/releases/assets/#{asset_id}",
                  "--header", "Accept: application/octet-stream",
                  "--header", "Authorization: Bearer #{github_token}",
                  to: temporary_path, timeout: timeout)
  end

  def github_token
    token = ENV.fetch("HOMEBREW_GITHUB_API_TOKEN", "")
    return token unless token.empty?

    raise CurlDownloadStrategyError,
          "Set HOMEBREW_GITHUB_API_TOKEN to a token with read access to #{@owner}/#{@repo}."
  end

  def asset_id
    @asset_id ||= begin
      require "utils/github"
      release = GitHub::API.open_rest("https://api.github.com/repos/#{@owner}/#{@repo}/releases/tags/#{@tag}")
      asset = release.fetch("assets", []).find { |a| a["name"] == @filename }
      raise CurlDownloadStrategyError, "No asset named #{@filename} in release #{@tag}." if asset.nil?

      asset.fetch("id")
    end
  end
end

cask "mac-upgrader" do
  version "1.0.2"
  sha256 "f04e2cf84df527501698ea8a1f0c10e10b4dcb2f631656bc46acbf787ed2ffbc"

  # The release lives in a PRIVATE repository, so the download is resolved and
  # fetched through the GitHub API by the strategy above. Set
  # HOMEBREW_GITHUB_API_TOKEN to a token with read access to
  # arvatoaws/cloud-staff-tools before running `brew install`.
  url "https://github.com/arvatoaws/cloud-staff-tools/releases/download/mac-upgrader-v#{version}/MacUpgrader-#{version}.dmg",
      using:    GitHubPrivateReleaseDownloadStrategy,
      verified: "github.com/arvatoaws/cloud-staff-tools/"
  name "Mac Upgrader"
  desc "Runs all your system and package-manager upgrades in sequence"
  homepage "https://github.com/arvatoaws/cloud-staff-tools/tree/main/mac-upgrader"

  depends_on macos: :sonoma

  app "MacUpgrader.app"

  zap trash: [
    "~/Library/Caches/com.cloudstaff.MacUpgrader",
    "~/Library/Preferences/com.cloudstaff.MacUpgrader.plist",
    "~/Library/Saved Application State/com.cloudstaff.MacUpgrader.savedState",
  ]
end
