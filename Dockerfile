from ubuntu:20.04

RUN apt-get update -y \
  && apt-get install -y \
    git

WORKDIR /code
USER 1000
SHELL ["/bin/bash","-c"]

CMD ["test/bats/bin/bats","test/"]
