# Project Instructions

## Excluded Tools (Do Not Add)

The following tools have been intentionally excluded from this installer project due to GitHub API rate limiting issues in CI:

- **biome** - Requires GitHub API calls that hit rate limits
- **curlie** - Requires GitHub API calls that hit rate limits
- **turbo** - Installation times out in CI (chocolatey package issues)

Do not attempt to add install scripts for these tools.
