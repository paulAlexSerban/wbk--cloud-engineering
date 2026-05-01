import { src, lastRun } from "gulp";
import lint from "gulp-htmllint";
import { paths } from "../../config/paths";
import {red, cyan, white} from "ansi-colors";
import plumber from "gulp-plumber";
// import debug from "gulp-debug";

export const lintHtml = () => {
  return src(paths.src.html.htmlFiles, { since: lastRun(lintHtml) })
    .pipe(plumber())
    // .pipe(debug({ title: "htmlLint" , minimal: false }))
    .pipe(lint({}, htmlLintReporter));
};

function htmlLintReporter(filepath, issues) {
  if (issues.length > 0) {
    issues.forEach(function (issue) {
      console.log(cyan(" [ HTML Lint ] "), red(`(${issue.code}) ${issue.msg}`));
      console.log(white(`${filepath} [${issue.line},${issue.column}]`));
    });
    process.exitCode = 1;
  }
}
