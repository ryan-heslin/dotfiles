if [ -f $HOME/.bash_profile ]; then
    . $HOME/.bash_profile
else
	echo "Problem reading .bash_profile"
fi
