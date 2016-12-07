#!/bin/sh


basepath="/data0/sae"
cd $basepath

gentags()
{
    tf="$1/.filenametags"
    ctf="$1/.tags"

    echo $1
    cd $1

    echo -e "!_TAG_FILE_SORTED\t2\t/2=foldcase/" > $tf

    find -not -iregex '.*\.\(jpg\|png\|gif\)' -type f -printf "%f\t%p\t1\n" | grep -v '.git'  |  sort -f >> $tf

   ctags \
       -f $ctf \
       -R \
       --exclude=.git \
       --exclude=*.min.js \
       --exclude=bower_components/* \
       --exclude=node_modules/* \
       --exclude=*.css \
       --exclude=*.jpg \
       --exclude=*.gif \
       --exclude=*.bmp \
       --exclude=test \
       --fields=+iaS\
       --extra=+qf \
       2>/dev/null

}


if [ "x${1}x" != "xx" ]
then
    gentags "$basepath/$1"
else
    ls  | while read propath
    do
        gentags "$basepath/$propath"
    done
fi
