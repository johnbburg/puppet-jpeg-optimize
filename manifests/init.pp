class jpeg-optimize ($release = "1.4.3") {

  $url = "https://github.com/tjko/jpegoptim/archive/RELEASE.${release}.tar.gz"
  $filename = "jpegoptim-RELEASE.${release}.tar.gz"


  package { "libjpeg-turbo-devel":
    ensure => installed,
  }

  exec { "jpeg-optimize::download":
    command => "wget -O ${filename} --directory-prefix=/tmp/vagrant-cache ${url}",
    path => "/usr/bin/",
    creates => "/tmp/vagrant-cache/${filename}",
    timeout => 4800,
  }

  exec { "jpeg-optimize::extract":
    command => "tar -zxvf /tmp/vagrant-cache/${filename} -C /opt",
    path    => "/bin",
    require => [Exec["jpeg-optimize::download"]],
    creates => "/opt/jpegoptim-RELEASE.${release}/README",
  }

  exec { "jpeg-optimize::configure":
    command => "/opt/jpegoptim-RELEASE.${release}/configure",
    require => "[Exec[jpeg-optimize::extract]]",
    creates => "/opt/jpegoptim-RELEASE.${release}/Makefile"
  }

  exec { "jpeg-optimize::make":
    command => "make -C /opt/jpegoptim-RELEASE.${release}/",
    path => "/usr/bin",
    require => "[Exec[jpeg-optimize::configure]]",
    creates => "/opt/jpegoptim-RELEASE.${release}/jpegoptim"
  }

}

