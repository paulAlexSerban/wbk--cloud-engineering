# Conventional Commits 1.0.0

## Commit message structure

```
  <type>[optional scope]: <description>
  [optional body]
  [optional footer(s)]
```

The commit contains the following structural elements, to communicate intent to the consumers of your library:

- `fix:` a commit of the type fix patches a bug in your codebase (this correlates with **PATCH** in Semantic Versioning).
- `feat:` a commit of the type feat introduces a new feature to the codebase (this correlates with **MINOR** in Semantic Versioning).
- `BREAKING CHANGE:` a commit that has a footer `BREAKING CHANGE:`, or appends a `!` after the type/scope, introduces a breaking API change (correlating with **MAJOR** in Semantic Versioning).
  - A BREAKING CHANGE can be part of commits of any type.
- types other than `fix:` and `feat:` are allowed, for example @commitlint/config-conventional (based on the the Angular convention) recommends `build:`, `chore:`, `ci:`, `docs:`, `style:`, `refactor:`, `perf:`, `test:`, and others.
- footers other than `BREAKING CHANGE: <description>` may be provided and follow a convention similar to git trailer format.

## Type

Must be one of the following:

- `build:` Changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)
- `ci:` Changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)
- `docs:` Documentation only changes
- `feat:` A new feature
- `fix:` A bug fix
- `perf:` A code change that improves performance
- `refactor:` A code change that neither fixes a bug nor adds a feature
- `style:` Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- `test:` Adding missing tests or correcting existing tests

## Scope

The scope should be the name of the npm package affected (as perceived by the person reading the changelog generated from commit messages.

The following is the list of supported scopes:
animations, common, compiler, compiler-cli, core, elements, forms, http, language-service, platform-browser, platform-browser-dynamic, platform-server, platform-webworker, platform-webworker-dynamic, router, service-worker, upgrade

## Examples

> Commit message with ! to draw attention to breaking change

- `feat!: send an email to the customer when a product is shipped`

> Commit message with scope and ! to draw attention to breaking change

- `feat(api)!: send an email to the customer when a product is shipped`

> Commit message with no body

- `docs: correct spelling of CHANGELOG`

> Commit message with scope

- `feat(lang): add Polish language`

## Specification

The key words “MUST”, “MUST NOT”, “REQUIRED”, “SHALL”, “SHALL NOT”, “SHOULD”, “SHOULD NOT”, “RECOMMENDED”, “MAY”, and “OPTIONAL” in this document are to be interpreted as described in RFC 2119.

- Commits **MUST** be prefixed with a type, which consists of a noun, `feat`, `fix`, etc., followed by the _OPTIONAL_ `(scope)`, (OPTIONAL) `!`, and **REQUIRED** terminal colon `:` and space.
- The type `feat` **MUST** be used when a commit adds a new feature to your application or library.
- The type `fix` MUST be used when a commit represents a bug fix for your application.
- A `(scope)` _MAY_ be provided after a type. A `(scope)` _MUST_ consist of a noun describing a section of the codebase surrounded by parenthesis, e.g., `fix(parser):`
- A description _MUST_ immediately follow the colon and space after the type/`(scope)` prefix. The description is a short summary of the code changes, e.g., `fix: array parsing issue when multiple spaces were contained in string.`
- A longer commit body _MAY_ be provided after the short description, providing additional contextual information about the code changes. The body _MUST_ begin one blank line after the description.
- A commit body is free-form and _MAY_ consist of any number of newline separated paragraphs.
- One or more footers _MAY_ be provided one blank line after the body. Each footer _MUST_ consist of a word token, followed by either a `:`<space> or <space>`#` separator, followed by a string value (this is inspired by the git trailer convention).
- A footer’s token _MUST_ use - in place of whitespace characters, e.g., Acked-by (this helps differentiate the footer section from a multi-paragraph body). An exception is made for `BREAKING CHANGE`, which _MAY_ also be used as a token.
- A footer’s value _MAY_ contain spaces and newlines, and parsing _MUST_ terminate when the next valid footer token/separator pair is observed.
- Breaking changes _MUST_ be indicated in the type/`(scope)` prefix of a commit, or as an entry in the footer.
- If included as a footer, a breaking change _MUST_ consist of the uppercase text BREAKING CHANGE, followed by a colon, space, and description, `e.g., BREAKING CHANGE: environment variables now take precedence over config files`.
- If included in the type/`(scope)` prefix, breaking changes _MUST_ be indicated by a `!` immediately before the `:`. If `!` is used, `BREAKING CHANGE:` _MAY_ be omitted from the footer section, and the commit description SHALL be used to describe the breaking change.
- Types other than feat and fix _MAY_ be used in your commit messages, e.g., `docs: updated ref docs`.
- The units of information that make up Conventional Commits _MUST_ NOT be treated as case sensitive by implementors, with the exception of BREAKING CHANGE which _MUST_ be uppercase.
- `BREAKING-CHANGE` _MUST_ be synonymous with `BREAKING CHANGE`, when used as a token in a footer.

## Why Use Conventional Commits

Automatically generating CHANGELOGs.
Automatically determining a semantic version bump (based on the types of commits landed).
Communicating the nature of changes to teammates, the public, and other stakeholders.
Triggering build and publish processes.
Making it easier for people to contribute to your projects, by allowing them to explore a more structured commit history.

## References

- https://www.conventionalcommits.org/en/v1.0.0/
- https://github.com/angular/angular/blob/22b96b9/CONTRIBUTING.md#-commit-message-guidelines