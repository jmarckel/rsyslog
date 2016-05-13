#!/bin/bash
# addd 2016-05-13 by RGerhards, released under ASL 2.0

. $srcdir/diag.sh init
. $srcdir/diag.sh generate-conf
. $srcdir/diag.sh add-conf '
module(load="../plugins/imptcp/.libs/imptcp")
input(type="imptcp" port="13514")

template(name="outfmt" type="string" string="%msg:F,58:2%\n")
:msg, contains, "msgnum:" action(type="omfile" template="outfmt"
			         file="rsyslog.out.log")
'
. $srcdir/diag.sh startup
echo '<167>Mar  6 16:57:54 172.20.245.8 test: msgnum:0 X test message' | tr X '\000' | nc 127.0.0.1 13514
echo '<167>Mar  6 16:57:54 172.20.245.8 Xtest: msgnum:1 test message' | tr X '\000' | nc 127.0.0.1 13514
. $srcdir/diag.sh shutdown-when-empty
. $srcdir/diag.sh wait-shutdown
. $srcdir/diag.sh seq-check 0 1
. $srcdir/diag.sh exit
