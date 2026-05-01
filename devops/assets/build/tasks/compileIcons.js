import { src, dest } from "gulp";
import plumber from "gulp-plumber";

const iconEntries = "./source/icons/*";
const iconDistDir = "./dist/icons";

export const compileIcons = () => {
  return src(iconEntries)
    .pipe(plumber())
    .pipe(dest(iconDistDir));
};