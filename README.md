# handshake-gateway

This container is a general purpose Handshake access gateway server

It provides this service by running a number of servers to assit you in accessing the Handshake world.

- A Handshake aware DNS server, including full DNSSEC support
- A DNS-over-HTTPS (DoH) gateway to the DNS service
- A Handshake aware `squid` proxy cache
- A Handshake aware Website Proxy Service

## Handshake aware DNS server

If you point you desktop / servers to this container to get their DNS, they will have access to all the ICANN
and Handshake DNS domains, including full DNSSEC support. 

NOTE: the DNS server take a little time to seed itself (should be less than a minute), and this needs to be
done each time you restart the container, unless you make the container's directory `/opt/named/zones` persistent
across restarts, e.g by using the option `-v` to map the container's directory to a directory on the host system.

All the other services use this service, so will also no work until this seeding is complete


## Handshake aware DoH

The DoH service follows the [Google JSON/DNS/API](https://developers.google.com/speed/public-dns/docs/doh/json) spec.

The Certificate is issued by a private certificate authority for the name `wwwhns.regserv.net`, which resolve to `127.0.0.1`. The file `myCA.pem`
is the public certificate for that authority. If you wish to use your own certificate, replace the file `/opt/pems/certket.pem`
with a PEM of both the certificate & private key.

With the container running on your desktop, you can test the DoH service with something like this

    curl --cacert myCA.pem https://wwwhns.regserv.net/dns/api/v1.0/resolv?name=www.google.com


## Handshake aware proxy cache

A proxy cache will fetch web pages for you & keep a cached copy, not very useful for a single PC, but if the cache is shared with
everybody on a LAN, it can save up to 50% of download traffic.

In this case its usefulness is in the fact that it know how to access Handshake websites, so all you have to do is configure your web
browser to use the proxy cache (all browsers support this), and you will then be able to access Handshake websites directly from
you favourite browser.

The proxy cache runs on port `3128`. If you are running this container on your desktop PC, then the IP Address will be `127.0.0.1`


## Handshake aware Website Proxy Service

A Website Proxy Service is a website that will ask yuo what website you want to visit, then fetch it for you. The advantage of this
is that you can then access Handshake Websites without having to change your browser's configuration in any way.

The disadvantage is that, due to the complexity of modern websites, this technique often does not correctly display modern sites.

So its a quick & easy way to get access to a Handhsake web site, but may not always work.

If you are running this container on your desktop, you should be able to access the Website Proxy Service at the following URL

	https://wwwhns.regserv.net/


## Some Handshake Websites to try out

- http://namebase/
- http://humbly/
- http://welcome.nb/
