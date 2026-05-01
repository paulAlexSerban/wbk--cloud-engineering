module.exports = {
  branches: "main",
  repositoryUrl: "https://github.com/paulAlexSerban/wbk--devops",
  plugins: [
    "@semantic-release/commit-analyzer",
    "@semantic-release/release-notes-generator",
    [
      "@semantic-release/npm",
      {
        npmPublish: false,
      },
    ],
    [
      "@semantic-release/github",
      { assets: [{ path: "build.zip", label: "Build" }] },
    ],
    ["@semantic-release/changelog", { changelogFile: "wiki/CHANGELOG.md" }],
    [
      "@semantic-release/git",
      {
        assets: ["wiki/CHANGELOG.md", "docs/**", "package.json"],
        message:
          "chore(release): version ${nextRelease.version} [skip ci]\n\n${nextRelease.notes}",
      },
    ],
  ],
};
