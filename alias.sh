# commands.sh

# List all pods in the current namespace
alias klp='kubectl get pods'

# List all services in the current namespace
alias kls='kubectl get services'

# Describe a pod
alias kdp='kubectl describe pod'

# Get logs from a pod
alias klog='kubectl logs'

# Apply a YAML file
alias kapply='kubectl apply -f'

# Delete a resource by label
alias kdelete='kubectl delete --selector'

# Port-forwarding for a pod
alias kpf='kubectl port-forward'

# Get nodes
alias kgn='kubectl get nodes'

# Get all resources in a namespace
alias kga='kubectl get all'

# Switch context to a different cluster
alias kctx='kubectl config use-context'
