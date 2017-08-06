
var PushClient = function () {
    this.socket = io.connect();
    this.initWin();
    this.setEventListener();
    this.flag = false;
    //this.start();
}

PushClient.prototype.start = function () {
    var _this = this;
    this.socket.on('http_trigger', function(data) {
        _this.execute(data);
    });
}

PushClient.prototype.setEventListener = function () {
    var _this = this;
    var _d = document.getElementById('push-client-div-colse');
    if(document.addEventListener)
    {
        _d.addEventListener('click',function(){
            _this.closeWin();
        });
    }
    else
    {
        _d.attachEvent('click',function(){
            _this.closeWin();
        });
    }
}

PushClient.prototype.initWin = function () {
    var html = '';
    var body = document.body;
    var div = document.createElement("div");
    html += '<div id="push-client-div">';
        html += '<div id="push-client-div-body" style="display: block;height: 600px;margin-top: 10px;">';
             html += '<div id="push-client-div-title"><span id = "push-client-div-colse">&#43</span></div>'
             html += '<div id="push-client-div-html"></div>';
        html += '</div>';
    html += '</div>';
    body.appendChild(div);
    div.innerHTML = html;
    document.getElementById('push-client-div').style.display = 'none';
}

PushClient.prototype.createWin = function (url) {
        this.createIframe(url);
        this.flag = true;
}

PushClient.prototype.createIframe =  function (url) {
    if(!url) return;
    var iframe = document.createElement('iframe');
    iframe.src = url;
    iframe.width = '100%';
    iframe.frameborder = 0;
    iframe.scrolling = 'yes';//滚动条
    iframe.id = 'push-client-div-iframe';
    iframe.name = 'push-client-div-iframe';
    iframe.height = document.getElementById('push-client-div-html').offsetHeight + 'px';
    document.getElementById('push-client-div-html').appendChild(iframe);
};

PushClient.prototype.openWin =  function (url) {
    var iframe = document.getElementById('push-client-div-iframe');
    document.getElementById('push-client-div').style.display = 'block';
    if(iframe){
        iframe.src = url;
    }else{
        this.createIframe(url);
    }
};

PushClient.prototype.closeWin = function () {
    document.getElementById('push-client-div').style.display = 'none';
    //this.removeWin();
}

PushClient.prototype.removeWin = function () {
    if (this.flag){
        var iframe = document.getElementById('push-client-div-iframe');
        if(iframe) document.getElementById('push-client-div-html').removeChild(iframe);
    }
}

/**
 * 触发事件: 接收推送消息时触发
 * @param data 消息对象
 */
PushClient.prototype.execute = function (data) {
    var user = 'ems';
    if(data.user === user) {
        this.openWin(data.url);
        //this.removeWin();
        //this.createWin(data.url);
    }
}

window.onload = function () {
    new PushClient().start();
}