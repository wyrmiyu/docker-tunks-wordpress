#!/usr/bin/env perl

use strict;
use warnings;

sub create_rand
{ 
  my ($bytes, $chars) = @_;
  my @chars = @$chars;
  join "", map $chars[ rand @chars ], 1 .. $bytes;
}
my @wp_secrets = (
  "AUTH_KEY",
  "SECURE_AUTH_KEY",
  "LOGGED_IN_KEY",
  "NONCE_KEY",
  "AUTH_SALT",
  "SECURE_AUTH_SALT",
  "LOGGED_IN_SALT",
  "NONCE_SALT",
);
my @chars = ("a" .. "z", "A" .. "Z", 0 .. 9);
my @salt_chars = (@chars, split(//, '!@#$%^&*()-_[]{}<>~\+=,.;:/?|'));
my $version_str = qx(curl -Ls https://wordpress.org/latest.tar.gz | tar -xzOf - wordpress/wp-includes/version.php);
my ($version) = ($version_str =~ /wp_version\s=\s'([0-9\.]+?)'/);
my $sha1sum = (split / /, qx(curl -Ls https://wordpress.org/latest.tar.gz | sha1sum))[0];
print("WORDPRESS_VERSION=", $version, "\n");
print("WORDPRESS_SHA1=", $sha1sum, "\n");
print("MYSQL_ROOT_PASSWORD=", create_rand(32, \@chars), "\n");
print("WORDPRESS_TABLE_PREFIX=", create_rand(8, \@chars), "_\n");
print("WORDPRESS_DEBUG=FALSE\n");
foreach my $env (@wp_secrets) {
  print("$env=", create_rand(64, \@salt_chars), "\n");
}
print("#\n# CHANGE FOLLOWING TO MATCH YOUR SETUP!\n#\n");
print("EXTERNAL_HOST_IP=127.0.0.1\n");
print("EXTERNAL_HOST_PORT=8080\n");
print("SVCUSER=www-data\n");
print("SVCGROUP=www-data\n");
print("SVCUID=33\n");
print("SVCGID=33\n");