# GIT branching strategy to Build Promote
This project captures a structured promotion flow with MAIN governing three controlled branches (DEV, TEST, Main/PROD) and enforcing build immutability and promotion-based lifecycle:

![Image](./images/source.png)

This representation enforces promotion over rebuild, ensures traceability across environments, and embeds governance gates before production release-driving consistency, reliability, and auditability across the delivery pipeline.

<span style='color:red; font-weight:bold;'>NOTE:</span> Lengend
 - <strong>CC</strong>: developer Code Commit to the branch DEV
 - <strong>PR</strong>: Pull Request from the branch DEV to TEST or TEST to MAIN 
<br>

### Actions status:
 - <strong>branch DEV</strong>: Artifactory create and build published to _prbranch-bpr-dev-local_ [![DEV: Build Create](https://github.com/ps-jfrog/PRbuildPromote/actions/workflows/build-create.yml/badge.svg)](https://github.com/ps-jfrog/PRbuildPromote/actions/workflows/build-create.yml)
 - <strong>branch TEST</strong>: git merged from DEV, Artifactory build promoted to _prbranch-bpr-test-local_ [![DEV 2 TEST: Build Promote](https://github.com/ps-jfrog/PRbuildPromote/actions/workflows/promote-test.yml/badge.svg)](https://github.com/ps-jfrog/PRbuildPromote/actions/workflows/promote-test.yml)
 - <strong>branch MAIN</strong>: git merged from TEST, Artifactory build promoted to _prbranch-bpr-prod-local_ [![TEST 2 PROD: Build Promote](https://github.com/ps-jfrog/PRbuildPromote/actions/workflows/promote-prod.yml/badge.svg)](https://github.com/ps-jfrog/PRbuildPromote/actions/workflows/promote-prod.yml)

