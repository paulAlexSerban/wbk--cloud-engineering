import { src, dest } from "gulp";
import plumber from "gulp-plumber";
import size from 'gulp-size';

const videoEntries = "./source/videos/*";
const videoDistDir = "./dist/videos";

export const loadVideos = () => {
  return src(videoEntries)
    .pipe(plumber())
    .pipe(size({
      title: 'DEPLOYED : ',
      showFiles: true,
      showTotal: true
    }))
    .pipe(dest(videoDistDir));
};