#!/bin/bash

set -o errexit -o nounset -o pipefail

npm run build

git add -f dist/
git commit -m Deploy
git push origin "$(git subtree split --prefix dist/ master)":gh-pages --force
git reset --hard '@{1}'
