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

    --- /etc/ssl/openssl.cnf  2013-01-06 15:55:12.265817589 -0800
    +++ ../openssl.cnf  2013-01-06 16:07:30.005213907 -0800
    @@ -39,7 +39,7 @@
     ####################################################################
     [ CA_default ]
     
    -dir    = /etc/ssl    # Where everything is kept
    +dir    = /home/ren/.local/etc/ssl/omgren.com_CA    # Where everything is kept
     certs    = $dir/certs    # Where the issued certs are kept
     crl_dir    = $dir/crl    # Where the issued crl are kept
     database = $dir/index.txt  # database index file.
    @@ -78,7 +78,7 @@
     # A few difference way of specifying how similar the request should look
     # For type CA, the listed attributes must be the same, and the optional
     # and supplied fields are just that :-)
    -policy   = policy_match
    +policy   = policy_anything
     
     # For the CA policy
     [ policy_match ]
    @@ -126,17 +126,18 @@
     
     [ req_distinguished_name ]
     countryName      = Country Name (2 letter code)
    -countryName_default    = AU
    +countryName_default    = US
     countryName_min      = 2
     countryName_max      = 2
     
     stateOrProvinceName    = State or Province Name (full name)
    -stateOrProvinceName_default  = Some-State
    +stateOrProvinceName_default  = California
     
     localityName     = Locality Name (eg, city)
    +localityName_default   = Los Angeles
     
     0.organizationName   = Organization Name (eg, company)
    -0.organizationName_default = Internet Widgits Pty Ltd
    +0.organizationName_default = omgren.com
     
     # we can do this but it is not needed normally :-)
     #1.organizationName    = Second Organization Name (eg, company)

Make a couple required files that don't make themselves:

    touch index.txt
    echo 1000 | tee serial | tee crlnumber

Then create the CA cert:

    openssl req -new -x509 -days 3650 -extensions v3_ca \
      -keyout private/cakey.pem -out cacert.pem \
      -config ../openssl.cnf

## Generating CRL

    openssl ca -config ../openssl.cnf -gencrl -out crl.pem

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

## Adding CA to `/etc/certs`

    cp cacert.pem /usr/local/share/ca-certificates/omgren.com/omgren.com_SSLCA.crt
    update-ca-certificates -v -f

I saw `Adding debian:omgren.com_SSLCA.pem` so I was happy. Then I had to add the CA cert to Chrome and my phone.


