---
status: proposed
decision-makers: Technical Architect, approved by the Security and Platform Owner
group: Where tests run
---

# How CI runs container tests for each kind of CI platform

**Decided by:** Technical Architect, approved by the Security and Platform Owner · **Status:** proposed

## Context and Problem Statement

Container tests need somewhere to run their containers. CI platforms differ: hosted runners on virtual machines usually have Docker; platforms built on Kubernetes (for example OpenShift or Tekton) usually have no Docker daemon in their build pods. Image build tools such as Buildah or Kaniko build images; they don't run the containers tests need. The organisation profile records the CI platform as a fact; the remaining choice is how test containers run on it.

## Considered Options

* **Docker is available on the runner: use Testcontainers directly**  
  Simplest; usual on virtual-machine runners
* **Kubernetes-based CI: kubedock, which runs each test container as a pod**  
  No daemon needed in the build pod; needs permission to create pods
* **Kubernetes-based CI: rootless Podman inside the build pod, with its Docker-compatible socket**  
  Self-contained; needs platform and security approval for the pod's settings
* **A separate container host the runners connect to (on the network that can't reach production)**  
  Works anywhere; needs capacity and network rules
* **A paid hosted container service**  
  Least to run; cost, and data may leave the organisation's network
* **None: fakes only**  
  Weak evidence that data access works

## Decision Outcome

Proposed: as a guide, choose by CI platform: Docker where it exists; otherwise kubedock or rootless Podman, decided in the organisation's own decision record and noted in its profile under `ci.container_runtime_for_tests`.

### Consequences

* The convention plugin reads the runtime from the environment, so repos don't change when the choice does.
* The Testcontainers lesson shows both a Docker and a Kubernetes-based set-up.

## More Information

* Builds on: [Old code runs first only where production cannot be reached](0019-old-code-runs-first-only-where-production-cannot-be-reached.md), [Tests are split by what they need: local tests and container tests](0029-tests-are-split-by-what-they-need-local-tests-and-container-tests.md)
* Later decisions that build on this: [How developers see container test results while their machines cannot run containers](0032-how-developers-see-container-test-results-while-their-machines-cannot-run-containers.md)
* Background: none
