class GitHubPrivateReleaseDownloadStrategy < CurlDownloadStrategy
  def initialize(url, name, version, **meta)
    super
    @token = GitHub::API.credentials || ENV["GITHUB_TOKEN"]
    raise CurlDownloadStrategyError, "GitHub token not found" unless @token
  end

  def _fetch(url:, resolved_url:, timeout:)
    curl_download(
      url,
      "--header", "Authorization: token #{@token}",
      "--header", "Accept: application/octet-stream",
      to:         temporary_path,
      timeout:    timeout
    )
  end
end