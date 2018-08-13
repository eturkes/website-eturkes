"""
Minify collected javascript files

This would ideally be moved into either the frontend building pipeline (gulp
et al.) or integrated into the building process (collectstatic or another
management command).
"""
import os
import gzip
import sys

import rjsmin


PY2 = sys.version_info[0] == 2


def minify(staticfiles_path):
    for root, dirs, files in os.walk(staticfiles_path):
        for file in files:
            if not file.endswith('.js'):
                continue
            file = os.path.join(root, file)
            with open(file, 'r+') as fh:
                minified = rjsmin.jsmin(fh.read())
                fh.truncate(0)
                fh.write(minified)
            if os.path.exists(file + '.gz'):
                with gzip.open(file + '.gz', 'w') as fh:
                    if PY2:
                        # On Python 2, calling encode without decoding first
                        # will raise a decode error because python will assume ascii
                        # when decoding the string to then encode it.
                        minified = minified.decode('utf-8')
                    fh.write(minified.encode('utf-8'))


minify('/app/static_collected')
