import del from "del";
import { paths } from "../config/paths";

export const removeTemporaryFiles = () => {
  return del([`${paths.dist.distDir}/public/styles/.tmp`]);
};
