name "msttcorefonts"
maintainer "Giovanni Intini"
maintainer_email "giovanni@mikamai.com"
license "Apache 2.0"
description "Installs Microsoft corefonts on linux boxes"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version "0.1"

depends "apt"

supports "ubuntu", ">= 10.04"
