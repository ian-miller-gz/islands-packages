# typed: strict
# frozen_string_literal: true

class Islands < Formula
  include Language::Python::Virtualenv

  desc "Light-weight C++23 application framework hosting content as cartridges"
  homepage "https://github.com/ian-miller-gz/islands"
  url "https://github.com/ian-miller-gz/islands-packages/releases/download/0.4.7/islands-0.4.7-src.tar.gz"
  sha256 "70f14d958a6d58c777bcfc554bae0f732462026c6943f55997d44ba9a2c03d60"
  license "AGPL-3.0-or-later"

  depends_on "cmake" => :build
  depends_on "cpio" => :build
  depends_on "libxext" => :build
  depends_on "libxfixes" => :build
  depends_on "libxscrnsaver" => :build
  depends_on "libxtst" => :build
  depends_on "libyaml" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "vulkan-headers" => :build
  depends_on "alsa-lib"
  depends_on "gcc"
  depends_on "libx11"
  depends_on "libxcursor"
  depends_on "libxi"
  depends_on "libxinerama"
  depends_on "libxkbcommon"
  depends_on "libxrandr"
  depends_on :linux
  depends_on "mesa"
  depends_on "pulseaudio"
  depends_on "vulkan-loader"
  depends_on "wayland"

  resource "installer" do
    url "https://github.com/ian-miller-gz/islands-packages/releases/download/0.4.7/islands-install-0.4.7.tar.gz"
    sha256 "5ed43741eacd30d83c364789cdea9ce6991df9b73bcd150a6482489ad6c3ea47"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    installer = buildpath/"installer"
    resource("installer").stage installer
    venv = virtualenv_create(buildpath/"venv", "python3.13")
    venv.pip_install resource("pyyaml")
    ENV.prepend_path "PATH", formula_opt_bin("gcc")
    system buildpath/"venv/bin/python3", installer/"tools/install", buildpath, "--offline", "--system"
    system "sh", installer/"tools/prefix.sh", buildpath, libexec
    bin.install_symlink libexec/"build/Island" => "islands"
  end

  test do
    assert_match "Islands", shell_output("#{bin}/islands --version")
  end
end
