var http = require('http'),
    faye = require('faye');

var server = http.createServer(),
    bayeux = new faye.NodeAdapter({mount: '/faye', timeout: 45}),
    redis = require("redis"),
    client = redis.createClient(),
    secToken = '887576189382964c910e1071debcd6867da7acff04c89b0f82f20c8c14131ac3',
    serverAuth = {
      incoming: function(message, callback) {
        if (message.channel !== '/meta/subscribe')
          return callback(message);

        var subscription = message.subscription,
            authToken    = message.ext && message.ext.authToken,
            servToken    = message.ext && message.ext.servToken;
    
        if (servToken && servToken == secToken)
          return callback(message);
    
        client.get(subscription, function(err, obj) {
          if (authToken !== obj)
            message.error = 'Invalid subscription auth token';
          else
            callback(message);
        });
      }
    };

client.on("error", function (err) {
    console.log("Error " + err);
});

console.log("Faye: Attaching server");
bayeux.attach(server);

console.log("Faye: Adding extension")
bayeux.addExtension(serverAuth);

console.log("Faye: Ready, Listening on 9292");
server.listen(9292);
