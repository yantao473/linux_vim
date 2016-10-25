#!/bin/sh

basepath="/data0/sae"

cd $basepath

ls  | while read path
do
    cd $path
    tagfile=".filenametags"
    ctagfile=".tags"

    echo -e "!_TAG_FILE_SORTED\t2\t/2=foldcase/" > $tagfile
    find . -not -iregex '.*\.\(git\|jpg\|png\|gif\)' -type f -printf "%f\t%p\t1\n" |  sort -f >> $tagfile
    ctags -f $ctagsfile -R --c++-kinds=+p --fields=+iaS --extra=+qf 2>/dev/null
    cd -
done
