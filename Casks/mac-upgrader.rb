cask "mac-upgrader" do
  version "1.0.0"
  sha256 "a96b576350cb19d033a4ab63c5a5284e2869f625a079915806b41e1a68c1630e"

  url "https://github.com/arvatoaws/cloud-staff-tools/releases/download/mac-upgrader-v#{version}/MacUpgrader-#{version}.zip",
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
