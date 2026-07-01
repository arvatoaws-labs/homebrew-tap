cask "mac-upgrader" do
  version "1.0.1"
  sha256 "c4bd879faaefe62e94eb135dfad063d4d32f85e06f38841ba43434e5fa9f7787"

  # The release lives in a PRIVATE repository, so Homebrew must authenticate the
  # download. Set HOMEBREW_GITHUB_API_TOKEN to a GitHub token with read access to
  # arvatoaws/cloud-staff-tools before running `brew install`. The token is sent
  # only to github.com; Homebrew drops it on the redirect to the release CDN.
  url "https://github.com/arvatoaws/cloud-staff-tools/releases/download/mac-upgrader-v#{version}/MacUpgrader-#{version}.dmg",
      verified: "github.com/arvatoaws/cloud-staff-tools/",
      header:   "Authorization: Bearer #{ENV.fetch("HOMEBREW_GITHUB_API_TOKEN", "")}"
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
