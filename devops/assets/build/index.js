import { task, parallel, series } from "gulp";
import { compileIcons } from "./tasks/compileIcons";
import { createImageRenditions } from "./tasks/createImageRenditions";
import { compileSvgs } from "./tasks/compileSvgs";
import { deployAssets } from "./tasks/deployAssets";
import { cleanAssets } from "./tasks/cleanAssets";
import { loadVideos } from "./tasks/loadVideos";

task("clean", cleanAssets);

task(
  "build",
  series("clean", parallel(compileIcons, createImageRenditions, compileSvgs, loadVideos))
);
