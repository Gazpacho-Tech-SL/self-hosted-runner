# ARC Self-Hosted Runners

This repository contains configurations for deploying self-hosted runners in Kubernetes environments. 

For more information : https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller/quickstart-for-actions-runner-controller
Using github app for authentication: https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller/authenticating-to-the-github-api

## Custom Runner Image

Two Dockerfiles are provided to build custom runner images:

- **[Helm, Amazon Corretto, Terraform, and AWS CLI](./custom-github-actions-runner)**: This Docker image integrates multiple tools including Helm for Kubernetes package management, Amazon Corretto (a no-cost, multi-platform distribution of OpenJDK), Terraform for managing cloud infrastructure through code, and the AWS CLI for interacting with Amazon Web Services.

## GitHub Actions Workflow: [`deploy-all-runners.yaml`](./.github/workflows/deploy-all-runners.yaml)

This workflow automates the deployment of an Actions Runner Controller to a DevOps EKS Cluster. It triggers on pushes to the `main` branch and can also be manually initiated via the `workflow_dispatch` event.

### Prerequisites

Ensure the following GitHub secrets are configured:
- `KUBE_CONFIG_CLUSTER`
- `GITHUB_PAT_TOKEN`

## Workflow Steps:

1. **Checkout Code**: Retrieves your repository's contents to make them available for the workflow.

2. **Configure Kubeconfig**: Sets up the kubeconfig file used to interact with the Kubernetes cluster. The kubeconfig is derived from a base64-encoded secret stored in your GitHub repository.

3. **Deploy ARC Helm Chart**: Installs the Actions Runner Controller Helm chart in the `kube-system` namespace of the Kubernetes cluster. The chart can be found at `oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller`, and the configuration values are defined in [`./arc-controller/arc-controller-values.yaml`](./arc-controller/arc-controller-values.yaml).

4. **Deploy All ScaleSet Helm Charts**: Deploys Helm charts for all scalesets. This step iterates over YAML files located in [`./arc-scalesets/`](./arc-scalesets/), applies environment variables, and deploys each chart to the `runners` namespace. The chart is located at `oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set`.

## Configuration:

- **KUBE_CONFIG_CLUSTER**: This secret should contain the base64-encoded kubeconfig file for the DevOps EKS Cluster.

- **GITHUB_PAT_TOKEN**: This secret should hold your GitHub Personal Access Token (PAT), used for authenticating with GitHub during scaleset deployments.

## Modifying the Workflow:

To adjust the workflow, edit the [`deploy-all-runners.yaml`](./.github/workflows/deploy-all-runners.yaml) file in your repository.

- **Adding Scalesets**: To include a new scaleset, add a YAML configuration file to the [`./arc-scalesets/`](./arc-scalesets/) directory.

- **Removing Scalesets**: To delete a scaleset, uninstall it from the Kubernetes cluster using `helm uninstall [RELEASE_NAME]`, replacing `[RELEASE_NAME]` with the scaleset’s Helm release name. Remove the corresponding YAML file from the [`./arc-scalesets/`](./arc-scalesets/) directory to prevent future deployments.

- **Changing the Helm Chart**: To use a different Helm chart, update the URLs `oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller` and `oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set` to point to the new chart's location.

- **Changing the Namespace**: To deploy to a different namespace, modify the `--namespace runners` option to your desired namespace. Ensure the namespace exists in your Kubernetes cluster.

Always validate your modifications in a staging environment before deploying to production.

## Utilizing Self-Hosted Runners in GitHub Actions Workflows

After setting up your self-hosted runners, you can specify them in any GitHub Actions workflow using the appropriate `runs-on` labels. These labels should correspond to those configured for your self-hosted runners. For example:

```yaml
jobs:
  run-a-script:
    runs-on: <repo-name-runner>

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v3

      - name: Execute a Script
        run: | 
          echo "Hello from a self-hosted runner within the runners namespace!"
```
