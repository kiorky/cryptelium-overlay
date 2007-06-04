#!/bin/sh
LD_LIBRARY_PATH=/usr/local/tmp/portage/net-ftp/pure-ftpd-1.0.22/work/pure-ftpd-1.0.22/src/  \
        /usr/local/tmp/portage/net-ftp/pure-ftpd-1.0.22/work/pure-ftpd-1.0.22/src/pure-ftpd \
	-d -d -c 30 -C 10 -k 90% \
	-l mysql:./pureftpd-mysql.conf  \
	-A -E -j -Z -p 4252:4350 \
	-S 127.0.0.1,5556 \
         --tls=2



	# -d -d  -S 192.168.0.4,5556 \


