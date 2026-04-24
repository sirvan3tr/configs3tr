# Kubernetes / Helm productivity guide

A practical cheatsheet for working with Kubernetes from the terminal — the
commands, keybindings and workflows I actually use.

Install the bundle:

```bash
brew install kubernetes-cli helm helmfile kubectx k9s kind k3d tilt \
             stern kubecolor krew
helm plugin install https://github.com/databus23/helm-diff
```

`kubectx` ships both `kubectx` and `kubens`. Optional but recommended:

```bash
# kubectl plugin manager + the must-have plugins
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
kubectl krew install neat tree access-matrix who-can \
                     resource-capacity node-shell images df-pv outdated
```

---

## `.zshrc` additions

```zsh
# kubectl shortcuts
alias k=kubectl
alias kx=kubectx
alias kn=kubens

# Common kubectl verbs
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kgd='kubectl get deploy'
alias kgn='kubectl get nodes'
alias kga='kubectl get all'
alias kaf='kubectl apply -f'
alias kdel='kubectl delete'
alias kl='kubectl logs -f'
alias kex='kubectl exec -it'
alias kdp='kubectl describe pod'
alias kds='kubectl describe svc'

# Colored kubectl output (drop-in)
alias kubectl=kubecolor
compdef kubecolor=kubectl   # preserve completions

# krew plugin path
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Prefer nvim inside `kubectl edit`
export KUBE_EDITOR=nvim
```

Also enable the kubernetes module in `~/.config/starship.toml` so your prompt
always shows the current context/namespace — prevents `oh-no-I-was-in-prod`
moments:

```toml
[kubernetes]
disabled = false
format = '[$symbol$context( \($namespace\))]($style) '
symbol = '⎈ '
style = 'bold blue'
```

---

## kubectx & kubens — context and namespace switching

The single biggest kubectl-adjacent upgrade. Never type
`kubectl config use-context ...` again.

```bash
kubectx                 # interactive picker (fzf-powered if installed)
kubectx prod-eu         # switch cluster
kubectx -               # previous context
kubectx -d old-cluster  # delete a context
kubectx new=old-name    # rename

kubens                  # picker
kubens kube-system      # switch default namespace for current ctx
kubens -                # previous namespace
```

Rule of thumb: `kubectx` when you change **cluster**, `kubens` when you change
**namespace**. Your starship prompt shows both live.

---

## Core kubectl — the commands you'll live in

```bash
# Read the cluster
kubectl get pods                              # in current namespace
kubectl get pods -A                           # all namespaces
kubectl get pods -o wide                      # + node, IP
kubectl get pods -l app=api                   # by label
kubectl get pods --field-selector status.phase=Running
kubectl get pods --sort-by=.status.startTime
kubectl get events --sort-by=.lastTimestamp   # debugging first stop

# Describe (human-readable why-is-this-broken)
kubectl describe pod my-pod

# Logs
kubectl logs my-pod                           # one container
kubectl logs -f my-pod                        # follow
kubectl logs --previous my-pod                # crash loop: the dead one
kubectl logs -c sidecar my-pod                # specific container
kubectl logs -l app=api --tail=100 --all-containers  # label-scoped

# Exec
kubectl exec -it my-pod -- /bin/sh
kubectl exec -it my-pod -c sidecar -- bash
kubectl debug -it my-pod --image=busybox --target=app  # distroless!

# Port-forward
kubectl port-forward svc/api 8080:80          # local 8080 → service 80
kubectl port-forward deploy/api 8080

# Copy files
kubectl cp my-pod:/tmp/log.txt ./log.txt
kubectl cp ./fix.py my-pod:/app/fix.py

# Apply / delete
kubectl apply -f manifest.yaml
kubectl apply -k ./overlays/prod              # kustomize
kubectl delete -f manifest.yaml
kubectl delete pod my-pod --grace-period=0 --force  # stuck terminating

# Edit live (opens $KUBE_EDITOR)
kubectl edit deploy api
kubectl scale deploy api --replicas=5
kubectl rollout status deploy api
kubectl rollout undo deploy api
kubectl rollout history deploy api

# Explain (offline docs for any field!)
kubectl explain pod.spec.containers.resources
kubectl explain deployment --recursive | less

# Dry run — generate YAML without applying
kubectl create deploy nginx --image=nginx --dry-run=client -o yaml > deploy.yaml
kubectl run debug --image=busybox -it --rm -- sh  # throwaway pod
```

### Hidden-gem kubectl shortcuts

| Action | Command |
|---|---|
| Top of CPU/mem by pod | `kubectl top pod -A --sort-by=cpu` |
| Top by node | `kubectl top node` |
| API resources list | `kubectl api-resources` |
| API versions | `kubectl api-versions` |
| Who am I? | `kubectl auth whoami` |
| Can I do X? | `kubectl auth can-i delete pods` |
| Quick YAML of anything | `kubectl get deploy api -o yaml \| kubectl neat` |
| Tree of owner refs | `kubectl tree deploy api` (krew plugin) |
| Access matrix (RBAC) | `kubectl access-matrix` (krew plugin) |

---

## stern — multi-pod log tailing

`kubectl logs` dies at >1 replica. `stern` is the answer.

```bash
stern my-app                       # tail all pods matching "my-app"
stern -n prod api                  # specific namespace
stern -l app=api                   # label selector
stern --since 5m api               # last 5 minutes
stern --tail 50 api
stern -c sidecar api               # specific container
stern ".*"                         # everything in namespace
stern ".*" --exclude "health|readiness"
stern --include "ERROR|FATAL" api  # regex include

# Cross-cluster:
stern --context prod --namespace api '.*'
```

Colors per pod/container make concurrent logs from N replicas actually readable.

---

## k9s — the cluster TUI

Run `k9s` anywhere. This is where most of my kubectl work happens.

### Top-level keys

| Key | Action |
|---|---|
| `:` | command mode (type a resource, e.g. `:pods`, `:deploy`, `:svc`) |
| `/` | filter current view |
| `?` | help for current view |
| `Esc` | back |
| `:q` or `Ctrl-c` | quit |
| `Space` | mark/select (for bulk ops) |
| `0`–`9` | filter by namespace (saved in profile) |
| `Ctrl-a` | list all aliases |

### On a pod

| Key | Action |
|---|---|
| `Enter` | drill into containers |
| `l` | logs |
| `Shift-l` | previous container logs |
| `s` | shell into container |
| `d` | describe |
| `y` | view YAML |
| `e` | edit |
| `Ctrl-d` | delete |
| `Ctrl-k` | kill (force) |
| `f` | port-forward |
| `o` | show image(s) |
| `z` | sanitize (see unused fields) |

### Useful resource shortcuts (`:` mode)

```
:pods         :po
:deployments  :deploy
:services     :svc
:ingresses    :ing
:configmaps   :cm
:secrets      :sec
:events       :ev           # goto first when something is wrong
:pulses       :pu           # live cluster dashboard
:xray deploy                # dependency tree for deployments
:popeye                     # cluster sanity check
:helm                       # helm releases in-cluster
```

### `xray` is underrated

```
:xray deploy
```
Gives you a live tree: deployment → replicaset → pods → containers.
Navigate the tree to see which layer is broken.

### Custom aliases

`~/.config/k9s/aliases.yaml`:
```yaml
aliases:
  dp: deployments
  sec: v1/secrets
  jo: batch/v1/jobs
```

### Read-only mode for prod

`~/.config/k9s/config.yaml`:
```yaml
k9s:
  readOnly: true    # per cluster override recommended
```

Or run once: `k9s --readonly --context prod`.

---

## helm — core workflow

```bash
# Repos
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm search repo nginx
helm search hub wordpress

# Install / upgrade / uninstall
helm install my-app ./chart -f values.yaml
helm upgrade --install my-app ./chart -f values.yaml   # idempotent
helm upgrade my-app ./chart --set image.tag=v2.0.0
helm uninstall my-app

# List + inspect
helm list -A
helm status my-app
helm get values my-app           # user-supplied values
helm get values my-app --all     # merged with defaults
helm get manifest my-app         # what actually got applied
helm get notes my-app            # post-install notes
helm history my-app
helm rollback my-app 3

# Templating (dry-run, no cluster needed)
helm template my-app ./chart -f values.yaml > rendered.yaml
helm template my-app ./chart -f values.yaml | kubectl apply --dry-run=server -f -

# Lint / package
helm lint ./chart
helm package ./chart
```

### helm-diff — the upgrade safety net

```bash
helm plugin install https://github.com/databus23/helm-diff
helm diff upgrade my-app ./chart -f values.yaml
```

Always run `helm diff upgrade` before `helm upgrade`. It shows the exact
Kubernetes manifest delta — no surprises.

---

## helmfile — declarative Helm

One file describes the desired state of every release in a cluster. One
command applies it.

```yaml
# helmfile.yaml
repositories:
  - name: ingress-nginx
    url: https://kubernetes.github.io/ingress-nginx
  - name: jetstack
    url: https://charts.jetstack.io

releases:
  - name: ingress-nginx
    namespace: ingress
    chart: ingress-nginx/ingress-nginx
    version: 4.10.0
    values:
      - values/ingress-nginx.yaml

  - name: cert-manager
    namespace: cert-manager
    chart: jetstack/cert-manager
    version: v1.14.0
    set:
      - name: installCRDs
        value: true

  - name: my-app
    namespace: default
    chart: ./charts/my-app
    values:
      - values/my-app.{{ .Environment.Name }}.yaml
```

### Commands

```bash
helmfile deps                     # resolve chart deps
helmfile lint                     # lint all charts
helmfile template                 # render everything locally
helmfile diff                     # preview full cluster delta
helmfile sync                     # apply everything
helmfile apply                    # diff first, sync only if changed (recommended)
helmfile destroy                  # uninstall all releases
helmfile -e prod sync             # use environment `prod`
helmfile -l name=my-app sync      # just one release
```

Rule of thumb: **never run `helm upgrade` by hand in a real cluster**. Put it
in `helmfile.yaml`, commit it, and use `helmfile apply`. That's your source of
truth.

### Environments

```yaml
environments:
  default:
    values:
      - values/default.yaml
  prod:
    values:
      - values/prod.yaml
---
releases:
  - name: my-app
    chart: ./charts/my-app
    values:
      - values/my-app.{{ .Environment.Name }}.yaml
```

Then `helmfile -e prod apply`.

---

## Local clusters — kind, k3d, tilt

### When to use which

| Tool | Use for |
|---|---|
| **k3d** | Day-to-day dev clusters, fastest startup, k3s-based (some differences from upstream) |
| **kind** | CI, testing, "is this a real k8s problem?" — upstream Kubernetes |
| **tilt** | Inner dev loop — live-reload your app into a cluster on every save |

### k3d quick recipes

```bash
k3d cluster create dev --agents 2 -p "8080:80@loadbalancer"
k3d cluster list
k3d cluster stop dev
k3d cluster delete dev

# Image → cluster without a registry
k3d image import my-app:dev -c dev
```

### kind quick recipes

```bash
kind create cluster --name test
kind create cluster --config kind-config.yaml
kind delete cluster --name test
kind load docker-image my-app:dev --name test    # push local image in
```

### tilt — the inner dev loop

```bash
tilt up      # start (opens web UI at :10350)
tilt down    # stop + tear down resources
```

Minimal `Tiltfile`:

```python
docker_build('my-app', '.', live_update=[
    sync('./src', '/app/src'),
    run('pip install -r requirements.txt', trigger='requirements.txt'),
])

k8s_yaml(helm('./chart', name='my-app', values=['values.dev.yaml']))
k8s_resource('my-app', port_forwards='8080:8080')
```

Key ideas:
- `docker_build` with `live_update` syncs changed files into running containers (no rebuild).
- `helm(...)` renders the chart in place; `k8s_yaml(...)` applies it.
- `k8s_resource` adds port-forwarding, readiness gates, dependencies.
- Browse https://github.com/tilt-dev/tilt-extensions for pre-built patterns.

The Tilt web UI shows per-service build/deploy/log status in one place — way
better than `kubectl logs` juggling during active development.

---

## Debugging playbook

The ordered list I run through when something's wrong.

### 1. Where am I?

```bash
kubectx                            # confirm cluster
kubens                             # confirm namespace
```

Or glance at the starship prompt.

### 2. What's broken?

```bash
k9s                                # open, look for red rows
# or
kubectl get pods -A | rg -v Running
kubectl get events -A --sort-by=.lastTimestamp | tail -30
```

### 3. Pod not coming up?

```bash
kubectl describe pod my-pod        # Events section at the bottom
kubectl logs my-pod --previous     # last crash output
```

Common things the Events section reveals:
- `ImagePullBackOff` — bad tag / private registry auth
- `CrashLoopBackOff` — read `logs --previous`
- `Pending` + no node events — resources; run `kubectl top node`
- `FailedScheduling` — tolerations/affinity/taints

### 4. App running but not reachable?

```bash
kubectl get svc,endpoints          # are endpoints empty? selector mismatch
kubectl get ingress
kubectl port-forward svc/api 8080  # bypass ingress to test pod
```

If endpoints are empty: your service selector doesn't match pod labels.

### 5. Need to see traffic?

```bash
kubeshark tap                      # Wireshark-style traffic capture UI
```

### 6. Storage weird?

```bash
kubectl get pvc,pv
kubectl df-pv                      # krew plugin: actual disk usage
```

### 7. Who can do what? (RBAC)

```bash
kubectl auth can-i delete pods --as system:serviceaccount:default:my-sa
kubectl access-matrix --sa default:my-sa     # krew plugin
kubectl who-can delete pods                  # krew plugin
```

---

## Productivity patterns

### Fuzzy-pick any resource with fzf

```bash
# pick a pod, tail its logs
kubectl get pods | fzf | awk '{print $1}' | xargs -I{} kubectl logs -f {}

# pick a context
kubectx "$(kubectl config get-contexts -o name | fzf)"
```

### Scoped namespace for one command

```bash
kubectl -n kube-system get pods        # without switching default
```

### Watch a resource change live

```bash
kubectl get pods -w
kubectl get pods -w -o wide
watch -n 1 kubectl get pods            # screen refresh instead
viddy -n 1 kubectl get pods            # watch with diff highlighting
```

### Throwaway debug pods

```bash
# curl / dig / wget from inside the cluster
kubectl run dbg --image=nicolaka/netshoot -it --rm -- bash

# ephemeral debug container attached to an existing pod (distroless-safe)
kubectl debug -it my-pod --image=busybox --target=my-container
```

### Bulk operations with labels

```bash
kubectl delete pod -l app=api
kubectl label pods -l app=api version=v2 --overwrite
```

### Copy-edit-apply YAML

```bash
kubectl get deploy api -o yaml | kubectl neat > api.yaml
# edit...
kubectl apply -f api.yaml
```

`kubectl neat` (krew plugin) strips generated/managed fields so the YAML is
actually human-readable and safe to re-apply.

---

## Cheatsheet

| Task | Command |
|---|---|
| Switch cluster | `kubectx` / `kubectx -` |
| Switch namespace | `kubens` / `kubens -` |
| Cluster TUI | `k9s` |
| Multi-pod logs | `stern my-app` |
| Previous container logs | `kubectl logs --previous my-pod` |
| Shell into distroless | `kubectl debug -it my-pod --image=busybox --target=app` |
| Port-forward service | `kubectl port-forward svc/api 8080:80` |
| Top CPU across cluster | `kubectl top pod -A --sort-by=cpu` |
| Preview Helm upgrade | `helm diff upgrade my-app ./chart -f v.yaml` |
| Apply full cluster state | `helmfile apply` |
| Render Helm locally | `helm template my-app ./chart -f v.yaml` |
| Clean YAML | `kubectl get <x> -o yaml \| kubectl neat` |
| Explain any field | `kubectl explain <kind>.spec.x.y` |
| Who can do X? | `kubectl auth can-i <verb> <resource>` |
| Dev loop with live-reload | `tilt up` |
| Local throwaway cluster | `k3d cluster create dev` |
