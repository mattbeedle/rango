#!/bin/sh

# clone submodules
echo "Updating submodules ..."
git submodule init
git submodule update

# setup RUBYLIB
echo "setup RUBYLIB variable ..."
for libdir in vendor/*/lib
  do RUBYLIB="$libdir:$RUBYLIB"
done

echo "Running specs ..."
if [[ "$#" = "0" ]] ; then
  exec ./script/spec --options spec/spec.opts spec
else
  exec ./script/spec --options spec/spec.opts $*
fi
