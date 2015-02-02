
var http = require('http');
var connect = require('connect');
var mkbook = require('../');

var app = connect();

var options = {
  title: '文档中心',
  defaults: './main.md'
};

app.use(mkbook(options).middleware());

http.createServer(app).listen(3000, function () {
  console.info('start ok!');
});

