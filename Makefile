VERSION   ?=$(shell cat .version)
PROJECT   ?=cloudy-demos
REGISTRY  ?=us-west1-docker.pkg.dev
DOCKER_ID ?=mchmarny
SIGN_KEY  ?=gcpkms://projects/cloudy-demos/locations/us-west1/keyRings/binauthz/cryptoKeys/vulnz-signer/cryptoKeyVersions/1

all: help

version: ## Prints the current version
	@echo $(VERSION)
.PHONY: version

tidy: ## Updates the go modules and vendors all dependancies 
	go mod tidy
	go mod vendor
.PHONY: tidy

upgrade: ## Upgrades all dependancies 
	go get -d -u ./...
	go mod tidy
	go mod vendor
.PHONY: upgrade

test: tidy ## Runs unit tests
	go test -short -count=1 -race -covermode=atomic -coverprofile=cover.out ./...
.PHONY: test

lint: ## Lints the entire project 
	golangci-lint -c .golangci.yaml run
.PHONY: lint

check: ## Static checks the entire project
	staticcheck ./...
.PHONY: check

run: ## Runs uncompiled app 
	go run main.go route.go
.PHONY: run

tag: ## Creates release tag 
	git tag -s -m "version bump to $(VERSION)" $(VERSION)
	git push origin $(VERSION)
.PHONY: tag

tagless: ## Delete the current release tag 
	git tag -d $(VERSION)
	git push --delete origin $(VERSION)
.PHONY: tagless

publish: ## Publishes image directly using ko
	KO_DOCKER_REPO=$(REGISTRY)/$(PROJECT)/hello/hello \
	GOFLAGS="-ldflags=-X=main.version=$(VERSION)" \
		ko build . --image-refs ./image-digest --bare --tags $(VERSION),latest
	COSIGN_EXPERIMENTAL=1 \
		cosign sign --force $(shell cat ./image-digest)
	# grype <image> --scope all-layers
.PHONY: publish

image: ## Build local image using Docker
	docker build --build-arg VERSION=${VERSION} -t $(DOCKER_ID)/hello:$(VERSION) .
	docker push $(DOCKER_ID)/hello:$(VERSION)
.PHONY: image

key: ## Build and publishes S3C tools
	cosign generate-key-pair --kms $(SIGN_KEY)
.PHONY: key

verify: ## Verify previously signed image
	cosign verify --key cosign.pub $(shell cat ./image-digest)
.PHONY: verify

clean: ## Cleans bin and temp directories
	go clean
	rm -fr ./vendor
	rm -fr ./bin
.PHONY: clean

help: ## Display available commands
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk \
		'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
.PHONY: help
