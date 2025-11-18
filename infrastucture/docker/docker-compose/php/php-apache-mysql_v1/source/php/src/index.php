<?php
  echo "Hello there, this is a PHP apache container";
  echo '<br>';

  // these are the defined authentication environment in db service

  // the MySQL service named in the docker-compose.yml
  $host = 'db';

  // database user-name defined in .env
  $user = 'admin';

  // database password defined in .env
  $pass = 'admin';

  $mydatabase = 'database';


  // check the MySQL connection status
  $conn = new mysqli($host, $user, $pass, $mydatabase);
  if ($conn->connect_error) {
    die("Connection failed: ".$conn->connect_error);
  } else {
    echo "Connected to MySql server successfully!";
  }

  echo '<br>';

  // select query fro database
 $sql = "SELECT * FROM `users`";
  $users = [];

  if ($result = $conn->query($sql)) {
    while ($data = $result->fetch_object()) {
      $users[] = $data;
    }
  }

  foreach ($users as $user) {
    echo '<br>';
    echo $user->username ." ".$user->pass;
    echo '<br>';
  }
?>