var express = require('express'),
    app = express(),
    server = require('http').createServer(app),
    io = require('socket.io').listen(server),
    data = {};
    count = 0;

app.use('/', express.static(__dirname + '/www'));

app.post('/http', function (req, res) {
            data = req.body.data; //请求参数
            data.count = count+1;     //请求次数
            res.send("请求网址:"+data.url);
            io.sockets.emit('http_trigger',data);
            console.log(data);
        });

app.get('/http', function (req, res) {
    var url = req.query.url;
    var user = req.query.user; //请求参数
    count = count+1;
    data.count = count;
    data.user = user;
    data.url = url;
    res.send("请求网址:"+url);
    io.sockets.emit('http_trigger',data);
    console.log(data);
});

server.listen(8080);

