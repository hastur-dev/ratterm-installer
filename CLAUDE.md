# Project Instructions

## Excluded Tools (Do Not Add)

The following tools have been intentionally excluded from this installer project due to GitHub API rate limiting issues in CI. These tools use direct GitHub API calls which hit rate limits when run without authentication:

- **biome**
- **consul**
- **curlie**
- **doggo**
- **dprint**
- **git-cliff**
- **gum**
- **mdbook**
- **miniserve**
- **task**
- **ttyd**
- **turbo** (also times out in CI)
- **vhs**

Do not attempt to add install scripts for these tools unless you implement authenticated GitHub API calls.
