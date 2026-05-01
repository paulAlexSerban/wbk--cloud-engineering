

import {
  SRC_DIR,
  DIST_DIR,
  PROJECT_NAME
} from "./constants";

export const paths = {
  project: PROJECT_NAME,
  src: {
    html: {
      htmlFiles: `./${SRC_DIR}/html/index/index.html`,
    },
    css: {
      scssFiles: [
        `./${SRC_DIR}/scss/*/*/*/*.scss`,
      ],
      scssWatchFiles: [
        `./${SRC_DIR}/scss/*/*.scss`,
        `./${SRC_DIR}/scss/*/*/*.scss`,
        `./${SRC_DIR}/scss/*/*/*/*.scss`,
        `./${SRC_DIR}/scss/*/*/*/*/*.scss`,
        `./${SRC_DIR}/scss/*/*/*/*/*/*.scss`,
      ],
      scssEntries: [
        `./${SRC_DIR}/scss/modules/layout/pages/*.scss`,
      ],
      cssEntries: [
        `${DIST_DIR}/*/*/styles/.tmp/*.page.css`,
        `${DIST_DIR}/*/*/styles/.tmp/*.template.css`,
      ],
      rawCssEntries: `${DIST_DIR}/public/styles/.tmp/*.css`,
    },
    js: {
      jsFiles: [
        `./${SRC_DIR}/javascript/abstracts/*/*.js`,
        `./${SRC_DIR}/javascript/modules/components/*/*/*.js`,
        `./${SRC_DIR}/javascript/modules/structure/*/*.js`,
      ],
      jsEntries: [
        `./${SRC_DIR}/javascript/modules/structure/pages/*.page.js`,
      ],
    },
  },
  dist: {
    distDir: `${DIST_DIR}`,
    coreDist: `../../docs`
  },
};
