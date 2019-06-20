if [ $# -ne 1 ]; then
    echo "Please type in inode number"
    echo "Use ls -il to get inode of file"
    exit 1
fi

inode=$1

find . -inum $inode -exec rm -i {} \;

 gcc -march=native -E -v - </dev/null 2>&1 | grep cc1
