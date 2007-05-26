# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_ANT__REWRITE_CLASSPATH="y"
JAVA_ANT_JAVADOC_INPUT_DIRS="${WORKDIR}/src"
inherit java-pkg-2 java-ant-2

DESCRIPTION="Java API for XML Registries (JAXR) - API"
HOMEPAGE="http://java.sun.com/xml/downloads/jaxr.html"
SRC_URI="jaxr-1_0-fr-spec.zip"

LICENSE="sun-bcla-jsr101"
RESTRICT="fetch"
SLOT="0"
KEYWORDS="~ppc ~x86"

IUSE="doc"
#IUSE=""

RDEPEND=">=virtual/jre-1.4 dev-java/sun-jaf"
DEPEND=">=virtual/jdk-1.4
	dev-java/sun-jaf
	app-arch/unzip"

S="${WORKDIR}"

EANT_GENTOO_CLASSPATH="sun-jaf"

#EANT_DOC_TARGET="foo"

pkg_nofetch() {

	einfo "Please go to"
	einfo " ${HOMEPAGE}"
	einfo "and download file:"
	einfo ' "Java API for XML Registries Specification 1.0"'
	einfo "Place the file ${SRC_URI} in:"
	einfo " ${DISTDIR}"

}

src_unpack() {

	unpack ${A}

	cd "${WORKDIR}"
	mkdir src || die
	unzip -qq jaxr-apisrc.jar -d src || die "unzip failed"
	rm -f *.jar
	mkdir lib || die

	cd lib
	java-pkg_jar-from sun-jaf

	cp "${FILESDIR}/build.xml-${PV}" "${S}/build.xml" || die

}

src_install() {
	java-pkg_dojar "jsr93-api.jar"
	use source && java-pkg_dosrc src/*

}
