# hellow

Demo app in go

## Local Dev Using Skaffold

> Assumes the `kind` cluster is already set up. (`cluster/cluster-up`)

Make sure the `kubectl` context is set to the local cluster

`kubectx`

If not, set it

`kubectx kind-dev`

Launch `skaffold` in dev mode

`skaffold dev`

Code changes will result in new image build and deploy

## Local Dev Using Makefile 

* Test: `make test`
* Lint: `make lint`
* Run un-compiled code: `make run`
* Image using Docker: `make iamge`
* Image using ko and sign image using cosign: `make publish`

For more commands run `make`

## Cloud Deploy

To setup Cloud Build trigger with Cloud Deploy pipeline for GKE cluster see [cloudbuild-demo](https://github.com/mchmarny/cloudbuild-demo).

## Disclaimer

This is my personal project and it does not represent my employer. While I do my best to ensure that everything works, I take no responsibility for issues caused by this code.