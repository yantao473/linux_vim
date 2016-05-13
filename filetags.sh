# generate tag file for lookupfile plugin

basepath="/data0/sae"

cd $basepath

ls  | while read path
do
    cd $path
    tagfile=".filenametags"
    ctagfile=".tags"

    # if [ ! -s $tagfile ]
    # then
        echo -e "!_TAG_FILE_SORTED\t2\t/2=foldcase/" > $tagfile
        find . -not -iregex '.*\.\(git\|jpg\|png\|gif\)' -type f -printf "%f\t%p\t1\n" |  sort -f >> $tagfile
    # fi

    # if [ ! -s $ctagfile ]
    # then
        ctags \
            -f $ctagfile\
            -R -h ".php" \ 
            --exclude="\.git|\.swp|\.swo|\.png|\.jpg|\.gif|" \
            --regex-php="/^[ \t]*[(private|public|static)( \t)]*function[ \t]+([A-Za-z0-9_]+)[ \t]*\(/\1/f, function, functions/" \
            --regex-php="/^[ \t]*[(private| public|static)]+[ \t]+\$([A-Za-z0-9_]+)[ \t]*/\1/p, property, properties/" \
            --regex-php="/^[ \t]*(const)[ \t]+([A-Za-z0-9_]+)[ \t]*/\2/d, const, constants/" \
            --languages=php 
    # fi

    cd -
done

