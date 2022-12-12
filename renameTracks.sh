#/usr/bin/env bash

# Javascript in Flood
# folderTitle = document.querySelector(`button.directory-tree__node`).title;
# tree = document.querySelector(`button[title="${folderTitle}"]`).nextElementSibling; Array.from(tree.querySelectorAll('div.directory-tree__node--file'), e => e.title).join('\n')+'\n';
# Copy paste > $TITLES_FILE

if [ $# -ne 3 ]
then
	echo "Usage: $0 titles_file awk_delimiter awk_return_number"
	exit 1
fi

TITLES_FILE=$1
AWK_DELIM=$2
AWK_NUMBER=$3

while read title
do
	mv *`echo $title | awk -F "$AWK_DELIM" '{ print $'"$AWK_NUMBER"' }'`* $title
done < $TITLES_FILE
