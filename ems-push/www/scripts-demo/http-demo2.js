//引入http模块
var http = require('http'),
    //创建一个服务器
    server = http.createServer(function(req, res) {
        res.writeHead(200, {
            'Content-Type': 'text/html' //将返回类型由text/plain改为text/html
        });
        res.write('<h1>hello world!</h1>'); //返回HTML标签
        res.end();
    });
//监听80端口
server.listen(80);
console.log('server started');