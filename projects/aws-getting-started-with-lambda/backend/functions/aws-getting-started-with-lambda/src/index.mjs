import * as fs from "node:fs";

const html = fs.readFileSync("index.html", { encoding: "utf8" });
const css = fs.readFileSync("styles.css", { encoding: "utf8" });

const dynamicForm = (html, queryStringParameters) => {
  let formres = "";
  if (queryStringParameters) {
    Object.values(queryStringParameters).forEach((val) => {
      formres = formres + val + " ";
    });
  }
  return html.replace(
    "{formResults}",
    "<h4>Form Submission: " + formres + "</h4>"
  );
};

const injectAssets = (html) => {
  return html
    .replace("{css}", `<style>${css}</style>`)
    .replace(
      "{js}",
      `<script src="https://code.jquery.com/jquery-3.6.0.min.js" async defer></script>`
    );
};

const handler = async (event) => {
  let modifiedHTML = dynamicForm(html, event.queryStringParameters);
  modifiedHTML = injectAssets(modifiedHTML);
  const response = {
    statusCode: 200,
    headers: {
      "Content-Type": "text/html",
    },
    body: modifiedHTML,
  };
  return response;
};

export { handler };
