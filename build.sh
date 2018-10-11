#!/bin/sh
set -e
set -u

BLUE='\033[1;34m'
NC='\033[0m'
DIR=$(cd "$(dirname "$0")"; pwd)

VSCODE_FILE="SonarSource.sonarlint-vscode.vsix"

if [ -f che-sonarlint-plugin.tar.gz ]; then
    rm che-sonarlint-plugin.tar.gz
fi

if [ -f ${VSCODE_FILE} ]; then
  printf "${BLUE}VSCode extension already downloaded${NC}\n"
else
  printf "${BLUE}Download VSCode extension as it is not there${NC}\n"
  curl --compressed -o ${VSCODE_FILE} https://marketplace.visualstudio.com/_apis/public/gallery/publishers/SonarSource/vsextensions/sonarlint-vscode/1.5.0/vspackage
fi

UNPACKED_DIRECTORY='unpacked'
if [ -d "${UNPACKED_DIRECTORY}" ]; then
  printf "${BLUE}Remove existing unpacked directory${NC}\n"
  rm -rf ${UNPACKED_DIRECTORY}
fi

printf "${BLUE}Unpack VSCode extension${NC}\n"
mkdir -p unpacked/sonarsource-sonarlint-plugin
unzip -q ${VSCODE_FILE} -d unpacked/sonarsource-sonarlint-plugin/

printf "${BLUE}Creating Che plug-in${NC}\n"
tar cf che-sonarlint-plugin.tar -C unpacked .
cd etc
tar uf ../che-sonarlint-plugin.tar .
cd ..
gzip che-sonarlint-plugin.tar

printf "${BLUE}Plug-in generated at che-sonarlint-plugin.tar.gz${NC}\n"
