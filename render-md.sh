#!/bin/bash

cd /opt/render/files

mdFile="./stl.md"

echo "---" > $mdFile
echo "title: STLs" >> $mdFile
echo "layout: post" >> $mdFile
echo "---" >> $mdFile

# index
echo "## Index" >> $mdFile

# create index
for CATEGORY in $(ls | sort -n); do
    if [ -d $CATEGORY ]; then
        echo "$CATEGORY"
        echo "- [$CATEGORY](#$CATEGORY)" >> $mdFile

        cd $CATEGORY
        for PROJECT in $(ls | sort -n); do
            if [ -d $PROJECT ];
            then
                echo "    $PROJECT"
                cd $PROJECT

                # find the blend file
                B=$(basename *.blend .blend)
                echo "    - [$PROJECT](#$PROJECT)" >> ../../$mdFile

                cd ..
            fi
        done
        cd ..
    fi
done

# intro text
echo "" >> $mdFile
echo "Click on any image for a larger view. Click on the image title to download the STL file." >> $mdFile

echo "## Files" >> $mdFile



# create body
for CATEGORY in $(ls | sort -n); do
    if [ -d $CATEGORY ]; then
        echo "<br/>" >> $mdFile
        echo "## <a name=\"$CATEGORY\"></a> $CATEGORY" >> $mdFile

        cd $CATEGORY
        for PROJECT in $(ls | sort -n); do
            if [ -d $PROJECT ];
            then
                cd $PROJECT
                echo "checking folder $PROJECT"

                 # find the blend file
                B=$(basename *.blend .blend)
                #echo "#### <a name=\"$PROJECT\"></a> $PROJECT" >> ../../$mdFile
    #echo "Source File: [$B.blend](stl/$CATEGORY/$PROJECT/$B.blend)" >> ../../$mdFile

                echo "<hr/><br/>" >> ../../$mdFile
                echo "#### <a name=\"$PROJECT\"></a> $PROJECT" >> ../../$mdFile
                for stl in $(find ./ -iname "*.stl" | sort -n); do
                    STL=$(basename $stl .stl)
                    echo "{% include preview-stl.html \
                     src=\"stl/$CATEGORY/$PROJECT/$STL-diagonal-sm.png\" \
                     lg=\"stl/$CATEGORY/$PROJECT/$STL-diagonal.png\" \
                     href=\"stl/$CATEGORY/$PROJECT/$STL.stl\" \
                     blend=\"stl/$CATEGORY/$PROJECT/$B.blend\"
                     title=\"$STL.stl\" %}" >> ../../$mdFile

                    CDIR=$(pwd);
                    taretDir=$CATEGORY/$PROJECT/
                    stlFile=$taretDir/$stl
                    previewFile=$STL-diagonal.png
                    cd ../../
                    bash /opt/render/render-stl.sh $taretDir $stlFile $previewFile $mdFile
                    cd $CDIR
                done
                cd ..
            fi
        done
        cd ..
    fi
done