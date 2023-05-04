#! bin/bash

mkdir ~/.linker
mkdir ~/.linker/mold
curl -L -k $(curl -s https://api.github.com/repos/rui314/mold/releases/latest | grep 'x86_64-linux' | grep http | cut -d\" -f4) | tar zx
mv $(ls | grep mold) mold && mv mold ~/.linker/
