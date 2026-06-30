cask "mac-upgrader" do
  version "1.0.0"
  sha256 "a96b576350cb19d033a4ab63c5a5284e2869f625a079915806b41e1a68c1630e"

  url do
    # Homebrew has a built-in GitHub API client, conveniently able to provide the list of releases, converted from JSON to Ruby hashes.
    assets = GitHub.get_release("arvatoaws", "cloud-staff-tools", "mac-upgrader-v#{version}").fetch("assets")
    latest = assets.find{|a| a["name"] == "MacUpgrader-#{version}.zip" }.fetch("url")
    # The return value must match the arguments for the non-block version of `url`, first a URL, and then an options hash. The `header` option can take an array if you need to provide more than one header.
    [latest, header: [
      # The GitHub API will return the binary content of an asset instead of JSON data about that asset if you set the Accept header to application/octet-stream.
      "Accept: application/octet-stream",
      # Homebrew also has a built-in helper that will return GitHub credentials, checking the keychain, config files, gh CLI tool, and other locations automatically. We can re-use those same credentials that Homebrew uses to make API requests for our own download by setting this header.
      "Authorization: bearer #{GitHub::API.credentials}"
    ]]
  end
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
