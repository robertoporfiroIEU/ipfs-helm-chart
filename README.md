A Helm chart for deploying a private IPFS cluster on Kubernetes

# Usage

## From command line

~~~bash
  helm upgrade --install ipfs-cluster ./helm/ipfs/ --create-namespace --namespace ipfs --values helm/ipfs/values.yaml
~~~
