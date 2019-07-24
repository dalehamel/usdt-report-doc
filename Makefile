SHELL=/bin/bash -o pipefail

DOCKER ?= docker

.DEFAULT_GOAL := all

PANDOC_BUILDER_IMAGE ?= "quay.io/dalehamel/pandoc-report-builder"
PWD ?= `pwd`

.PHONY: clean
clean:
	docker rm -f ${DOCKER_BUILDER} || true

.PHONY: doc/build
doc/build:
	${DOCKER} run -v ${PWD}:/app ${PANDOC_BUILDER_IMAGE} /app/scripts/pandoc-build

.PHONY: quirks
quirks:
	scripts/tidy

all: doc/build
