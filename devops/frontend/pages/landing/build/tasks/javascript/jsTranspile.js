import {src, dest, lastRun } from 'gulp';
import gulpWebpack from 'webpack-stream';
import webpack from 'webpack';
import { webpackConfig } from '../../config/webpack.config';
import { paths } from '../../config/paths';
import plumber from 'gulp-plumber';
import rename from "gulp-rename";
import through from 'through';
import path from "path";
import debug from 'gulp-debug';

export const jsTranspile = () => {
  return src(paths.src.js.jsEntries)
    .pipe(debug({title: 'jsTranspile :'}))
    .pipe(plumber())
    .pipe(through(function(file) {
      const relative = path.relative(".", file.path).split(".");
      relative.pop();
      file.named = relative.join(".");
      this.queue(file);
    }))
    .pipe(gulpWebpack( webpackConfig, webpack))
    .pipe(rename((file) => {
      file.dirname = `javascript`;
    }))
    .pipe(dest(`${paths.dist.distDir}/public`));
};
