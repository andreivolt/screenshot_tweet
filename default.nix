{ pkgs ? import <nixpkgs> {} }:

with pkgs;

python3Packages.buildPythonApplication rec {
  pname = "screenshot-tweet";
  version = "1.0";

  src = ./.;

  propagatedBuildInputs = [
    python3Packages.playwright
  ];

  preBuild = ''
    cat > setup.py << EOF
from setuptools import setup

setup(
  name="${pname}",
  version="${version}",
  scripts=[
    'screenshot_tweet',
  ],
  install_requires=[
    'playwright',
  ],
  entry_points={
    'console_scripts': [
      'screenshot_tweet=screenshot_tweet:main'
    ]
  },
)
EOF
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp screenshot_tweet $out/bin
    chmod +x $out/bin/screenshot_tweet
  '';

  postInstall = ''
    wrapProgram $out/bin/screenshot_tweet \
      --set PLAYWRIGHT_BROWSERS_PATH "${pkgs.playwright-driver.browsers.outPath}"
  '';

  doCheck = false;
}
