FROM golang:1.19-alpine

RUN apk add curl docker jq cosign
RUN curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin
RUN curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin
RUN curl -sSfL https://github.com/michaelsauter/crane/releases/download/v3.6.1/crane_linux_amd64 | sh -s mv crane_linux_amd64 /usr/local/bin/crane | sh -s chmod +x /usr/local/bin/crane

