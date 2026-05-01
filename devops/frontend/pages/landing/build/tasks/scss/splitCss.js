import { src, dest, lastRun } from "gulp";
import { paths } from "../../config/paths";
import debug from "gulp-debug";
import plumber from "gulp-plumber";
import postcss from "gulp-postcss";
import criticalSplit from "postcss-critical-split";
import rename from "gulp-rename";
import stripComments from "gulp-strip-css-comments";

export const cssCriticalSplit = () => {
  return src(paths.src.css.cssEntries, { since: lastRun(cssCriticalSplit) })
    .pipe(plumber())
    .pipe(
      postcss([
        criticalSplit({
          startTag: "critical:start",
          endTag: "critical:end",
          output: "critical",
        }),
      ])
    )
    .pipe(
      rename((file) => {
        file.basename = `${file.basename}.critical`;
        file.dirname = `styles/.tmp/split`;
      })
    )
    .pipe(stripComments())
    .pipe(debug({ title: "cssCriticalSplit : " }))
    .pipe(dest(paths.dist.distDir));
};

export const cssAsyncSplit = () => {
  return src(paths.src.css.cssEntries, { since: lastRun(cssAsyncSplit) })
    .pipe(plumber())
    .pipe(
      postcss([
        criticalSplit({
          startTag: "critical:start",
          endTag: "critical:end",
          output: "rest",
        }),
      ])
    )
    .pipe(
      rename((file) => {
        file.basename = `${file.basename}.async`;
        const themeDir = file.dirname.split("/")[0];
        const projectDir = file.dirname.split("/")[1];
        file.dirname = `${themeDir}/${projectDir}/styles/.tmp/split`;
      })
    )
    .pipe(stripComments())
    .pipe(debug({ title: "cssAsynclSplit : " }))
    .pipe(dest(paths.dist.distDir));
};
