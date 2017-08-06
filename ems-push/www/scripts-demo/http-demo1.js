//引入http模块
var http = require('http'),
    //创建一个服务器
    server = http.createServer(function(req, res) {
        res.writeHead(200, {
            'Content-Type': 'text/plain'
        });
        res.write('hello world!');
        res.end();
    });
//监听80端口
server.listen(80);
console.log('server started');