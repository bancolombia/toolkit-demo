#!/bin/bash

VAR_NAME_ROOT_REPOSITORY=$(echo $VAR_NAME_REPOSITORY | cut -d'/' -f2)
cd ..
mkdir -p $VAR_NAME_ROOT_REPOSITORY/semantic-release/
cp $OFL "toolkit-demo/files/semantic-release/create-release-branch.js" "$VAR_NAME_ROOT_REPOSITORY/semantic-release/create-release-branch.js"
cp $OFL "toolkit-demo/files/semantic-release/release.config.js" "$VAR_NAME_ROOT_REPOSITORY/release.config.js"
cp $OFL "toolkit-demo/files/semantic-release/release-rules.js" "$VAR_NAME_ROOT_REPOSITORY/semantic-release/release-rules.js"
cp $OFL "toolkit-demo/files/semantic-release/writerChangelog.js" "$VAR_NAME_ROOT_REPOSITORY/semantic-release/writerChangelog.js"
cp $OFL "toolkit-demo/files/semantic-release/semantic-release.yml" "$VAR_NAME_ROOT_REPOSITORY/.github/workflows/semantic-release.yml"
