# Helm chart testing including install in Kind on a kubernetes deployment

This container provides a complete stack for 
* chart-testing lint
* chart-testing install

without any external dependancies. It should be possible to deploy this container in a kubernetes environment for testing 
within a CI/CD pipeline.

Thank you for the main work to https://github.com/jieyu with here article https://d2iq.com/blog/running-kind-inside-a-kubernetes-cluster-for-continuous-integration.
Here container is base image for this one.

And thank you for [chart-testing|https://github.com/helm/chart-testing].

## Status

Currently under development. Running on
* WSL2