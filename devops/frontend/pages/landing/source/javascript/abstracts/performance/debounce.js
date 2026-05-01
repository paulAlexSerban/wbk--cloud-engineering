/**
 * https://www.freecodecamp.org/news/javascript-debounce-example/
 * https://davidwalsh.name/javascript-debounce-function
 * https://www.geeksforgeeks.org/debouncing-in-javascript/
 * https://www.javatpoint.com/javascript-debouncing
 */

export const debounce = (func, wait, immediate) => {
  let timeout;

  return (...args) => {
    const callNow = immediate && !timeout;
    const later = function () {
      timeout = null;
      if (!immediate) func.apply(this, args);
    };

    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
    if (callNow) {
      func.apply(this, args);
    }
  };
};
