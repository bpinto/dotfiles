#!/bin/bash

[ $# -ne 4 ] && echo "Usage: $0 cat/package sandbox_user sandbox_user_home user" && exit 1

pkg=$1
sbuser=$2
home=$3
user=$4

useradd --home=$home --create-home --shell /bin/false --user-group $sbuser
chgrp $user $home
chmod 770 $home

echo "$user ALL=($sbuser) NOPASSWD: ALL" > /etc/sudoers.d/$sbuser

qlist "$pkg" | xargs chmod u-x,g-w,o-o
qlist "$pkg" | xargs chown root:$sbuser

bashrc="/etc/portage/env/$pkg"

mkdir -p $(dirname $bashrc)

echo "post_src_install() {
  chmod -R u-x,g-w,o-o \${D}
  chown -R root:$sbuser \${D}
}" > $bashrc
