# TFLint config, used by the tflint job in .github/workflows/check.yml.
# The terraform ruleset ships inside TFLint, so `tflint --init` has nothing
# to download until another plugin is added here.
plugin "terraform" {
  enabled = true
  preset  = "recommended"
}
