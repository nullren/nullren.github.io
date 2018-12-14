---
layout: post
title: "Creating UML Sequence Diagrams"
category:
tags: []
---

There are a lot of really awful tools online full of ads and what not. All I wanted was a "simple" tool to create UML sequence diagrams. You can do it locally, with PlantUML:

```
docker run --rm -it -p 8080:8080 plantuml/plantuml-server:jetty
```

Then go to [http://localhost:8080](http://localhost:8080).

Now you can paste stuff, like this one I was particularly fond on:

```
@startuml
title Client Request
    
Client->Nginx: Request Made
activate Nginx
Nginx->Lua: ssl_certificate_by_lua_file
activate Lua
    
note left of Lua: Local Cache
    Lua-->Lua: Fetch from cache
    
opt if not found in local cache
note left of Lua: loadCert
    Lua->RedisSlave: hmget domain cert
    activate RedisSlave
    RedisSlave-->Lua:
    deactivate RedisSlave
    Lua->RedisSlave: hmget domain key
    activate RedisSlave
    RedisSlave-->Lua:
    deactivate RedisSlave
    Lua->Lua: Cache locally
end
    
opt if not found in loadCert   
note left of Lua: genAndLoad
    Lua->Node: POST /domain/:domain
    activate Node
    Node->RedisSlave: hexists domain
    activate RedisSlave
    RedisSlave-->Node:
    deactivate RedisSlave
    Node->RedisSlave: get lock:domain
    activate RedisSlave
    RedisSlave-->Node:
    deactivate RedisSlave
opt lock acquired
    Node->RedisMaster: setex lock:domain
    activate RedisMaster
    RedisMaster->RedisSlave: replicate
    activate RedisSlave
    RedisSlave-->RedisMaster:
    deactivate RedisSlave
    RedisMaster-->Node:
    deactivate RedisMaster
    Node-->Node: resolve DNS
    
    Node->LE: new-authz
    activate LE
    LE-->Node:
    deactivate LE
    Node->RedisMaster: setex wellknown:token
    activate RedisMaster
    RedisMaster->RedisSlave: replicate
    activate RedisSlave
    RedisSlave-->RedisMaster:
    deactivate RedisSlave
    RedisMaster-->Node:
    deactivate RedisMaster
    Node->LE: queue verification
    activate LE
    LE-->Node:
    deactivate LE
    LE->Nginx: GET /.well-known/acme-challenge
    activate Nginx
    Nginx->Lua: content_by_lua_file
    activate Lua
    Lua->RedisSlave: get wellknown:token
    activate RedisSlave
    RedisSlave-->Lua:
    deactivate RedisSlave
    Lua-->Nginx:
    deactivate Lua
    Nginx-->LE: acme_response
    deactivate Nginx
loop max 10 tries, 5 second interval
    Node->LE: verification complete?
    activate LE
    LE-->Node:
    deactivate LE
end
    Node->LE: new-cert
    activate LE
    LE-->Node: signed cert
    deactivate LE
    
    Node->RedisMaster: hmset domain cert
    activate RedisMaster
    RedisMaster->RedisSlave: replicate
    activate RedisSlave
    RedisSlave-->RedisMaster:
    deactivate RedisSlave
    RedisMaster-->Node:
    deactivate RedisMaster
    Node->RedisMaster: zadd domain ttl now+7689600
    activate RedisMaster
    RedisMaster->RedisSlave: replicate
    activate RedisSlave
    RedisSlave-->RedisMaster:
    deactivate RedisSlave
    RedisMaster-->Node:
    deactivate RedisMaster
    Node->RedisMaster: hmset domain key
    activate RedisMaster
    RedisMaster->RedisSlave: replicate
    activate RedisSlave
    RedisSlave-->RedisMaster:
    deactivate RedisSlave
    RedisMaster-->Node:
    deactivate RedisMaster
    Node->RedisMaster: ttl domain 7689600
    activate RedisMaster
    RedisMaster->RedisSlave: replicate
    activate RedisSlave
    RedisSlave-->RedisMaster:
    deactivate RedisSlave
    RedisMaster-->Node:
    deactivate RedisMaster
    Node->RedisMaster: expire lock:domain
    activate RedisMaster
    RedisMaster->RedisSlave: replicate
    activate RedisSlave
    RedisSlave-->RedisMaster:
    deactivate RedisSlave
    RedisMaster-->Node:
    deactivate RedisMaster
end
    Node-->Lua: 
    deactivate Node
    Lua->RedisSlave: hmget domain cert
    activate RedisSlave
    RedisSlave-->Lua:
    deactivate RedisSlave
    Lua->RedisSlave: hmget domain key
    activate RedisSlave
    RedisSlave-->Lua:
    deactivate RedisSlave
    Lua->Lua: Cache locally
end
Lua-->Nginx:
deactivate Lua
    
Nginx->Fastly: Proxy site content
activate Fastly
Fastly-->Nginx:
deactivate Fastly
Nginx-->Client:
deactivate Nginx
@enduml
```
