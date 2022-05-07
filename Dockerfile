from ubuntu:20.04

WORKDIR /code
USER 1000
SHELL ["/bin/bash","-c"]

CMD ["test/bats/bin/bats","test/"]
