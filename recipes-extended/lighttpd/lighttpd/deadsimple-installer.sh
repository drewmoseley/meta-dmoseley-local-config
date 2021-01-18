#!/bin/bash
#

source /usr/bin/cgibashopts

echo "Content-type: text/html"
echo ""

echo '<html>'
echo '<head>'
echo '<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">'
echo '<title>Foo</title>'
echo '</head>'
echo '<body>'

echo "<p>Start</p>"
echo "<pre>"
env

set -x
echo mv ${FORMFILE_file1} /tmp/${FORM_file1}
echo ls -l /tmp/${FORM_file1}
md5sum ${FORMFILE_file1}
set +x

echo "</pre>"

echo '</body>'
echo '</html>'

exit 0
