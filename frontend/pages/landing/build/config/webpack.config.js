/* eslint-disable import/no-unresolved */
import webpack from "webpack";
import { es5jsLoader } from "../loaders/jsLoader";
import TerserPlugin from "terser-webpack-plugin";

const plugins = [new webpack.ProgressPlugin()];

export const webpackConfig = {
  mode: process.env.NODE_ENV,
  cache: true,
  module: {
    rules: [es5jsLoader],
  },
  plugins: [...plugins],
  optimization: {
    minimize: process.env.NODE_ENV === "production" ? true : false,
    minimizer: [new TerserPlugin()],
  },
  devtool: false
};
