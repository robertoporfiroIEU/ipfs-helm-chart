helm charts for ipfs

# Usage

## From command line

~~~bash
helm install oci://ghcr.io/eniblock/ipfs --version 0.1.0
~~~

## As a dependency in your `Chart.yaml`

~~~yaml
dependencies:
  - name: ipfs
    repository: oci://ghcr.io/eniblock/ipfs
    version: "0.1.0"
~~~

# Development

```
tilt up
```

ipfs gateawy is available on https://ipfs.localhost

```
tilt down
```
