{ stdenv, lib, pkgs }:
############
# Packages #
#######################################################################
stdenv.mkDerivation (finalAttrs: {
  name = "audio-relay";
  version = "0.26.3";
  # ----------------------------------------------------------------- #
  src = builtins.fetchurl {
    url = https://dl.audiorelay.net/setups/linux/audiorelay-0.27.5.tar.gz;
    sha256 = "1iz8z3nz8jxdp57ksy466a1gwk5w3vibd9w1g2zyf8dxlhwl31f4";
  };
  sourceRoot = ".";
  # ----------------------------------------------------------------- #
  installPhase = ''
    mkdir -p $out/share/icons/hicolor/512x512/apps
    ln -sf AudioRelay bin/audio-relay
    cp -rp bin lib $out/
    cp lib/AudioRelay.png $out/share/icons/hicolor/512x512/apps/audiorelay.png
    cp $out/lib/app/AudioRelay.cfg $out/lib/app/.AudioRelay-wrapped.cfg
  '';
  # ----------------------------------------------------------------- #
  nativeBuildInputs = with pkgs; [
    autoPatchelfHook
    makeWrapper
  ];
  # ----------------------------------------------------------------- #
  buildInputs = with pkgs; [
    alsaLib
    file
    fontconfig.lib
    freetype
    libglvnd
    libpulseaudio
    stdenv.cc.cc.lib
    xorg.libX11
    xorg.libXext
    xorg.libXi
    xorg.libXrender
    xorg.libXtst
    xorg.libXrandr
    xorg.libXinerama
    zlib
  ];
  # ----------------------------------------------------------------- #
  dontAutoPatchelf = true;
  # ----------------------------------------------------------------- #
  postFixup = ''
    autoPatchelf \
      $out/bin \
      $out/lib/runtime/lib/jexec \
      $out/lib/runtime/lib/jspawnhelper \
      $(find "$out/lib/runtime/lib" -type f -name 'lib*.so' -a -not -name 'libj*.so')
    wrapProgram $out/bin/AudioRelay \
      --prefix LD_LIBRARY_PATH : $out/lib/runtime/lib/ \
      --prefix LD_LIBRARY_PATH : ${pkgs.alsaLib}/lib/ \
      --prefix LD_LIBRARY_PATH : ${pkgs.fontconfig.lib}/lib/ \
      --prefix LD_LIBRARY_PATH : ${pkgs.freetype}/lib/ \
      --prefix LD_LIBRARY_PATH : ${pkgs.libglvnd}/lib/ \
      --prefix LD_LIBRARY_PATH : ${pkgs.libpulseaudio}/lib/ \
      --prefix LD_LIBRARY_PATH : ${pkgs.stdenv.cc.cc.lib}/lib/ \
      --prefix LD_LIBRARY_PATH : ${pkgs.xorg.libX11}/lib/ \
      --prefix LD_LIBRARY_PATH : ${pkgs.xorg.libXext}/lib/ \
      --prefix LD_LIBRARY_PATH : ${pkgs.xorg.libXi}/lib/ \
      --prefix LD_LIBRARY_PATH : ${pkgs.xorg.libXrender}/lib/ \
      --prefix LD_LIBRARY_PATH : ${pkgs.xorg.libXtst}/lib/ \
      --prefix LD_LIBRARY_PATH : ${pkgs.zlib}/lib/
  '';
  # ----------------------------------------------------------------- #
  meta = with lib; {
    description = "An application to stream audio between devices";
    homepage = "https://audiorelay.net";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [];
  };
#######################################################################
})
