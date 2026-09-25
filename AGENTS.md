# AGENTS.md

## Reusable configuration modules

- Keep reusable modules free of deployment-specific details that may differ
  between hosts, networks, or setups.
- Declare such values through configuration options and supply concrete values
  in host/setup configuration. This includes IP addresses, network ranges,
  local domains, DNS server choices, and other environment-specific settings.
- Reuse existing configuration values instead of duplicating them. Only add new
  configuration values when neccessary

## Simplicity and readability

- Prefer simple readable implementations that satisfy the current requirements 
  and supported configurations.
- Use direct access to existing configuration values and simple built-in helpers
  instead of deeply nested transformations or unnecessary abstractions.
- When complex processing is necessary, ask the user about it.
- Add special cases, fallbacks, and compatibility logic only for concrete needs
  in supported setups, not for hypothetical configurations.

## README scope

- Keep the root README focused on a high-level overview of the project.
- Do not add detailed documentation for individual hosts or services, such as
  service URLs, configuration options, certificate setup, or operational checks.
- Before updating the README, consider whether the information is needed to
  understand the project as a whole. Do not document every implementation change
  there.
