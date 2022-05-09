
# bats-core test file for git_sync script

setup() {
  load 'test_helper/bats-support/load'
  load 'test_helper/bats-file/load'
  load 'test_helper/bats-assert/load'

  # get directory of this file, no matter where it is run
  # do not use ${BASH_SOURCE[0]} or $0
  DIR="$( cd "$( dirname "${BATS_TEST_FILENAME}" )" >/dev/null 2>&1 && pwd )"
  PATH="${DIR}/..:${PATH}"
}


@test "print usage and fail when run without options" {
  assert_file_exists git_sync
  assert_file_executable git_sync

  run git_sync
  assert_output --partial "Usage:"
  assert_failure
}
