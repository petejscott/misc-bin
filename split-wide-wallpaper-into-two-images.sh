#!/bin/bash

# some setup
wallpaperSourceDir=$HOME/Pictures/Wallpaper/dm
tmp=$wallpaperSourceDir/tmp
destinationDirForLeft="$wallpaperSourceDir/L_USE"
destinationDirForRight="$wallpaperSourceDir/R_USE"
timestamp=$(date +%s)

unset -v oldestImage

# select random wallpaper image from source directory
randomImage=`/bin/ls -1 "$wallpaperSourceDir" | sort --random-sort | grep ".jpg$" | head -1`;
randomImagePath=`readlink --canonicalize "$wallpaperSourceDir/$randomImage"`;

for image in "$destinationDirForLeft"/*.jpg; do

	[[ -z $oldestImage || $image -ot $oldestImage ]] && oldestImage=$image

done

echo "Will replace ${oldestImage##*/} with $randomImage";

# split our random image
convert $wallpaperSourceDir/$randomImage -crop 50%x100% +repage $tmp/wp_%d.jpg;
CONVERSION_RESULT=`echo $?`;

if [[ $CONVERSION_RESULT -eq 0 ]]; then

        rm $destinationDirForLeft/${oldestImage##*/};
        rm $destinationDirForRight/${oldestImage##*/};

	# move left (0) into proper folder
	mv $tmp/wp_0.jpg $destinationDirForLeft/wp.$timestamp.jpg;

	# move right (1) into proper folder
	mv $tmp/wp_1.jpg $destinationDirForRight/wp.$timestamp.jpg;

else
	echo "Conversion Failed ($CONVERSION_RESULT)";
fi;

exit 0;
