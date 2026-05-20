const express = require('express');
const app = express();
const port = process.env.PORT || 80;

app.get('/', (req, res) => {
  res.json({
    message: 'Hello World from AWS App Runner!',
    timestamp: new Date().toISOString(),
    env: {
      DYNAMODB_TABLE: process.env.DYNAMODB_TABLE || 'Not Set',
      SECRET_ID: process.env.SECRET_ID || 'Not Set',
      S3_BUCKET: process.env.S3_BUCKET || 'Not Set'
    }
  });
});

app.get('/health', (req, res) => {
  res.status(200).send('OK');
});

app.listen(port, () => {
  console.log(`Hello World app listening at http://localhost:${port}`);
});
