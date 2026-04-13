# GIT branching strategy to Build Promote
This project captures a structured promotion flow with MAIN governing three controlled branches (DEV, TEST, Main/PROD) and enforcing build immutability and promotion-based lifecycle:

![Image](./images/source.png)

This representation enforces promotion over rebuild, ensures traceability across environments, and embeds governance gates before production release-driving consistency, reliability, and auditability across the delivery pipeline.

**NOTE:** Lengend
 - **CC**: A developer code commit to the DEV branch automatically triggers a new build and publishes the artifacts to the JFrog platform.
 - **PR**: Every pull request from DEV → TEST or TEST → MAIN promotes the corresponding DEV branch build to the next local repository.
     - **DEV → TEST**: promote from _prbranch-bpr-dev-local_ to **prbranch-bpr-test-local**
     - **TEST → MAIN**: promote from _prbranch-bpr-test-local_ to **prbranch-bpr-prod-local** 
<br>

### Actions status:
 - **branch DEV**: Artifactory create and build published to _prbranch-bpr-dev-local_ [![DEV: Build Create](https://github.com/ps-jfrog/PRbuildPromote/actions/workflows/build-create.yml/badge.svg)](https://github.com/ps-jfrog/PRbuildPromote/actions/workflows/build-create.yml)
 - **branch TEST**: git merged from DEV, Artifactory build promoted to _prbranch-bpr-test-local_ [![DEV 2 TEST: Build Promote](https://github.com/ps-jfrog/PRbuildPromote/actions/workflows/promote-test.yml/badge.svg)](https://github.com/ps-jfrog/PRbuildPromote/actions/workflows/promote-test.yml)
 - **branch MAIN**: git merged from TEST, Artifactory build promoted to _prbranch-bpr-prod-local_ [![TEST 2 PROD: Build Promote](https://github.com/ps-jfrog/PRbuildPromote/actions/workflows/promote-prod.yml/badge.svg)](https://github.com/ps-jfrog/PRbuildPromote/actions/workflows/promote-prod.yml)

### Sequence Flow
```mermaid
sequenceDiagram
    autonumber
    participant code as Code
    participant pr as Terminal CLI-PR
    participant vcs as GIT VCS
    participant action as GITHUB ACTIONS
    participant repos as REPO Management
    loop developer build code
        code->>vcs: A developer commits code to the DEV branch in Git.
        vcs->>action: Triggers the build-create.yml pipeline for a commit on the DEV branch.
        action->>repos: Creates an artifact, uploads it to init-local, and then promotes it to dev-local.
    end
    loop DEV to TEST pr
        pr->>vcs: Creates a PR from the DEV branch and merges it into the TEST branch using ./scripts/pr-dev2test.sh (promote/dev-to-test).
        action->>repos: The promote-test.yaml pipeline runs and transfers the artifact from dev-local to qa-local, adding a status comment: “Promoted from DEV (DEV_COMMIT_SHORT_SHA) to TEST (MERGE_COMMIT_SHORT_SHA).”
    end
    loop TEST to MAIN pr
        pr->>vcs: Creates a PR from the TEST branch and merges it into the MAIN branch using ./scripts/pr-test2prod.sh (promote/test-to-main).
        action->>repos: The promote-prod.yaml pipeline runs and transfers the artifact from qa-local to prod-local, adding a status comment: “Promoted from TEST (MERGE_COMMIT_SHORT_SHA) to PROD (MERGE_COMMIT_SHORT_SHA).”
    end
```

## Screenshots

### Repo structure
![Repos](./images/repos.png)

### Builds
![Builds](./images/builds.png)
![Publish Module](./images/pubmodule.png)
![Release History](./images/relhistory.png)
![VCS](./images/vcs.png)
![Build Info](./images/buildinfo.png)
