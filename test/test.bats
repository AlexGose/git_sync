
# bats-core test file for git_sync script

setup() {
  # get directory of this file, no matter where it is run
  # do not use ${BASH_SOURCE[0]} or $0
  DIR="$( cd "$( dirname "${BATS_TEST_FILENAME}" )" >/dev/null 2>&1 && pwd )"
  PATH="${DIR}/..:${PATH}"
}


@test "can run the script" {
  git_sync
}
