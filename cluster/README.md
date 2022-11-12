# Local k8s cluster setup using kind 

Create cluster 

```shell
kind create cluster --name=dev --config=cluster/kind-config.yaml
```

Get context

```shell
kubectl config current-context
```

Check context

> change the kind cluster name if necessary 

```shell
kubectl cluster-info --context kind-dev
```

Set local dev in skaffold


```shell
skaffold config set --global local-cluster true
```

