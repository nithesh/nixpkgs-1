{ stdenv, fetchFromGitHub, cmake, ninja, libuuid, libossp_uuid, gtest }:

stdenv.mkDerivation rec {
  pname = "lib3mf";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "3MFConsortium";
    repo = pname;
    rev = "v${version}";
    sha256 = "11wpk6n9ga2p57h1dcrp37w77mii0r7r6mlrgmykf7rvii1rzgqd";
  };

  nativeBuildInputs = [ cmake ninja ];

  buildInputs = if stdenv.isDarwin then [ libossp_uuid ] else [ libuuid ];

  postPatch = ''
    rmdir UnitTests/googletest
    ln -s ${gtest.src} UnitTests/googletest

    # fix libdir=''${exec_prefix}/@CMAKE_INSTALL_LIBDIR@
    sed -i 's,=''${\(exec_\)\?prefix}/,=,' lib3MF.pc.in
  '';

  meta = with stdenv.lib; {
    description = "Reference implementation of the 3D Manufacturing Format file standard";
    homepage = "https://3mf.io/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.all;
  };
}
