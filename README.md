Install and bootstrap an NGINX instance
puppet module install puppet-healthcheck --version 1.0.1

- Create a proxy to redirect requests for https://domain.com to 10.10.10.10 and redirect requests for https://domain.com/resource2 to 20.20.20.20.
- Create a forward proxy to log HTTP requests going from the internal network to the Internet including: request protocol, remote IP and time take to serve the request.
- Implement a Proxy health check


I used the Nginx module for Puppet found here: https://github.com/voxpupuli/puppet-nginx
Install it with puppet module install puppet-nginx 

You could execute the manifests locally (on your computer, a virtual machine, depending on your configuration) with the necessary permissions (use sudo if necessary or as root if you require) with puppet apply --modulepath=path-to-your-modulepath path-to-manifest.pp

The first instruction is executed by proyxy-r.pp (reversy proxy) and the second instruction is executed by proxy-f.pp (forward request)

In order to test the forward proxy you can point a web browser to use the proxy called localhost (on the local host!) on port 8080 by default, or you could use any other custom port like 5602, for this particular example. 
It's always a better practice having a log file , normally using a default location such as /var/log/nginx/logfile.log).
#TIP: really handy to troubleshoot any possible furtrher issue.

#Example Config:
include nginx
A simple reverse proxy
nginx::resource::server { 'domain.com':
  listen_port => 80,
  proxy       => 'http://localhost:5602',
}

I haven't added any other required configuration files like syslog, hieradata, smtp, etc.
https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/


About the healthcheck I have used 2 different defined types to do it.
First one with haproxy::balancermember to enable the health check
https://github.com/puppetlabs/puppetlabs-haproxy/blob/main/REFERENCE.md#listening_service
2nd one it's about http_conn_validator that verifies that an http server is answering on a given port. It could be used to test either a remote or a local service. IPv4 and IPv6 connection strings are supported. It also works with hostname.
https://forge.puppet.com/modules/puppet/healthcheck 

