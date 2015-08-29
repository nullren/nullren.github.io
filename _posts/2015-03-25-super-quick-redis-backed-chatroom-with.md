---
layout: post
title: super quick redis backed chatroom with websockets
---

In case this disappears from [my github][1], I made a really small,
quick, and dirty chatroom with redis and nodejs.

The important components of this are that

1. You can send messages by posting a json object to the server.
2. You can subscribe and listen to messages by connecting to the same
   server with a websocket.

As a bonus, you can also send messages back through the websocket, but
that is not what is important for our usecase.

Currently, the pipeline looks something like:

![node redis pubsub graph][2]

Basically, a `User` will post a JSON object containing whatever
relevant information they want or need to provide (eg, channel/topic,
message, credentials, etc).

From there, the nodejs server handling that request will then publish
it into our pubsub queue in the correct channel, in this case it is
redis.

From there, all the node servers subscribed to that channel will
receive the message and then each of those node servers will emit it
outwards to their users connected through websockets.

With this stack in particular, what is convenient is that, the only
connections made to redis are from individual nodejs servers. Each of
the nodejs servers individually could have many websocket connections
to their clients.

Here is a very basic example I set up that is currently running in
[marathon][3] right now.

It handles both the POST request and websocket clients.

    // TODO this should be dynamic and also contain auth stuff
    var PS_CHAN = 'pubsub'

    var app = require('express')()
    var http = require('http').Server(app)
    var io = require('socket.io')(http)
    var bodyParser = require('body-parser')

    // TODO get info directly from marathon or something
    var redis = require('redis'),
        subscriber = redis.createClient(31000, 'expendable2', {}),
        publisher = redis.createClient(31000, 'expendable2', {})

    // just one redis connection per server
    subscriber.subscribe(PS_CHAN)

    // emit to all connect socketio users
    subscriber.on('message', function(channel, message) {
      io.emit('chat message', message)
    })

    app.use(bodyParser.json())

    // serve a little page
    app.get('/', function(req, res){
      res.sendFile(__dirname + '/index.html');
    });

    // let people post messages
    app.post('/', function(req, res){
      // req.body could be json and include authentication stuff as well
      // as the pubsub channel
      console.log('got a post request: ' + req.body.chan + ': ' + req.body.msg)
      publisher.publish(req.body.chan, req.body.msg)
      res.send('ok\n')
    })

    // when a user connects, publish their messages from the socket
    io.on('connection', function(socket){

      // user connected/disconnected from socket
      console.log('a user connected');
      socket.on('disconnect', function(){
        console.log('a user disconnected');
      });

      // handel input from socket as a convenience right now
      socket.on('chat message', function(msg){
        publisher.publish(PS_CHAN, msg)
      })
    })

    http.listen(3000, function(){
      console.log('listening on *:3000');
    });

You can see an [example here][4] (this link may not work in the
future).

Anyway, to interact with the "chat room", there was a convenience
method set up to allow users to send messages through the websocket,
but to see that POST requests get sent through the pipeline, open a
terminal and run the following command:

    curl -H 'Content-Type: application/json' -X POST \
      -d '{"chan":"pubsub", "msg":"test message"}' \
      http://expendable1:31000

Some things to consider:

  * Failover for redis (clustering or something)
  * Necessity of keeping a backlog available for those that want it.
    If this is necessary, we may want to consider Kafka instead of
    redis.
  * Perhaps instead of using redis or kafka, using both since they
    both have their own strenghts.
  * Specifying an exact API that we'd like to use and follow.

  [1]: https://github.com/nullren/chat-example
  [2]: /images/node-redis-pubsub.png
  [3]: http://expendable4:8080
  [4]: http://expendable1:31000
