# frozen_string_literal: true

class Libmysofa < Formula
  desc "Library for reading AES SOFA files"
  homepage "https://github.com/hoene/libmysofa"
  url "https://github.com/hoene/libmysofa/archive/v1.2.tar.gz"
  sha256 "7638dec8ba2b5408cf32ab41d37cb29460095c4b2161a860480c122e71806ba9"
  license "BSD-3-Clause"
  head "https://github.com/hoene/libmysofa.git"

  depends_on "cmake" => :build

  depends_on "cunit"

  def install
    opts  = Hardware::CPU.arm? ? "" : "-march=native -mtune=native "
    opts += "-Ofast -flto=thin -funroll-loops -fomit-frame-pointer "
    opts += "-ffunction-sections -fdata-sections -fstrict-vtable-pointers -fwhole-program-vtables "
    opts += "-fforce-emit-vtables " if MacOS.version >= :mojave
    ENV.append "CFLAGS",      opts
    ENV.append "CPPFLAGS",    opts
    ENV.append "CXXFLAGS",    opts
    ENV.append "OBJCFLAGS",   opts
    ENV.append "OBJCXXFLAGS", opts
    ENV.append "LDFLAGS",     opts + " -dead_strip"

    cd "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_BUILD_TYPE=Release"
      system "make", "all"
      system "make", "install"
    end
  end
end
