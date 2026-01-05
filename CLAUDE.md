# Project Instructions

## Excluded Tools (Do Not Add)

The following tools have been intentionally excluded from this installer project due to GitHub API rate limiting issues in CI. These tools use direct GitHub API calls which hit rate limits when run without authentication:

### Windows
- biome, consul, curlie, doggo, dprint, git-cliff, gum, mdbook, miniserve, task, ttyd, turbo, vhs

### Linux
- actionlint, bandwhich, croc, ctop, curlie, difftastic, dive, dog, git-cliff, gitleaks, gping, grex, gum, helix, k9s, mcfly, mdbook, miniserve, mkcert, navi, nushell, pastel, restic, sd, shfmt, sops, stern, typos, vegeta, vhs, xh, yq, zellij

Do not attempt to add install scripts for these tools unless you implement authenticated GitHub API calls.
