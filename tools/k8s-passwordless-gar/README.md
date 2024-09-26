`k8s-passwordless-gar` is a Kubernetes CronJob that refreshes short lived access token for passwordless authentication to Google Artifact Registry when pulling custom workload images from a private container repository in Google Artifact Registry.

## Overview

`k8s-passwordless-gar` runs once per namespace (the traditional security boundary per Kubernetes secret / tenant). `Admin SA` is a GCP service account with permissions to create/manage secrets in a GCP project.

![overview of end to end process using `k8s-passwordless-gar` for passwordless authentication to Google Artifact Registry](pics/diagram.png)

1. 

## Out of scope

1. This example doesn't include node-wide, e.g. static pod based configuration for fetching the `k8s-passwordless-gar` image from the private repository itself.


## Known limitations / Security considerations

- The `k8s-passwordless-gar` image itself could be hosted in a private container registry. Additional mechanisms to support authentication to that registry are required.

## Prerequisites

- A CNCF compliant Kubernetes cluster not necessarily running on Google Cloud or any other hyperscaler or managed Kubernetes service provider

- Google Project with billing enabled & owner access
  - with enabled Workload Identity API (`gcloud services enable secretmanager.googleapis.com`)

## Quick start (using go) outside of GKE


## TODO:
- 

## Disclaimer

This is not an official Google project.

## Thanks

