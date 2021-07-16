class AssumeRole < Formula
  desc 'Arvato "assume-role" adoption including OKTA integration'
  homepage "https://github.com/arvatoaws-labs/assume-role" # FIXME: add url to release
  # sha256 "" //TODO: add hash when adding url to release
  license "Apache-2.0"
  head "https://github.com/arvatoaws-labs/assume-role.git"

  bottle :unneeded

  depends_on "awscli"
  depends_on "gimme-aws-creds"
  depends_on "jq"
  depends_on "zsh" => :optional

  def install
    libexec.install "assume-role"
    bin.install_symlink libexec/"assume-role"

    # install autocompletion
    zsh_completion.install "_assume-role"

    # TODO: create a bash completer file
    # bash_completion.install "aws_assume_role_completer"
    # (bash_completion/"aws_bash_completer").write <<~EOS
    #   fpath=(~/zsh_functions $fpath)
    #   autoload -U compinit
    #   compinit
    # EOS
  end

  def caveats
    <<~EOS
      Add the following line to your ~/.bashrc or ~/.zshrc:
        source $(which assume-role)

      To add profile autocomplete for Bash add:

        fpath=(~/zsh_functions $fpath)
        autoload -U compinit
        compinit
    EOS
  end

  # def bash_completion
  #   <<~EOS
  #     fpath=(~/zsh_functions $fpath)
  #     autoload -U compinit
  #     compinit
  #   EOS
  # end

  test do
    assert_match "help", shell_output("#{bin}/assume-role -h")
  end
end
