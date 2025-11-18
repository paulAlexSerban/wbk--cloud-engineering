# Kubernetes (K8s)

## What is Kubernetes?
- system for running many different containers over multiple different machines

## Why use Kubernetes?
- when you need to run many different containers with different images    kubectl get pods

## The Three Management Approaches
- Imperative commands: `run`, `expose`, `scale`, `edit`, `create deployment`, `create service`
  - best for dev/learning/personal projects
  - easy to learn, hardest to manage over time
- Imperative objects: `create -f file.yml`, `replace -f file.yml`, `delete -f file.yml`
  - good for prod of small environments, single file per command
  - store your changes in git based  yaml files
  - hard to automate
- Declarative objects: `apply -f file.yml`, `delete -f file.yml`
  - best for prod, large environments
  - harder to understand and predict changes
  - store your changes in git based yaml files
  - easy to automate

Most important rules:
- do not mix the three approaches

Recommendations:
- learn the imperative CL for easy control of local and test setups
- move to `apply -f file.yml` and `apply -f dir/` for prod and large environments
- store yaml in git, git commit change before you apply
- this will train you for later GitOps (where git commits are automatically applied to clusters)