#!/bin/bash
#
# Script to replace python2.7 with a wrapper script that
# forcibly sets $HOME - this ensures that even if bazel fails to pass
# the environment for some reason that python can still run
# os.path.expanduser("~") without freakout out since our UID won't
# be found in /etc/passwd

# Move python out of the way
mv $FLATPAK_DEST/bin/python2.7 $FLATPAK_DEST/bin/python2.7.real

# Replace it with a wrapper
echo "#!/bin/bash
PYTHONNOUSERSITE=1 HOME=$(mktemp -d) ${FLATPAK_DEST}/bin/python2.7.real \$@" > $FLATPAK_DEST/bin/python2.7

# Quick sanity check
cat $FLATPAK_DEST/bin/python2.7

# Mark it executable
chmod 755 $FLATPAK_DEST/bin/python2.7
