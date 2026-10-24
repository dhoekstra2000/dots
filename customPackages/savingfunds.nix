{ pkgs, ... }:
pkgs.python3Packages.buildPythonApplication {
  pname = "savingfunds";
  version = "0.3.1";
  pyproject = true;
  src = pkgs.python3Packages.fetchPypi {
    pname = "savingfunds";
    version = "0.3.1";
    sha256 = "sha256-4Jdc4sQ0sQg2C8k0bU3fJdttjsojM/mRLrXP8as93+g=";
  };
  nativeBuildInputs = with pkgs.python3Packages; [ hatchling ];
  propagatedBuildInputs = with pkgs.python3Packages; [
    click
    rich
    pyyaml
    schwifty
  ];
  doCheck = false;
}
