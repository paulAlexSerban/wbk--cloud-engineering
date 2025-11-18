/* eslint-disable no-useless-escape */
export const patterns = {
  email:
    /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/gi,
  browsers: [
    ["firefox", /Firefox\/([0-9\.]+)/],
    ["bb", /BlackBerry.+Version\/([0-9\.]+)/],
    ["bb", /BB[0-9]+.+Version\/([0-9\.]+)/],
    ["opera", /OPR\/([0-9\.]+)/],
    ["opera", /Opera\/([0-9\.]+)/],
    ["edge", /Edge\/([0-9\.]+)/],
    ["safari", /Version\/([0-9\.]+).+Safari/],
    ["chrome", /Chrome\/([0-9\.]+)/],
    ["ie", /MSIE ([0-9]+)/],
    ["ie", /Trident\/.+rv:([0-9]+)/],
  ],
  operatingSystem: [
    [
      "ios",
      /([0-9_]+) like Mac OS X/,
      (e) => {
        return e.replace("_", ".").replace("_", "");
      },
    ],
    [
      "ios",
      /CPU like Mac OS X/,
      () => {
        return 0;
      },
    ],
    ["wp", /Windows Phone ([0-9\.]+)/, null],
    ["android", /Android ([0-9\.]+)/, null],
    [
      "mac",
      /Macintosh.+Mac OS X ([0-9_]+)/,
      (e) => {
        return e.replace("_", ".").replace("_", "");
      },
    ],
    ["windows", /Windows NT ([0-9\.]+)/, null],
    ["bb", /BlackBerry.+Version\/([0-9\.]+)/, null],
    ["bb", /BB[0-9]+.+Version\/([0-9\.]+)/, null],
    ["linux", /Linux/, null],
    ["bsd", /BSD/, null],
    ["unix", /X11/, null],
  ],
};
