---
layout: post
title: "SSL Fun with Tomcat and Android"
category: 
tags: [web, rawr, fml, java, android, tomcat, openssl]
---

I followed instructions from these pages:
 * [Creating a CA with OpenSSL](http://www.freebsdmadeeasy.com/tutorials/freebsd/create-a-ca-with-openssl.php)
 * [Apache Tomcat 7 - SSL How-To](http://tomcat.apache.org/tomcat-7.0-doc/ssl-howto.html)

## Creating a CA

This was mostly kind of easy. I put all my CA stuff in my own stash.
First was to make all the directories and files needed in `openssl.cnf`.

    mkdir -p ~/.local/etc/ssl/omgren.com_CA/{certs,crl,newcerts,private}
    cp /etc/ssl/openssl.cnf ~/.local/etc/ssl/

Edit the `openssl.cnf` file so that the default CA section has

    -dir    = /etc/ssl    # Where everything is kept
    +dir    = /home/ren/.local/etc/ssl/omgren.com_CA    # Where everything is kept

Make a couple required files that don't make themselves:

    touch index.txt
    echo 1000 | tee serial | tee crlnumber

Then create the CA cert:

    openssl req -new -x509 -days 3650 -extensions v3_ca \
      -keyout private/cakey.pem -out cacert.pem \
      -config ../openssl.cnf

### Generating CRL

    openssl ca -config ../openssl.cnf -gencrl -out crl.pem

### Adding CA to `/etc/certs`

    cp cacert.pem /usr/local/share/ca-certificates/omgren.com/omgren.com_SSLCA.crt
    update-ca-certificates -v -f

I saw `Adding debian:omgren.com_SSLCA.pem` so I was happy. Then I had to add the CA cert to Chrome and my phone.

### Adding CA to Chrome

This was really easy, just download the CA cert, then go into 
`Settings > Advanced Settings > HTTPS/SSL > Manage Certificates > Authorities > Import`.

### Adding CA to Android

This was easy on Android 4.0 (and not possible on 2.3). Just download the CA cert and it's put into the system keystore!

It turns out you have to use BouncyCastle to create a truststore on android phones. I downloaded the [Bouncy Castle Provider](http://bouncycastle.org/download/bcprov-jdk16-145.jar) and then did the following command on my CA certificate:

    keytool -importcert -v -trustcacerts -file ~/ssl/omgren.com_CA/cacert.pem \
      -alias ca -keystore trust.bks \
      -provider org.bouncycastle.jce.provider.BouncyCastleProvider \
      -providerpath bcprov-jdk16-145.jar -storetype BKS

This then was put inside `res/raw/` in my Android project directory. 

## Creating Tomcat SSL Keys

I just followed the Apache How-To for "Installing a Certificate from a Certificate Authority".

    keytool -genkey -alias tomcat -keyalg RSA -keystore awesome.jks

    Enter keystore password:  
    Re-enter new password: 
    What is your first and last name?
      [Unknown]:  awesome.omgren.com
    What is the name of your organizational unit?
      [Unknown]:  awesome.omgren.com
    What is the name of your organization?
      [Unknown]:  omgren.com
    What is the name of your City or Locality?
      [Unknown]:  Los Angeles
    What is the name of your State or Province?
      [Unknown]:  California
    What is the two-letter country code for this unit?
      [Unknown]:  US
    Is CN=awesome.omgren.com, OU=awesome.omgren.com, O=omgren.com, L=Los Angeles, ST=California, C=US correct?
      [no]:  yes
    
    Enter key password for <tomcat>
      (RETURN if same as keystore password):  

    keytool -certreq -keyalg RSA -alias tomcat -file certreq.csr -keystore awesome.jks

Now copy the `certreq.csr` to the CA and sign it.

    cp certreq.csr ~ren/ssl/omgren.com_CA/certs/awesome.omgren.com_req.pem

    cd certs
    openssl ca -config ../../openssl.cnf -in awesome.omgren.com_req.pem -out awesome.omgren.com_cert.pem

Now copy it and the CA cert back to Tomcat

    cp ~ren/ssl/omgren.com_CA/cacert.pem ~ren/ssl/omgren.com_CA/certs/awesome.omgren.com_cert.pem /etc/tomcat7/ssl

    keytool -import -alias root -keystore awesome.jks -trustcacerts -file cacert.pem
    keytool -import -alias tomcat -keystore awesome.jks -file awesome.omgren.com_cert.pem

I had to remove everything except the certificate at the end fo `awesome.omgren.com_cert.pem` for it to work.

The next important thing to do is to create the `truststoreFile` in tomcat. this was pretty easy, too.

    keytool -genkey -alias dummy -keyalg RSA -keystore truststore.jks
    keytool -delete -alias dummy -keystore truststore.jks
    keytool -import -v -trustcacerts -alias my_ca -file cacert.pem -keystore truststore.jks

Then to make Tomcat use it, just enable it in the `server.xml`. Uncomment this `connector` block:

    <Connector port="8443" protocol="HTTP/1.1" SSLEnabled="true"
               maxThreads="150" scheme="https" secure="true"
               keystoreFile="conf/ssl/awesome.jks" keystorePass="changeit"
               truststoreFile="conf/ssl/truststore.jks" truststorePass="changeit"
               clientAuth="true" sslProtocol="TLS" />

New problem is I can't get android to use client certificates to connect to the page. So for the time being, I
have to leave `clientAuth="false"`.

## Creating Client SSL certificates

    cd certs
    openssl req -config ../../openssl.cnf -new -nodes -out user_req.pem -keyout ../private/users/user_key.pem
    openssl ca -config ../../openssl.cnf -out user_cert.pem -infiles user_req.pem
    cd ../private/users
    openssl pkcs12 -export -out user.p12 -inkey user_key.pem -in ../../certs/user_cert.pem

Then just download or otherwise send `user.p12` to the user to install into their browser. This worked on Chrome,
this did *not* work on Android.


## Playing nicely with Android

For now, because I can't install client certificates, I'm just trying to get plain SSL to work (`clientAuth="false"`).
My first try was to just do a normal `HttpURLConnection`, but I get this error:

    javax.net.ssl.SSLHandshakeException: java.security.cert.CertPathValidatorException: Trust anchor for certification path not found.

This was fixed! I had to add my `user.p12` key and the `trust.bks` I made, into `res/raw/`. Then I could do the ManagerFactories with them.
