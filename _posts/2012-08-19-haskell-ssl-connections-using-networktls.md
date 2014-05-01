---
layout: post
title: "haskell ssl connections using Network.TLS"
category: 
tags: [haskell, rawr, fail, linux, wtf]
---
this has been bugging me for a little while but i finally made some
progress with the following program. it works, but for some reason
freenode has a bad handshake and everything dies.

    import System.IO
    import Network
    import Network.TLS
    import Network.TLS.Extra
    import Crypto.Random
    import Text.Printf
    import qualified Control.Exception as E
    import qualified Data.ByteString.Lazy.Char8 as L
    import qualified Data.ByteString.Char8 as B
    import Control.Monad
    
    
    params = defaultParams {pCiphers = ciphersuite_all}
    
    host = "chat.freenode.net"
    port = "6697"
    
    
    -- | Makes a regular connection to the server.
    connect_reg :: IO ()
    connect_reg = do
      h <- connectTo host $ PortNumber $ fromIntegral (read port :: Int)
      hGetLine h >>= putStrLn
    
    
    -- | Makes a SSL connection to the server.
    connect_ssl :: IO ()
    connect_ssl = do
    
      gen <- newGenIO :: IO SystemRandom
      ctx <- connectionClient host port params gen
      E.catch (handshake ctx) perror
    
      let setnick = L.pack "NICK testderp\r\nUSER testderp 0 * :Testing the derp\r\n"
      sendData ctx setnick
    
      listen ctx
    
    listen :: TLSCtx a -> IO ()
    listen ctx = forever $ do
      out <- recvData ctx
      B.putStr out
    
    perror e = putStrLn $ "!!! " ++ show (e :: E.SomeException)
    
    
    main :: IO ()
    main = connect_ssl

    $ runhaskell ssltest.hs 
    !!! HandshakeFailed (Error_Packet_Parsing "Failed reading:
        certrequest distinguishname not of the correct
        size\nFrom:\thandshake\n\n")
    ssltest.hs: ConnectionNotEstablished

i guess i'll try to figure this out before too long.
