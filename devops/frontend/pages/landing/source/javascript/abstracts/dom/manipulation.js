export const hasClass = (className, el) => {
  const cls = className.split('.').join(''); /* Removes the dot at beginning of the class selector */
  let classVerify = false;
  if (el.classList) {
    classVerify = el.classList.contains(cls);
  } else {
    classVerify = new RegExp(`(^| )${cls}( |$)`, 'gi').test(el.className);
  }
  return classVerify;
};

export const addClass = (className, el) => {
  if (el.classList) return el.classList.add(className);
  return `${el.className} ${className}`;
};

export const removeClass = (className, el) => {
  if (el.classList) return el.classList.remove(className);
  el.className = el.className.replace(new RegExp(`(^|\\b)${className.split(' ').join('|')}(\\b|$)`, 'gi'), ' ');
  return el;
};

export const toggleClass = (className, el) => {
  if (hasClass(className, el)) return removeClass(className, el);
  return addClass(className, el);
};
