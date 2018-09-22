#!/bin/zsh
echo "Creating symbolic links in home directory"
if [[ $1 == "--backup" ]]; then
	b="-b"
	echo "Found --backup option, conflicting files will be backed up"
fi

((i=0))
dir=$(pwd)
for file in .*(.); do
	echo "["$i"]" $file
	((i++))

	ln -fns $b -t ~ $dir/$file
done

echo "\nSetup complete"
