## What is git_sync?

A Git-based Bash script to synchronize your files on Linux machines. If you have (Git)[https://git-scm.com] and (Bash)[https://www.gnu.org/software/bash/] installed, you probably do not need to install any additional software.  Just download one script file.

## Features

1. Written in modern Bash
2. Strives to adhere to the (Google Shell Style Guide)[https://google.github.io/styleguide/shellguide.html]
3. Includes tests written in Bash using (bats-core)[https://github.com/bats-core/bats-core]
4. User-defined wait time to avoid pushing too many commits

## Installation 

Download the (git_sync)[git_sync] file from this repository.

Alternatively, clone this repository:

```
git clone https://github.io/alexgose/git_sync
cd git_sync
```

Make the script file executable:

```
chmod a+x git_sync
```

## Usage

See usage information from running the script with the "-h" option:

```
./git_sync -h
```

## Cron Job

To automate the synchronization of your files, set up a cron job to check for changes periodically:

```
crontab -e
```

Add the following line to the end of the file to run git_sync every hour to pull changes from the remote repository, stage any unstaged changes, and push any staged changes that have not been modified in the past 20 minutes:

```
0   *   *   *   *   /path/to/git_sync -psC -d /path/to/your/files
```

## Tests

You can run the tests if you cloned the repository.  Be sure to install the submodules:

```
git submodule init
git submodule update
```

## Docker

If you have Docker installed, then build the Docker image using the Dockerfile in the cloned repository:

```
docker build -t gitsynctest .
```

Run the tests in the container:

```
docker run -it --rm -v "${PWD}:/code" --name gitsynctest gitsynctest
```

## Authors

Alexander H Gose

## License

MIT License.  See the [LICENSE](LICENSE) file.

## Acknowledgements

Thank you to all those who contributed to the projects mentioned in this [file](README.md).
