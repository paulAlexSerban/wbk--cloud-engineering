import { src, dest } from "gulp";
import plumber from "gulp-plumber";
import size from "gulp-size";
import { paths } from "../config/paths";

export const deploy = () => {
  return src([
    `${paths.dist.distDir}/*.html`,
    `${paths.dist.distDir}/*/*`,
    `${paths.dist.distDir}/*/*/*`,
    `${paths.dist.distDir}/*/*/*/*`,
  ])
    .pipe(plumber())
    .pipe(
      size({
        title: "DEPLOYED : ",
        showFiles: true,
        showTotal: true,
      })
    )
    .pipe(dest(paths.dist.coreDist));
};
