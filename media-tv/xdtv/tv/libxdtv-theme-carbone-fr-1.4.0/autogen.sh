#! /bin/sh

# ****************************************************************************
# $Id: autogen.sh,v 1.4 2006/04/10 22:39:59 pingus77 Exp $
# ****************************************************************************
#
# Run this to generate all the initial makefiles, etc. 
# From the GNU Midnight Commander. Customized for giFTcurs. 
# From giFTcurs, customized for giFT. 
# From giFT, customized for giFT-FastTrack.
# From GiFT-FastTrack, customized for ivman
# From ivman, customized for XdTV
# 
# ****************************************************************************
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111, USA.
# ***************************************************************************

# Make it possible to specify path in the environment
: ${AUTOCONF=autoconf}
: ${AUTOHEADER=autoheader}
: ${AUTOMAKE=automake-1.7}
: ${ACLOCAL=aclocal-1.7}
: ${LIBTOOLIZE=libtoolize}

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

(
cd $srcdir

# Clean up.
echo "make distclean"
make distclean
rm -rf autom4te.cache

echo "Running $ACLOCAL..."
$ACLOCAL || exit 1
test -f aclocal.m4 || \
  { echo "aclocal failed to generate aclocal.m4" 2>&1; exit 1; }

echo "Running $AUTOHEADER..."
$AUTOHEADER || exit 1
test -f config.h.in || \
  { echo "autoheader failed to generate config.h.in" 2>&1; exit 1; }

echo "Running $AUTOCONF..."
$AUTOCONF || exit 1
test -f configure || \
  { echo "autoconf failed to generate configure" 2>&1; exit 1; }

echo "Running $LIBTOOLIZE --automake..."
$LIBTOOLIZE --automake || exit 1
test -f ltmain.sh || \
  { echo "libtoolize failed to generate ltmain.sh" 2>&1; exit 1; }

echo "Running $AUTOMAKE..."
$AUTOMAKE -a Makefile || exit 1
$AUTOMAKE -a || exit 1
test -f Makefile.in || \
  { echo "automake failed to generate Makefile.in" 2>&1; exit 1; }  

) || exit 1

echo "Launch configure & make dist (Y/N): [N]:"
read choice

if [ "$choice" = "Y" ]; then
  echo Running $srcdir/configure $conf_flags "$@" ...
  $srcdir/configure --cache-file=config.cache $conf_flags "$@"
  make dist
  echo ""
  echo "Now type \`make' to compile this I18n lib for XdTV."
  echo ""
fi

