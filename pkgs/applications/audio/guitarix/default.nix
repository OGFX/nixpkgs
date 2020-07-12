{ stdenv, fetchurl, fetchzip, fetchgit, gettext, intltool, pkgconfig, python2
, avahi, bluez, boost, eigen, fftw, glib, glib-networking
, glibmm, gsettings-desktop-schemas, gtkmm2, libjack2
, ladspaH, libav, librdf, libsndfile, lilv, lv2, serd, sord, sratom
, wrapGAppsHook, zita-convolver, zita-resampler, curl, sassc, gtk3, gtkmm3, wafHook
, optimizationSupport ? false # Enable support for native CPU extensions
}:

let
  inherit (stdenv.lib) optional;
in

stdenv.mkDerivation rec {
  pname = "guitarix";
  version = "0.40.0git";

  src = fetchzip {
    url = "https://github.com/brummer10/guitarix/archive/6368122bd703f5728b54f1b11ea60d9aea88d872.zip";
    sha256 = "1fag2baci6sd4ax15y0dkgd8l6m64rygg87jwsvg14w443xdvk8v";
  };

  nativeBuildInputs = [ gettext intltool wrapGAppsHook pkgconfig python2 wafHook ];

  buildInputs = [
    avahi bluez boost eigen fftw glib glibmm glib-networking.out
    gsettings-desktop-schemas gtkmm2 libjack2 ladspaH libav librdf
    libsndfile lilv lv2 serd sord sratom zita-convolver
    zita-resampler curl gtk3 gtkmm3 sassc
  ];

  preConfigure = ''
    cd trunk
  '';

  wafConfigureFlags = [
    "--shared-lib"
    "--no-desktop-update"
    "--enable-nls"
    "--no-faust" # todo: find out why --faust doesn't work
    "--install-roboto-font"
    "--includeresampler"
    "--convolver-ffmpeg"
  ] ++ optional optimizationSupport "--optimization";

  meta = with stdenv.lib; {
    description = "A virtual guitar amplifier for Linux running with JACK";
    longDescription = ''
        guitarix is a virtual guitar amplifier for Linux running with
      JACK (Jack Audio Connection Kit). It is free as in speech and
      free as in beer. Its free sourcecode allows to build it for
      other UNIX-like systems also, namely for BSD and for MacOSX.

        It takes the signal from your guitar as any real amp would do:
      as a mono-signal from your sound card. Your tone is processed by
      a main amp and a rack-section. Both can be routed separately and
      deliver a processed stereo-signal via JACK. You may fill the
      rack with effects from more than 25 built-in modules spanning
      from a simple noise-gate to brain-slashing modulation-fx like
      flanger, phaser or auto-wah. Your signal is processed with
      minimum latency. On any properly set-up Linux-system you do not
      need to wait for more than 10 milli-seconds for your playing to
      be delivered, processed by guitarix.

        guitarix offers the range of sounds you would expect from a
      full-featured universal guitar-amp. You can get crisp
      clean-sounds, nice overdrive, fat distortion and a diversity of
      crazy sounds never heard before.
    '';
    homepage = http://guitarix.sourceforge.net/;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ astsmtl goibhniu ];
    platforms = platforms.linux;
  };
}
