#!/bin/bash

FILS="
/etc/systemd/system/multi-user.target.wants/apache2.service
/run/systemd/units/invocation:apache2.service
/usr/lib/systemd/system/apache2.service
/var/lib/systemd/deb-systemd-helper-enabled/apache2.service.dsh-also
/var/lib/systemd/deb-systemd-helper-enabled/multi-user.target.wants/apache2.service
"

for f in $FILS
do
    echo "Running ls -l on file $f"
    ls -ld $f
done
