var express = require('express'),
    app = express(),
    server = require('http').createServer(app),
    io = require('socket.io').listen(server),
    data = {},
    count = 0;

app.use('/', express.static(__dirname + '/www'));

app.post('/http', function (req, res) {
            var data = req.body.data; //请求参数
            data.count = count+1;     //请求次数
            res.send("请求网址:"+data.http);
            io.sockets.emit('http_trigger',data);
            console.log(data);
        });

app.get('/http', function (req, res) {
    count = count+1;
    var url = req.query.url;
    var user = req.query.user;

    data.url = url;
    data.user = user;
    data.count = count;

    console.log('网址:'+url+'---'+'用户:'+user+'---'+'次数:'+count);
    io.sockets.emit('http_trigger',data);
    res.send('请求成功');

});

server.listen(8888);
console.log('................... push-server port:8888 ....................');
