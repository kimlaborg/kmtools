#!/bin/bash

set -ev

if [[ -z "${GITHUB_TOKEN}" ]] ; then
    echo "GitHub API key needs to be set to update docs."
    exit -1
fi

GITHUB_USERNAME=$(dirname $TRAVIS_REPO_SLUG)
GITHUB_REPONAME=$(basename $TRAVIS_REPO_SLUG)

# Install sphinx requirements
pip install -yq sphinx sphinx_rtd_theme

# Update modules
cd "${TRAVIS_BUILD_DIR}/docs"
touch ../kmtools/__init__.py
sphinx-apidoc ../kmtools -o modules/ -MfPe
rm ../kmtools/__init__.py

# Build the documentation
mkdir -p _build_gh_pages
cd _build_gh_pages
git init
git checkout -b gh-pages
git remote add origin https://github.com/${GITHUB_USERNAME}/${GITHUB_REPONAME}.git
sphinx-build .. .
touch .nojekyll
git add .nojekyll
echo '.*' >> .gitignore
git add .
git config user.name "Travis CI"
git commit --all -m "Updated docs to commit ${TRAVIS_COMMIT}."
git push -f -q "https://${GITHUB_TOKEN}@github.com/${GITHUB_USERNAME}/${GITHUB_REPONAME}.git" \
    gh-pages &> /dev/null

# Cleanup
cd ..
rm -rf "${PKG_NAME}.github.io"
