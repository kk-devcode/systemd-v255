#!/bin/sh
# SPDX-License-Identifier: LGPL-2.1-or-later
set -eu

tag="$(git describe --abbrev=0 --match 'v[0-9][0-9][0-9]')"
(
    # authors
    git log --pretty=tformat:%aN -s "${tag}.."
    # Co-authors (drop empty line and mail addresses)
    git log --pretty='tformat:%(trailers:key=Co-authored-by,valueonly)' -s "${tag}.." | sed -e '/^[[:space:]]*$/ d' | sed -e 's/ <.*@.*>$//'
) |
    grep -v noreply@weblate.org |
    sed 's/ / /g; s/--/-/g; s/.*/\0,/' |
    sort -u | tr '\n' ' ' | sed -e "s/^/Contributions from: /g" -e "s/,\s*$/\n/g" | fold -w 72 -s |
    sed -e "s/^/        /g" -e "s/\s*$//g"
