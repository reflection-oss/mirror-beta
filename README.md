# Mirror CLI (beta)

Mirror is Reflection's agent harness. Explore your codebase, edit files, run
commands and tests, and work on tasks in separate worktrees.

This repository hosts beta releases and feedback, not source code. Expect rough edges.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/reflection-oss/mirror-beta/main/install.sh | bash
```

Available for **macOS 15+ on Apple Silicon** and **Linux on x86-64 or ARM64 with glibc 2.28+**. The installer verifies
and installs the pinned beta wheel, setting up [uv](https://docs.astral.sh/uv/) and
Python if needed. Restart your shell if `mirror` isn't found.

Wheels and `SHA256SUMS` are also available in the
[0.1.0 release](https://github.com/reflection-oss/mirror-beta/releases/tag/v0.1.0).
Run the installer again to update to this build.

## Get started

Launch Mirror in your project and follow the onboarding prompts to get started
with Beam:

```bash
cd /path/to/your/project
mirror
```

Ask something like: “Explain this project and how to run its tests.”

Type `/` to browse commands: `/model` to switch models, `/new` or `/resume` for
conversations, and `/worktree` for an independent task. Run `mirror --continue`
to pick up where you left off, or `mirror --help` for options and other providers.

## Documentation

Read the [Mirror CLI reference](https://developers.reflection.ai/mirror-cli-reference) for more details.

## Web search

In preview, Mirror supports the Firecrawl API for search. We'll support additional
search providers by launch.

To enable web search and browsing, [create a Firecrawl API key](https://www.firecrawl.dev/app/api-keys)
and export it before starting Mirror:

```bash
export FIRECRAWL_API_KEY="your-api-key"
mirror
```

## macOS tip

For better compatibility with common shell commands, we recommend installing
GNU coreutils with [Homebrew](https://brew.sh/):

```bash
brew install coreutils
```

## Feedback

Run `/feedback` in Mirror or [open a report](https://github.com/reflection-oss/mirror-beta/issues).
Review it for private code, credentials, and other sensitive information before submitting.
