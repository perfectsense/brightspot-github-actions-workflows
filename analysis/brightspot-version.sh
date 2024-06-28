#!/bin/bash

set -euo pipefail

script_dir="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"


find_bsp_version_gradle() {
  ./gradlew --init-script "$script_dir/bsp-version.gradle" --quiet brightspotVersion \
    | grep -v "${GITHUB_REPOSITORY##*/}" \
    | grep -v 'Build finished' \
    | grep -v 'buildFinished' \
    | grep -vE '^\s*$' \
    || echo ''
}

find_bsp_version_maven() {
  sudo apt-get install -y xsltproc

  if [ -f 'pom.xml' ]; then
    xsltproc --stringparam project "${GITHUB_REPOSITORY##*/}" "$script_dir/print-parent-versions.xslt" pom.xml

  else

    # no root pom.xml
    find . -name pom.xml -exec \
      xsltproc --stringparam project "${GITHUB_REPOSITORY##*/}" "$script_dir/print-parent-versions.xslt" {} \;
  fi
}


if [ -f 'settings.gradle' ]; then
  version="$(find_bsp_version_gradle)"
else
  version="$(find_bsp_version_maven)"
fi

if [ -z "$version" ]; then
  version='N/A'
fi

echo "$version" | sort | uniq  # sometimes mulitple projects/modules match, but they often have the same BSP version
