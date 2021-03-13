#!/bin/bash

# Copyright (C) 2021  Ace <teapot@aceforeverd.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


set -eE
set -o nounset

cd "$(dirname "$0")"
cd "$(git rev-parse --show-toplevel)"

STATUS=0

for file in $(git ls-files); do
    if [[ $file = *.vim ]] ; then
        # incase set -e breaks
        vint "$file" || STATUS=1
    fi
done

exit $STATUS
