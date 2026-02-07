// Dépendances
import os from 'os';
import express from 'express';

const app = express();
const PORT = process.env.PORT || 3000;

// Start the server
app.get('/', (req, res) => {
  res.json({
    message: '🚀 Second Project DevOps - Kubernetes Edition',
    version: process.env.APP_VERSION || '1.0.0',
    hostname: os.hostname(),
    environment: process.env.NODE_ENV || 'development'
  });
});

app.get('/health', (req, res) => {
    res.status(200).json({ status: 'ok' });
});

app.get('/ready', (req, res) => {
    res.status(200).json({ status: 'ready' });
});

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});