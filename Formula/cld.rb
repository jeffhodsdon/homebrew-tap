class Cld < Formula
  desc "iMessage + Claude CLI personal assistant daemon"
  homepage "https://github.com/jeffhodsdon/cld"
  version "0.1.0-bed8799"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jeffhodsdon/cld/releases/download/latest/cld-aarch64-apple-darwin.tar.gz"
      sha256 "aa6013c2f13c6ed019d08d948f19cceed471209b33786127bc101aa9c9a7c514"
    end

    on_intel do
      url "https://github.com/jeffhodsdon/cld/releases/download/latest/cld-x86_64-apple-darwin.tar.gz"
      sha256 "a7c0ae97b74894d877f3362e1028c3ad19848cd3eb897f14d5fe5cc2628c2dbd"
    end
  end

  def install
    bin.install "cld"
    (var/"cld").mkpath
    (var/"log").mkpath
  end

  def post_install
    # Copy binary to stable path so FDA grant survives brew upgrade.
    # The Cellar path changes every version; var/cld/cld does not.
    rm_f var/"cld/cld"
    cp bin/"cld", var/"cld/cld"
    system "codesign", "--force", "--sign", "-",
           "--identifier", "com.cld.cld", var/"cld/cld"
  end

  service do
    run var/"cld/cld"
    keep_alive true
    process_type :background
    log_path var/"log/cld.log"
    error_log_path var/"log/cld.err.log"
    working_dir var/"cld"
    environment_variables HOME: Dir.home, PATH: "#{Dir.home}/.local/bin:#{std_service_path_env}"
    restart_delay 10
  end

  def caveats
    <<~EOS
      cld requires Full Disk Access to read the Messages database.

      Grant access once (persists across upgrades):
        1. Open System Settings > Privacy & Security > Full Disk Access
        2. Click + and add: #{var}/cld/cld

      Run health checks to verify setup:
        cld status

      To start cld as a background service:
        brew services start cld

      After upgrading:
        brew services restart cld

      Logs are at:
        #{var}/log/cld.log
        #{var}/log/cld.err.log
    EOS
  end

  test do
    assert_match "cld", shell_output("#{bin}/cld --version")
  end
end
