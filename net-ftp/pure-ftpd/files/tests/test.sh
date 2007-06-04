#!/bin/sh
t="/home/kiorky/bordel/ng/ukn-gdj/Poppoya.avi"
mkdir tmp;
pushd  tmp;


HOST="192.168.0.8"
PORT="556"

tls_opts="set ftp:ssl-allow yes ;set ftp:ssl-allow-anonymous no ;set ftp:ssl-auth TLS ;set ftp:ssl-data-use-keys yes ;set ftp:ssl-force yes ;set ftp:ssl-protect-data yes ;set ftp:ssl-protect-fxp yes ;set ftp:ssl-protect-list yes ;set ftp:ssl-use-ccc yes ;set ssl:verify-certificate no" 
clear_opts="set ftp:ssl-allow yes ;set ftp:ssl-allow-anonymous no ;set ftp:ssl-auth TLS ;set ftp:ssl-data-use-keys no ;set ftp:ssl-force no ;set ftp:ssl-protect-data no ;set ftp:ssl-protect-fxp no ;set ftp:ssl-protect-list no ;set ftp:ssl-use-ccc no"
aclear_opts="set ftp:ssl-allow no ;set ftp:ssl-allow-anonymous no ;set ftp:ssl-auth TLS ;set ftp:ssl-data-use-keys no ;set ftp:ssl-force no ;set ftp:ssl-protect-data no ;set ftp:ssl-protect-fxp no ;set ftp:ssl-protect-list no ;set ftp:ssl-use-ccc no" 
ttls() {
	lftp  \
	-u narishma,$1 \
	-e "$tls_opts;put $t  ../*;ls -l;mget *;exit" \
	ftp://${HOST}:${PORT};
}

tclear() {
	lftp  \
	-u narishma,$1 \
	-e "$clear_opts;put $t  ../*;ls -l;mget *;exit" \
	ftp://${HOST}:${PORT};
}
atclear() {
	lftp  \
	-u narishma,$1 \
	-e "$aclear_opts;put $t  ../*;ls -l;mget *;exit" \
	ftp://${HOST}:${PORT};
} 

ttls    $@
#tclear   $@
#atclear   $@
popd

