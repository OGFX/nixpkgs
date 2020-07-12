{ stdenv, fetchFromGitHub,
automake, pkgconfig, lv2, fftw, cmake, xorg, libjack2, libsamplerate, libsndfile
}:

stdenv.mkDerivation rec {
  repo = "rkrlv2";
  name = "${repo}-b2.0";

  src = fetchFromGitHub {
    owner = "ssj71";
    inherit repo;
    rev = "beta_3";
    sha256 = "16i4ajrib7kb0abdcn4901g8a4lkwkp2fyqyms38dhqq84slyfjs";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = with xorg; [ automake lv2 fftw cmake libXpm libjack2 libsamplerate libsndfile libXft ];

  prePatch = ''
    substituteInPlace lv2/CMakeLists.txt --replace "-msse -msse2 -mfpmath=sse" "-march=native"
  '';

  meta = {
    description = "Rakarrak effects ported to LV2";
    homepage = https://github.com/ssj71/rkrlv2;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.joelmo ];
    platforms = stdenv.lib.platforms.linux;
  };
}
