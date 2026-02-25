class Cld < Formula
  desc "iMessage + Claude CLI personal assistant daemon"
  homepage "https://github.com/jeffhodsdon/cld"
  version "0.1.39"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jeffhodsdon/cld/releases/download/latest/cld-aarch64-apple-darwin.tar.gz"
      sha256 "55b531b8e39b6a290fa5d703615b81d6d870cfdcd2516b6825282f081610c9f1"
    end

    on_intel do
      url "https://github.com/jeffhodsdon/cld/releases/download/latest/cld-x86_64-apple-darwin.tar.gz"
      sha256 "a3e4578be3450b77eeabcc7c077f2a2581902ba86f51c132a6dd328c47c9c01b"
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
