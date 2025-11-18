import { config } from "./blank.config";
import { utilityFunction } from "./blank.utils";

export const blank = (el) => {
  const blankEl = el;

  const init = () => {
    console.log(blankEl);
    console.log(config);
    console.log(utilityFunction("test utility function && watchers work again tryout "));
  };

  init();
};
