#!/bin/bash
git_extras=https://github.com/visionmedia/git-extras
mydir=`dirname $(readlink -f $0)`
config=git-extras.conf

pushd $mydir

[ -e git-extras ] && rm -rf git-extras
git clone $git_extras git-extras

echo "[alias]" > $config
for tool in git-extras/bin/git-*; do
  tool_file=`basename $tool`
  tool_path=`readlink -f $tool`
  tool_name=`echo $tool_file | sed 's/^git-//g'`
  echo "   $tool_name =  !\"$tool_path\"" >> $config
done

