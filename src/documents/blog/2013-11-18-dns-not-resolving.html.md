---
layout: post
title: DNS not resolving
description: Sometimes we have this weired situation where all the domain records are correct but the domain does not resolve properly. Here I describe one such sitation and how to go about debugging it.
date: 2013-11-18 20:04
tags:
	- dns
	- network
	- reference
author: "Ramjee Ganti"
comments: true
sharing: true
footer: true
---
Recently I moved [ramjeeganti.com](/) to this current place on s3. In an earlier [post](/blog/2013/10/30/ramjeeganti-dot-com-on-s3/) I mentioned about moving my site to amazon-s3 and octopress. Shortly after the movement, I found that the domain "ramjeeganti.com" was not at all resolving.
Shortly there after I found that my google apps has not updated the mails for over a da, though it was allowing me to send mails. This made me suspicious and finally figured out that the dns nameserver entries had to updated.
<!-- more -->
The domain registrar where this domain is registered failed to update me on the nameserver change. I just had to update the nameservers to fix the issue. What is more interesting is in the process of root causing the problem, I came across multiple tools which can help in figuring out the issue.

``` bash 
dig - DNS lookup utility
dig ramjeeganti.com

; <<>> DiG 9.8.1-P1 <<>> ramjeeganti.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 43592
;; flags: qr rd ra; QUERY: 1, ANSWER: 4, AUTHORITY: 0, ADDITIONAL: 0

;; QUESTION SECTION:
;ramjeeganti.com.		IN	A

;; ANSWER SECTION:
ramjeeganti.com.	28485	IN	A	216.239.36.21
ramjeeganti.com.	28485	IN	A	216.239.32.21
ramjeeganti.com.	28485	IN	A	216.239.38.21
ramjeeganti.com.	28485	IN	A	216.239.34.21

;; Query time: 299 msec
;; SERVER: 127.0.0.1#53(127.0.0.1)
;; WHEN: Tue Nov 19 09:21:04 2013
;; MSG SIZE  rcvd: 97


# Use another dns server (google in this case)
dig ramjeeganti.com @8.8.8.8

; <<>> DiG 9.8.1-P1 <<>> www.ramjeeganti.com @8.8.8.8
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 6444
;; flags: qr rd ra; QUERY: 1, ANSWER: 3, AUTHORITY: 0, ADDITIONAL: 0

;; QUESTION SECTION:
;www.ramjeeganti.com.		IN	A

;; ANSWER SECTION:
www.ramjeeganti.com.	21600	IN	CNAME	ramjeeganti.com.s3-website-ap-southeast-1.amazonaws.com.
ramjeeganti.com.s3-website-ap-southeast-1.amazonaws.com. 60 IN CNAME s3-website-ap-southeast-1.amazonaws.com.
s3-website-ap-southeast-1.amazonaws.com. 60 IN A 203.83.220.122

;; Query time: 591 msec
;; SERVER: 8.8.8.8#53(8.8.8.8)
;; WHEN: Tue Nov 19 09:21:41 2013
;; MSG SIZE  rcvd: 133

```

``` bash  
nslookup - query Internet name servers interactively
nslookup
> ramjeeganti.com
Server:		127.0.0.1
Address:	127.0.0.1#53

Non-authoritative answer:
Name:	ramjeeganti.com
Address: 216.239.32.21
Name:	ramjeeganti.com
Address: 216.239.38.21
Name:	ramjeeganti.com
Address: 216.239.34.21
Name:	ramjeeganti.com
Address: 216.239.36.21
> set q=mx
> ramjeeganti.com 
Server:		127.0.0.1
Address:	127.0.0.1#53

Non-authoritative answer:
ramjeeganti.com	mail exchanger = 30 aspmx2.googlemail.com.
ramjeeganti.com	mail exchanger = 10 aspmx.l.google.com.
ramjeeganti.com	mail exchanger = 30 aspmx5.googlemail.com.
ramjeeganti.com	mail exchanger = 30 alt2.aspmx.l.google.com.
ramjeeganti.com	mail exchanger = 30 aspmx4.googlemail.com.
ramjeeganti.com	mail exchanger = 20 alt1.aspmx.l.google.com.
ramjeeganti.com	mail exchanger = 30 aspmx3.googlemail.com.

Authoritative answers can be found from:
> set q=CNAME
> ramjeeganti.com  
Server:		127.0.0.1
Address:	127.0.0.1#53

Non-authoritative answer:
*** Can't find ramjeeganti.com: No answer

Authoritative answers can be found from:
ramjeeganti.com
	origin = whiz.mercury.orderbox-dns.com
	mail addr = ganti.r.gmail.com
	serial = 2013110501
	refresh = 7200
	retry = 7200
	expire = 172800
	minimum = 7200
> set q=any
> ramjeeganti.com
Server:		127.0.0.1
Address:	127.0.0.1#53

Non-authoritative answer:
Name:	ramjeeganti.com
Address: 216.239.36.21
Name:	ramjeeganti.com
Address: 216.239.32.21
Name:	ramjeeganti.com
Address: 216.239.38.21
Name:	ramjeeganti.com
Address: 216.239.34.21
ramjeeganti.com	mail exchanger = 30 aspmx2.googlemail.com.
ramjeeganti.com	mail exchanger = 10 aspmx.l.google.com.
ramjeeganti.com	mail exchanger = 30 aspmx5.googlemail.com.
ramjeeganti.com	mail exchanger = 30 alt2.aspmx.l.google.com.
ramjeeganti.com	mail exchanger = 30 aspmx4.googlemail.com.
ramjeeganti.com	mail exchanger = 20 alt1.aspmx.l.google.com.
ramjeeganti.com	mail exchanger = 30 aspmx3.googlemail.com.
ramjeeganti.com	nameserver = whiz.mercury.orderbox-dns.com.
ramjeeganti.com	nameserver = whiz.venus.orderbox-dns.com.
ramjeeganti.com	nameserver = whiz.earth.orderbox-dns.com.
ramjeeganti.com	nameserver = whiz.mars.orderbox-dns.com.
ramjeeganti.com
	origin = whiz.mercury.orderbox-dns.com
	mail addr = ganti.r.gmail.com
	serial = 2013110501
	refresh = 7200
	retry = 7200
	expire = 172800
	minimum = 7200

Authoritative answers can be found from:
```
There are many sites which make like simple for people like me. They do all the necessary querying and show you the results in a pretty way.

* [DNS Check Pingdom](http://dnscheck.pingdom.com/)

* [Leaf DNS](http://leafdns.com/index.cgi?testid=506AD147)

* [Network Tools](http://network-tools.com/)

* [Check whether DNS is working properly](http://www.akadia.com/services/check_dns.html)
