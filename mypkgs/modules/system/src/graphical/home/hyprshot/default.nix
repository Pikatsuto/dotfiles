{ stdenv, lib }:
############
# Packages #
#######################################################################
stdenv.mkDerivation (finalAttrs: {
  pname = "hyprshot";
  version = "unstable-2023-07-16";
  # ----------------------------------------------------------------- #
  src = ./src;
  # ----------------------------------------------------------------- #
  installPhase = ''
    runHook preInstall

    install -D --target-directory=$out/bin/ ./hyprshot

    runHook postInstall
  '';
  # ----------------------------------------------------------------- #
  meta = with lib; {
    description = "terminal screenshot manager";
    homepage = "https://github.com/reinefjord/wayshot/";
    maintainers = [ maintainers.pikatsuto ];
    licenses = licenses.mit;
    platforms = platforms.linux;
  };
#######################################################################
})
