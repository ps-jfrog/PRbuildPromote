# 
This project captures a structured promotion flow with MAIN governing three controlled branches (DEV, TEST, Main/PROD) and enforcing build immutability and promotion-based lifecycle:

![Image](./images/source.png)

This representation enforces promotion over rebuild, ensures traceability across environments, and embeds governance gates before production release-driving consistency, reliability, and auditability across the delivery pipeline.

### Actions status:
 - branch DEV: Artifactory create and build published to _prbranch-bpr-dev-local_ [![DEV: Build Create](https://github.com/ps-jfrog/PRbuildPromote/actions/workflows/build-create.yml/badge.svg)](https://github.com/ps-jfrog/PRbuildPromote/actions/workflows/build-create.yml)
 - branch TEST: git merged from DEV, Artifactory build promoted to _prbranch-bpr-test-local_
 - branch MAIN: git merged from TEST, Artifactory build promoted to _prbranch-bpr-prod-local_

