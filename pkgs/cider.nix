{ appimageTools, lib, fetchurl }:

appimageTools.wrapType2 rec {
  pname = "cider";
  version = "unstable-2022-03-06";
  name = "${pname}-${version}";

  src = fetchurl {
    url =
      "https://1308-429851205-gh.circle-artifacts.com/0/%7E/Cider/dist/artifacts/Cider-1.3.1308.AppImage";
    sha256 = "1lbyvn1c8155p039qfzx7jwad7km073phkmrzjm0w3ahdpwz3wgi";
  };

  extraInstallCommands =
    let contents = appimageTools.extract { inherit name src; };
    in ''
      mv $out/bin/${name} $out/bin/${pname}

      install -m 444 -D ${contents}/${pname}.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}'
      cp -r ${contents}/usr/share/icons $out/share
    '';

  meta = with lib; {
    description =
      "A new look into listening and enjoying Apple Music in style and performance.";
    homepage = "https://github.com/ciderapp/Cider";
    license = licenses.agpl3;
    platforms = [
      "x86_64-linux" # ...
    ];
  };
}
