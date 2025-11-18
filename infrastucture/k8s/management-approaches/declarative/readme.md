# Declarative Kubernetes
- we doe not know the state, we know the end result
- example: `kubectl apply -f deployment.yaml`
  - we do not know the current state
  - we only know what we want the end result to be (yaml contents)
- same command each time (with tiny exceptions for delete)
- resources can be all in a file, or many files (apply a who dir)
- requires understanding the YAML keys and values
- more work than `kubectl run` for just a starting pod
- the easiest way to automate Kubernetes
- this is the eventual path to GitOps happiness

## Using `kubectl apply`
- create/update resources from a file
  - `kubectl apply -f file.yaml`
- create/update resources from a directory
  - `kubectl apply -f dir/`
- create/update resources from a URL
  - `kubectl apply -f https://example.com/file.yaml`


## Kubernetes Configuration Files YAML
- YAML is a human readable data serialization format
- each file contains one or more manifests
- each manifest describes an API object (deployment, service, job, secret, etc)
- each manifest needs four parts (root key:value in the file):
  - `apiVersion: v1` or `apps/v1`
  - `kind: Deployment` or `Service`
  - `metadata:`
    - `name: my-deployment` or `my-service`
  - `spec:`

## Dry Run
- option that allows you what you are going to change before you change it

## Some other commands
`kubectl delete -f infrastructure/k8s/posts.yaml`
`kubectl apply -f infrastructure/k8s/posts.yaml`
`kubectl apply -f infrastructure/k8s/posts-depl.yaml`
`kubectl get pods`
`kubectl get deployments`
`kubectl exec -it POD_NAME -- sh`
`kubectl logs POD_NAME`
`kubectl delete pod POD_NAME`
`kubectl describe pod POD_NAME`
`kubectl describe deployment DEPLOYMENT_NAME`
`kubectl rollout restart deployment DEPLOYMENT_NAME`