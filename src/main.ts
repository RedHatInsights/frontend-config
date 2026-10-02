import http from 'node:http';

const server = http.createServer((req, res) => {
  if (req.url === '/health') {
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    res.end('ok\n');
    return;
  }

  res.writeHead(404);
  res.end();
});

server.listen(8000, () => {
  console.log('frontend-config listening on :8000');
});
