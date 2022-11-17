# hellow

Demo app in go

## Local Dev Using Skaffold

> Assumes the `kind` cluster is already set up. (`cluster/cluster-up`)

Make sure the `kubectl` context is set to the local cluster.

`kubectx`

If not, set it.

`kubectx kind-dev`

Launch `skaffold` in dev mode.

`skaffold dev --cache-artifacts=false`

Code changes will result in new image build and deploy. You can also run it using profiles.

`skaffold run --profile prod --tail`

To output the configuration (either `helm`, `kpt`, or `kustomize`).

> local image cause the kind cluster configured for local Docker registry

`skaffold render` or `o demo.yaml`

You can apply `demo.yaml` using `skaffold apply demo.yaml` or `kubectl`.

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