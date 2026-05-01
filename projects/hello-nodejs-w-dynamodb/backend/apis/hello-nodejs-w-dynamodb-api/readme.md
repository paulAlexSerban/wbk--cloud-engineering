# Hello Nodejs API

## Tech-stack

- Node.js, Express.js, Docker, Docker Compose,

## Features

1. Hello API - A simple API to test the API is working or not.

### Hello API

- `/api/hello/`
  - GET - Retrieve a hello message.
  - POST - Create a hello message.
- `/api/hello/<ID>`
  - PUT - Update a hello message.
  - PATCH - Partially update a hello message.
  - DELETE - Delete a hello message.

### Notes API

- `api/note`
  - GET - Retrieve all notes.
  - POST - Create a note.
- `api/note/<ID>`
  - GET - Retrieve a note.
  - PATCH - Partially update a note.
  - DELETE - Delete a note.
- `api/note/<TIMESTAMP>`
  - DELETE - Delete a note by timestamp.
