# Distributed under the terms of the GNU General Public License v2
# $Header: $
#author: kiorky@cryptelium.net

inherit distutils eutils

DESCRIPTION="Retrieves and processes .nzb files"
HOMEPAGE="http://www.hellanzb.com/"
SRC_URI="http://www.hellanzb.com/distfiles/${P}.tar.gz"

LICENSE="hellanzb"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64 ~sparc"
IUSE=""

RDEPEND=">=dev-python/twisted-2.0
		dev-python/twisted-web
		|| ( app-arch/unrar
			 app-arch/rar )
		app-arch/par2cmdline"
DEPEND=""

DOCS="CHANGELOG CREDITS PKG-INFO README"

src_unpack() {
	unpack ${A}
	cd "${S}"
	mv setup.py setup.py.old || die

	# Remove the data_files lines, because they don't install
	# the portage way.
	awk 'BEGIN {skip = 0} /data_files/ {skip = 3} skip > 0 {skip--} skip == 0 {print $0}'  \
		setup.py.old > setup.py || die
}

src_compile() {
	distutils_src_compile
}

src_install() {
	distutils_src_install

	newconfd "${FILESDIR}/hellanzb.conf" hellanzb
	newinitd "${FILESDIR}/hellanzb.init" hellanzb

	insinto etc
	doins etc/hellanzb.conf.sample
}

pkg_postinst() {
	einfo "You can start hellanzb in the background automatically by using"
	einfo "the init-script. To do this, add it to your default runlevel:"
	einfo ""
	einfo "    rc-update add hellanzb default"
	einfo ""
	einfo "Use this command to start the daemon now:"
	einfo ""
	einfo "    /etc/init.d/hellanzb start"
	einfo ""
	einfo "You will have to config /etc/conf.d/hellanzb before the init-script"
	einfo "will work. It is recommended that you change the user under which"
	einfo "the daemon will run."
}
