ENABLING DEBUG IN TERRAFORM
Documentation: [here](https://developer.hashicorp.com/terraform/internals/debugging)

Linux: export TF_LOG=TRACE

Windows: $env:TF_LOG="TRACE"

To store the debug output in a local file:

Linux: export TF_LOG_PATH="<path to file to save to>"

Windows: $env:TF_LOG_PATH="<path to file to save to>"

To disable logging:
Linux: export TF_LOG=""

Windows: $env:TF_LOG=""

Always turn it off when through, good for checking issues


