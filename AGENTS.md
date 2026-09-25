# AGENTS.md

## Reusable configuration modules

- Keep reusable modules free of deployment-specific details that may differ
  between hosts, networks, or setups.
- Declare such values through configuration options and supply concrete values
  in host/setup configuration. This includes IP addresses, network ranges,
  local domains, DNS server choices, and other environment-specific settings.
- Reuse existing configuration values instead of duplicating them. Only add new
  configuration values when neccessary