#!/bin/bash

VAR_NAME_ROOT_REPOSITORY=$(echo $VAR_NAME_REPOSITORY | cut -d'/' -f2)
cd ..
mkdir -p $VAR_NAME_ROOT_REPOSITORY/semantic-release/
cp $OFL "innersource-toolkit/Toolkit/Tools/Semantic-Release/create-release-branch.js" "$VAR_NAME_ROOT_REPOSITORY/semantic-release/create-release-branch.js"
cp $OFL "innersource-toolkit/Toolkit/Tools/Semantic-Release/release.config.js" "$VAR_NAME_ROOT_REPOSITORY/release.config.js"
cp $OFL "innersource-toolkit/Toolkit/Tools/Semantic-Release/release-rules.js" "$VAR_NAME_ROOT_REPOSITORY/semantic-release/release-rules.js"
cp $OFL "innersource-toolkit/Toolkit/Tools/Semantic-Release/writerChangelog.js" "$VAR_NAME_ROOT_REPOSITORY/semantic-release/writerChangelog.js"
cp $OFL "innersource-toolkit/Toolkit/Tools/Semantic-Release/semantic-release.yml" "$VAR_NAME_ROOT_REPOSITORY/.github/workflows/semantic-release.yml"