class Dav1d < Formula
  desc "AV1 decoder targeted to be small and fast"
  homepage "https://code.videolan.org/videolan/dav1d"
  url "https://code.videolan.org/videolan/dav1d/-/archive/0.6.0/dav1d-0.6.0.tar.bz2"
  sha256 "7fcfb4d2e43681f99faaad29d2a81c0ecc42d6e2b94eb4d1fded4e9dcb3661f1"
  head "https://github.com/videolan/dav1d.git"

  depends_on "meson" => :build
  depends_on "nasm" => :build
  depends_on "ninja" => :build

  resource "00000000.ivf" do
    url "https://code.videolan.org/videolan/dav1d-test-data/raw/master/8-bit/data/00000000.ivf"
    sha256 "52b4351f9bc8a876c8f3c9afc403d9e90f319c1882bfe44667d41c8c6f5486f3"
  end

  def install
    ENV.append "CFLAGS",      "-Ofast -flto=thin -march=native -mtune=native"
    ENV.append "CPPFLAGS",    "-Ofast -flto=thin -march=native -mtune=native"
    ENV.append "CXXFLAGS",    "-Ofast -flto=thin -march=native -mtune=native"
    ENV.append "OBJCFLAGS",   "-Ofast -flto=thin -march=native -mtune=native"
    ENV.append "OBJCXXFLAGS", "-Ofast -flto=thin -march=native -mtune=native"
    ENV.append "LDFLAGS",     "-Ofast -flto=thin -march=native -mtune=native -dead_strip"

    system "meson", "--prefix=#{prefix}", "build", "--buildtype", "release", "-Doptimization=3", "-Db_lto=true"
    system "ninja", "install", "-C", "build"
  end

  test do
    testpath.install resource("00000000.ivf")
    system bin/"dav1d", "-i", testpath/"00000000.ivf", "-o", testpath/"00000000.md5"

    assert_predicate (testpath/"00000000.md5"), :exist?
    assert_match "0b31f7ae90dfa22cefe0f2a1ad97c620", (testpath/"00000000.md5").read
  end
end
