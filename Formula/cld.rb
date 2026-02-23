class Cld < Formula
  desc "iMessage + Claude CLI personal assistant daemon"
  homepage "https://github.com/jeffhodsdon/cld"
  version "0.1.27"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jeffhodsdon/cld/releases/download/latest/cld-aarch64-apple-darwin.tar.gz"
      sha256 "fe502dfe0b1055edc2cff4740aab952290770cc916b973002f1589dba7fd6dac"
    end

    on_intel do
      url "https://github.com/jeffhodsdon/cld/releases/download/latest/cld-x86_64-apple-darwin.tar.gz"
      sha256 "f5f83f5789b987ec84e9b280cfbbed1b12358388547dc4efc37e3be84ee1f76f"
    end
  end

  def install
    bin.install "cld"
    (var/"cld").mkpath
    (var/"log").mkpath
  end

  service do
    run opt_bin/"cld"
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

      After installing or upgrading:
        1. Open System Settings > Privacy & Security > Full Disk Access
        2. Click + and add: #{opt_bin}/cld
        3. brew services restart cld

      Run health checks to verify setup:
        cld status

      Logs are at:
        #{var}/log/cld.log
        #{var}/log/cld.err.log
    EOS
  end

  test do
    assert_match "cld", shell_output("#{bin}/cld --version")
  end
end
