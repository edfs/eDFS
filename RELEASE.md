## Release process

This document simply outlines the release process:

1) Remove `-dev` extension from VERSION

2) Run `make clean test` to ensure all tests pass from scratch and the CI is green

3) Ensure CHANGELOG is updated and tag release version with timestamp in it

4) Commit changes above with title "Release vVERSION"

5) Push master and create tag vVERSION from master branch

6) Merge master into stable branch and push it

7) After release, bump versions, add `-dev` back and commit

## Places where version is mentioned

* VERSION
* CHANGELOG
