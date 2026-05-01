const express = require("express");
const bodyParser = require("body-parser");

// Constants
const CONTAINER_PORT = process.env.CONTAINER_PORT || 5000;
const HOST = '0.0.0.0';

const app = express();

let userGoal = "Learn Docker!";

app.use(
  bodyParser.urlencoded({
    extended: false,
  })
);

app.use(express.static("public"));

const getHtml = (goal) => {
  return `
    <html>
      <head>
        <link rel="stylesheet" href="styles.css">
      </head>
      <body>
        <section>
          <h2>My Course Goal</h2>
          <h3>${goal}</h3>
        </section>
        <form action="/store-goal" method="POST">
          <div class="form-control">
            <label>Course Goal</label>
            <input type="text" name="goal">
          </div>
          <button>Set Course Goal</button>
        </form>
      </body>
    </html>
  `;
}

app.get("/", (req, res) => {
  res.send(getHtml(userGoal));
});

app.post("/store-goal", (req, res) => {
  const enteredGoal = req.body.goal;
  console.log(enteredGoal);
  userGoal = enteredGoal;
  res.redirect("/");
});

app.listen(CONTAINER_PORT, HOST);
console.log(`Running on http://${HOST}:${CONTAINER_PORT}`);
