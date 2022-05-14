
# bats-core test file for git_sync script

setup() {
  load 'test_helper/bats-support/load'
  load 'test_helper/bats-file/load'
  load 'test_helper/bats-assert/load'

  # get directory of this file, no matter where it is run
  # do not use ${BASH_SOURCE[0]} or $0
  DIR="$( cd "$( dirname "${BATS_TEST_FILENAME}" )" >/dev/null 2>&1 && pwd )"
  PATH="${DIR}/..:${PATH}"

  TEMP_TEST_DIR="$(mktemp -d /tmp/git_sync_test_XXXXX)"
  
  local work_dir
  work_dir="${PWD}"

  cd "${TEMP_TEST_DIR}"
  git init --bare test.git

  mkdir test1 test2

  git clone test.git test2 2>/dev/null
  cd test2

  # config required to commit
  git config user.email "tester@example.com"
  git config user.name "tester"

  echo "hello world" > test_file.txt
  git add .
  git commit -m "Add text file"
  git push origin master

  cd ..
  git clone test.git test1 2>/dev/null
  cd test1
  
  git config user.email "tester@example.com"
  git config user.name "tester"
  
  echo "another line" >> test_file.txt
  git add .
  git commit -m "Add a line to the file"
  git push origin master
  
  cd "${work_dir}"
}

teardown() {
  rm -rf "${TEMP_TEST_DIR}/test1"
  rm -rf "${TEMP_TEST_DIR}/test2"
  rm -rf "${TEMP_TEST_DIR}/test.git"
}

@test "print usage and fail when run without options" {
  assert_file_exists git_sync
  assert_file_executable git_sync

  run git_sync
  assert_output --partial "Usage:"
  assert_failure
}

@test "print usage with \"-h\" option" {
  run git_sync -h
  assert_success
  assert_output --partial "Usage:"
  assert_output --partial "-h"
}

@test "master branch is behind origin after fetch" {
  local work_dir
  work_dir="${PWD}"
  cd "${TEMP_TEST_DIR}/test2"
  run git_sync -f
  assert_success
  [ "$(git rev-parse master)" != "$(git rev-parse origin/master)" ]
  cd "${work_dir}"
}

@test "master branch behind origin after fetch with \"-d\" option" {
  run git_sync -f -d "${TEMP_TEST_DIR}/test2"
  assert_success
  
  local work_dir
  work_dir="${PWD}"
  cd "${TEMP_TEST_DIR}/test2"
  [ "$(git rev-parse master)" != "$(git rev-parse origin/master)" ]
  cd "${work_dir}"
}

@test "master branch updated after pull with \"-p\" option" {
  local work_dir
  work_dir="${PWD}"
  cd "${TEMP_TEST_DIR}/test2"
  local hash_local
  hash_local="$(git rev-parse master)"
  #echo "# hash_local=${hash_local}" >&3
  local hash_remote
  hash_remote="$(git rev-parse origin/master)"
  #echo "# hash_remote=${hash_remote}" >&3
  run git_sync -p
  assert_success
  #echo "# hash_local=$(git rev-parse master)" >&3
  #echo "# hash_remote=$(git rev-parse origin/master)" >&3

  [ "$(git rev-parse master)" != "${hash_local}" ]
  [ "$(git rev-parse master)" != "${hash_remote}" ]
  [ "$(git rev-parse origin/master)" != "${hash_local}" ]
  [ "$(git rev-parse origin/master)" != "${hash_remote}" ]
  [ "$(git rev-parse master)" == "$(git rev-parse origin/master)" ]
  cd "${work_dir}"
}
