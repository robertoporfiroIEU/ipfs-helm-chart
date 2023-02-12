#!/usr/bin/env python

config.define_bool("no-volumes")
cfg = config.parse()

clk_k8s = 'clk --force-color k8s -c ' + k8s_context() + ' '

if config.tilt_subcommand == 'up':
  # declare the host we'll be using locally in k8s dns
  local(clk_k8s + 'add-domain ipfs.localhost')

k8s_yaml(
    helm(
        'helm/ipfs',
        values=['./helm/ipfs/values-dev.yaml'],
        name='ipfs',
    )
)
k8s_resource('ipfs', port_forwards=['5001:5001'])
local_resource('helm lint',
               'docker run --rm -t -v $PWD:/app registry.gitlab.com/xdev-tech/build/helm:2.1' +
               ' lint helm/ipfs --values helm/ipfs/values-dev.yaml',
               'helm/ipfs/', allow_parallel=True)

if config.tilt_subcommand == 'down' and not cfg.get("no-volumes"):
  local(
      'kubectl --context ' + k8s_context()
      + ' delete pvc --selector=app.kubernetes.io/instance=ipfs --wait=false'
  )
