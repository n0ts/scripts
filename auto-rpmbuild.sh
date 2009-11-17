#!/bin/sh

RPMBUILD=/usr/bin/rpmbuild
if [ ! -x $RPMBUILD ]; then
    echo "Could not found $RPMBUILD"
    exit 1
fi

SPEC=
for arg in "$@"; do
    if [ -f "$arg" ]; then
        SPEC=$arg
    else
        echo $arg | egrep "\.spec$" > /dev/null
        RETVAL=$?
        if [ $RETVAL -eq 0 ]; then
            SPEC=`rpm -E '%_topdir'`/SPECS/$arg
        fi
    fi
done
if [ ! -f $SPEC ]; then
    echo "Could not found spec. - $SPEC"
    exit 1
fi

OUTPUT_FILE="/tmp/`basename $0`.out"
OUTPUT=`$RPMBUILD --nobuild $SPEC 2> $OUTPUT_FILE`
RETVAL=$?
if [ $RETVAL -ne 0 ]; then
    while read line; do
        PACKAGE=`echo "$line" | egrep ".* is needed by .*" | cut -d ' ' -f 1`
        if [ -n "$PACKAGE" ]; then
            rpm -qi "$PACKAGE" > /dev/null
            if [ $? -ne 0 ]; then
                sudo yum -y install "$PACKAGE"
                if [ $? -ne 0 ]; then
                    "Install package error. - $PACKAGE"
                    exit 1
                fi
            fi
        fi
    done < "$OUTPUT_FILE"
fi
echo ""
rm -f $OUTPUT_FILE

$RPMBUILD $@
