{ pkgs, ... }:
pkgs.python3Packages.buildPythonApplication {
  pname = "savingfunds";
  version = "0.3.1";
  pyproject = true;
  src = fetchPypi {
    pname = "savingfunds";
    version = "0.3.1";
    sha256 = "";
  };
  nativeBuildInputs = with python3Packages; [ hatchling ];
  propagatedBuildInputs = with python3Packages; [
    click
    rich
    pyyaml
    schwifty
  ];
  doCheck = false;
}
