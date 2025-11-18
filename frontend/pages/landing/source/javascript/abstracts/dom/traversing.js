export const find = (selector, context = document) => {
  return Array.prototype.slice.call(context.querySelectorAll(selector));
};

export const findOne = (selector, context = document) => {
  return context.querySelector(selector);
};
