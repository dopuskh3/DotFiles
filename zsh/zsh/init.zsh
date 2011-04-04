
for i in $HOME/.zshrc_local $HOME/.zlocal; do
if [ -e $i ]; then 
	mylog "Sourcing $i" 
	source $i
fi 
done


if swhich keychain; then
  mylog "Adding keychain..."
  keychain -q id_rsa 
	host=`uname -n ` 
	[ -f $HOME/.keychain/$host-sh ] && source $HOME/.keychain/$host-sh
fi

logscreens


