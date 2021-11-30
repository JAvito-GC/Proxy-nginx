class{"nginx":
    manage_repo => true,
    package_source => 'nginx-mainline'

}

  nginx::resource::server{'domain.com':
    listen_port => 80,
    proxy       => 'http://10.10.10.10:80'
  }

  nginx::resource::location{'/resource2':
    proxy => 'http://20.20.20.20:80/' ,
    server => 'domain.com',
  }

  http_conn_validator { 'domain.com' :
  host     => '127.0.0.1',
  port     => 80,
  use_ssl  => true,
  test_url => /
}