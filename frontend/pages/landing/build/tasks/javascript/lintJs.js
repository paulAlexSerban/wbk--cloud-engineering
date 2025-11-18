import { src, lastRun } from "gulp";
import eslint from "gulp-eslint";
import { paths } from "../../config/paths";
import plumber from "gulp-plumber";
// import debug from "gulp-debug";

// JavaScript Linting
export const lintJs = () => {
  return src(paths.src.js.jsFiles, { since: lastRun(lintJs) })
    .pipe(plumber())
    .pipe(eslint())
    // .pipe(debug({ title: "lintJs : ", minimal: false }))
    .pipe(
      eslint.results((results) => {
        console.log(`Total Results: ${results.length}`);
        console.log(`Total Warnings: ${results.warningCount}`);
        console.log(`Total Errors: ${results.errorCount}`);
      })
    )
    .pipe(eslint.format());
};
