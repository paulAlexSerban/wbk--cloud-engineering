const express = require('express');

// Constants
const CONTAINER_PORT = process.env.CONTAINER_PORT || 5000;
const HOST = '0.0.0.0';

// App
const app = express();
app.get('/', (req, res) => {
  res.send('Hello NodeJS on Docker');
});

app.listen(CONTAINER_PORT, HOST);
console.log(`Running on http://${HOST}:${CONTAINER_PORT}`);