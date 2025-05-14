{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchPypi,
}:
############
# Packages #
#########################################################################
let
  comment = "Python3 Hello World";
  pname = "pip-hello-world";
  version = "0.1";
in python3Packages.buildPythonApplication rec {
  ## ----------------------------------------------------------------- ##
  inherit pname version;
  format = "pyproject";         # for not setup.py
  dontUseCmakeConfigure = true; # for not setup.py
  doCheck = false;
  ## ----------------------------------------------------------------- ##
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-framXG712U7EWdZAP5Xz7dzEGkomaF7aoF7kX6sq5GU=";
  };
  ## ----------------------------------------------------------------- ##
  # src = fetchFromGitHub {
  #   owner = "pedrocunial";
  #   repo = "pip-helloworld";
  #   rev = version; # 7385eb989647509325d4f8f60e839ee699f5802a
  #   sha256 = "";
  # };
  ## ----------------------------------------------------------------- ##
  # nativeBuildInputs = [
  # ];
  #
  # buildInputs = [
  # ];
  ## ----------------------------------------------------------------- ##
  propagatedBuildInputs = with python3Packages; [
    setuptools
  ];
  ## ----------------------------------------------------------------- ##
  meta = with lib; {
    description = comment;
    homepage = "https://github.com/RevoluNix/pkg-python311Package.template/";
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pikatsuto ];
    mainProgram = pname;
  };
  #######################################################################
}
