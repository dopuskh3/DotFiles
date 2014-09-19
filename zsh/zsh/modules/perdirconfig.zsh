

function chpwd() {
  dir=$PWD
  e=20
  while true; do
    [ "$dir" = "/" ] && break
    [ $e -lt 0 ] && echo "Max level of recursion found" && break
    zsh_file=$dir/.zsh
    if [ -f $zsh_file ]; then
      echo "Sourcing $zsh_file"
      source $zsh_file
    fi
    dir=`readlink -f ${dir}/../`
  done
}
