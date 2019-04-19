#!/bin/sh

# Create directories in root, and ensure rights
# Root parameter can be passed as $1
ROOT="$1"

# See: https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard

mkdir -p $ROOT/{dev,proc,sys,run}
mknod -m 600 $ROOT/dev/console c 5 1
mknod -m 666 $ROOT/dev/null c 1 3

# handle multilib
case $(uname -m) in
	x86_64) 
		mkdir -p $ROOT/lib32 $ROOT/lib64 $ROOT/usr/lib32 $ROOT/usr/lib64
		ln -snf $ROOT/lib lib64
		ln -snf $ROOT/usr/lib lib64
		;;
	*)
		mkdir -p $ROOT/lib $ROOT/usr/lib
		;;
esac

mkdir -p $ROOT/{bin,boot,etc,home,lib/firmware,mnt,opt,pkg,sbin,var,media}
mkdir $ROOT/root
chmod 0750 $ROOT/root

mkdir -p $ROOT/tmp $ROOT/var/tmp
chmod 01777 $ROOT/tmp $ROOT/var/tmp

mkdir -p $ROOT/usr/{bin,include,sbin,src,libexec}
mkdir -p $ROOT/usr/share/{color,dict,doc,info,locale,man,misc,terminfo,zoneinfo}
mkdir -p $ROOT/usr/share/man/man{1..8}

mkdir -p $ROOT/var/{log,mail,spool,cache,lib/{color,misc,locate},lock}
ln -snf /run $ROOT/var/run
ln -snf /run/lock $ROOT/var/lock
