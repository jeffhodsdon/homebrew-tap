class Cld < Formula
  desc "iMessage + Claude CLI personal assistant daemon"
  homepage "https://github.com/jeffhodsdon/cld"
  version "0.1.0-7306390"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jeffhodsdon/cld/releases/download/latest/cld-aarch64-apple-darwin.tar.gz"
      sha256 "93003f38e087377fe7e4529331bae761fe2b50e2e79485e41f9e42d89723d18f"
    end

    on_intel do
      url "https://github.com/jeffhodsdon/cld/releases/download/latest/cld-x86_64-apple-darwin.tar.gz"
      sha256 "1e61e608ebd3d5ce95ca44ad5cc8639f84917fc8e539354d5ce054970093ce61"
    end
  end

  def install
    bin.install "cld"
  end

  service do
    run opt_bin/"cld"
    keep_alive true
    process_type :background
    log_path var/"log/cld.log"
    error_log_path var/"log/cld.err.log"
    working_dir var/"cld"
    environment_variables HOME: Dir.home, PATH: std_service_path_env
    restart_delay 10
  end

  def caveats
    <<~EOS
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
