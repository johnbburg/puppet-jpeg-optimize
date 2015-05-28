class jpeg-optimize::optimize($release = "1.4.3") {

  $url = "https://github.com/tjko/jpegoptim/archive/RELEASE.${release}.tar.gz"
  $filename = "RELEASE.${release}"


  package { "libjpeg-turbo-devel":
    ensure => installed,
  }

  notify {"wget --directory-prefix=/tmp/vagrant-cache ${url}": }

  exec { "jpeg-optimize::optimize::download":
    command => "wget --directory-prefix=/tmp/vagrant-cache ${url}",
    path => "/usr/bin",
    require => [ File["/tmp/vagrant-cache"] ],
    creates => "/tmp/vagrant-cache/${filename}",
    timeout => 4800,
  }

  notify {"tar -zxvf /tmp/vagrant-cache/${filename} -C /opt": }

  exec { "jpeg-optimize::optimize::extract":
    command => "tar -zxvf /tmp/vagrant-cache/${filename} -C /opt",
    path    => "/bin",
    require => Exec["jpeg-optimize::optimize::download"],
    creates => "/opt/jpegoptim-RELEASE.${release}/README",
  }

  notify{"/opt/jpegoptim-RELEASE.${release}/configure": }

  exec { "jpeg-optimize::optimize::configure":
    command => "sh /opt/jpegoptim-RELEASE.${release}/configure",
    require => Exec["jpeg-optimize::optimize::extract"],
    creates => "/opt/jpegoptim-RELEASE.${release}/Makefile"
  }

  notify {"make -C /opt/jpegoptim-RELEASE.${release}/": }

  exec { "jpeg-optimize::optimize::make":
    command => "make -C /opt/jpegoptim-RELEASE.${release}/",
    path => "/usr/bin",
    require => Exec["jpeg-optimize::optimize::configure"],
    creates => "/opt/jpegoptim-RELEASE.${release}/jpegoptim"
  }

}

