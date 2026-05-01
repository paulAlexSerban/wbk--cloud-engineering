export const regexValidator = (value, pattern) => {
  return new RegExp(pattern).test(value);
};
