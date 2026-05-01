# AGENTS.md

## Purpose
This repository is a Puppet control-repo-style homelab setup. Use this file for always-on guidance when editing manifests, templates, or hiera data.

## Quick Start
- Install module dependencies from the repo root: `r10k puppetfile install`
- For local apply tests, use the devcontainer helper from `.devcontainer/local-test/`: `./pa.sh test.pp`
- Local test reference: [.devcontainer/local-test/README](.devcontainer/local-test/README)

## Repository Map
- `manifests/site.pp`: node-to-role mapping (hostnames include one role)
- `site/role/manifests/*.pp`: role composition classes (mostly `include profile::...`)
- `site/profile/manifests/*.pp`: profile classes that wrap module usage and pull data from Hiera
- `site/openvpn/`, `site/telegram_bot/`: custom Puppet modules with manifests/templates
- `data/**/*.eyaml`: encrypted Hiera data (secrets and per-service config)
- `hiera.yaml`: eyaml hierarchy and key paths
- `Puppetfile`: pinned Forge module versions

## Conventions To Follow
- Keep role classes thin and compositional. Put service-specific logic in profiles or custom modules.
- Prefer typed parameters in classes/defines and pass explicit hashes to templates.
- Use EPP templates (`*.epp`) for rendered config content.
- Retrieve secrets/config via `lookup(...)` and values from eyaml-backed data.
- Preserve existing naming and namespace patterns:
  - roles: `role::<name>`
  - profiles: `profile::<name>`
  - custom module classes/defines: `<module>::<name>`

## Secrets And Data Safety
- Never hardcode credentials, keys, or tokens into manifests/templates.
- Keep sensitive values in `data/**/*.eyaml` and referenced through lookup keys.
- `hiera.yaml` expects eyaml keys at `/etc/puppetlabs/puppet/eyaml/`; do not change these paths unless requested.

## Change Checklist
- If adding a service to a host, update `manifests/site.pp` by adjusting role assignment.
- If adding behavior to a host type, prefer updating the corresponding role and profile classes.
- If introducing new config knobs, wire them through profile parameters and Hiera data.
- If adding module dependencies, pin them in `Puppetfile`.

## Pitfalls
- Missing eyaml key material prevents lookups from decrypting values.
- Direct edits to many host node blocks can cause drift; keep role boundaries clear.
- Keep module path assumptions intact (`site:modules:$basemodulepath` from `environment.conf`).

## Canonical References
- [.devcontainer/local-test/README](.devcontainer/local-test/README)
- [environment.conf](environment.conf)
- [hiera.yaml](hiera.yaml)
- [Puppetfile](Puppetfile)
- [manifests/site.pp](manifests/site.pp)
