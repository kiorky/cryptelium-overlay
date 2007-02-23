LIBDIR=$(ROOT)//usr/local/lib/xdtv/

VERSION=1.4.0
NAME=libxdtv-theme-carbone-fr

all:       
	$(CC) -shared -fPIC $(CFLAGS) $(LDFLAGS) -Wl,-soname,$(NAME).so lib-pixmaps.c -o $(NAME).so

install:
	mkdir -p $(R)$(DESTDIR)$(LIBDIR)
	install -m 644 $(NAME).so $(R)$(DESTDIR)$(LIBDIR)

uninstall :
	rm -f $(R)$(DESTDIR)$(LIBDIR)$(NAME).so

distclean: clean
	rm -f Makefile *.bak

clean:
	rm -f *~ .*~ *.so

distdir:
	mkdir -p ../$(NAME)-$(VERSION)/src
	cp -pr Makefile Makefile.in lib-pixmaps.c all_pixmaps_headers.h ../$(NAME)-$(VERSION)/src
