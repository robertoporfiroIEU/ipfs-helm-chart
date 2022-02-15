helm charts for ipfs

# Usage

## From command line

~~~bash
helm repo add ipfs https://gitlab.com/api/v4/projects/31977935/packages/helm/dev
helm search repo ipfs --devel
helm install ipfs/ipfs ipfs
~~~

## As a dependency in your `Chart.yaml`

~~~yaml
dependencies:
  - name: ipfs
    version: "0.1.0-develop"
    repository: oci://registry.gitlab.com/xdev-tech/xdev-enterprise-business-network/ipfs/helm
~~~

# Development

```
tilt up
```

ipfs gateawy is available on https://ipfs.localhost

```
tilt down
```
