import { task, series, parallel, watch } from "gulp";
import { paths } from "./config/paths";
import { lintHtml } from "./tasks/html/lintHtml";
import { lintScss } from "./tasks/scss/lintScss";
import { lintJs } from "./tasks/javascript/lintJs";
import { buildHtml } from "./tasks/html/buildHtml";
import { cssTranspile } from "./tasks/scss/cssTranspile";
import { cssCleanMinify } from "./tasks/scss/cssCleanMinify";
import { jsTranspile } from "./tasks/javascript/jsTranspile";
import { cleanLibrary } from "./tasks/cleanLibrary";
import { removeTemporaryFiles } from "./tasks/removeTemporaryFiles";
import { deploy } from "./tasks/deploy";

task("clean", cleanLibrary);

task("lint:markup", lintHtml);
task("lint:styles", lintScss);
task("lint:scripts", lintJs);
task("lint", parallel("lint:markup", "lint:styles", "lint:scripts"));

task("build:markup", series(lintHtml, buildHtml));
task("build:styles", series(lintScss, cssTranspile, cssCleanMinify));
task("build:scripts", series(lintJs, jsTranspile));
task(
  "build",
  series(
    "clean",
    parallel("build:markup", "build:styles", "build:scripts"),
    removeTemporaryFiles
  )
);

task("watch", () => {
  watch(paths.src.js.jsFiles, series("lint:scripts", "build:scripts"));
  watch(
    [...paths.src.css.scssFiles, ...paths.src.css.scssWatchFiles],
    series("lint:styles", "build:styles", cssCleanMinify)
  );
  watch(paths.src.html.htmlFiles, series("lint:markup", "build:markup"));
  watch(
    [
      `${paths.dist.distDir}/*.html`,
      `${paths.dist.distDir}/*/*`,
      `${paths.dist.distDir}/*/*/*`,
      `${paths.dist.distDir}/*/*/*/*`,
    ],
    deploy
  );
});
