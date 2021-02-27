# Helm chart testing including install in Kind on a kubernetes deployment

This container provides a complete stack for 
* chart-testing lint
* chart-testing install

without any external dependancies. It should be possible to deploy this container in a kubernetes environment for testing 
within a CI/CD pipeline.

Thank you for the main work to [Jie Yu](https://github.com/jieyu) with her great [article](https://d2iq.com/blog/running-kind-inside-a-kubernetes-cluster-for-continuous-integration).
Here container is base image for this one.

This container is also using [chart-testing](https://github.com/helm/chart-testing).

## Running

* mount helm-charts directory (collection of one to multiple charts) into docker

run for example
```
docker run -v ${PWD}:/data --privileged tgruenert/helm-ct-kind:0.1 ct lint-and-install
```

See current tags at https://hub.docker.com/repository/docker/tgruenert/helm-ct-kind/general.

## TODO
- test on kubernetes

### done
- start kind only if needed
- handle directories (kind config path)

## Status

Currently under development. Running on
* WSL2
