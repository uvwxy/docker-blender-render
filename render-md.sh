#!/bin/bash

cd /opt/render/files

DEFAULT_DATE="2020-01-01"

for CATEGORY in $(ls | sort -n); do
    if [ -d $CATEGORY ]; then

        cd $CATEGORY
        for PROJECT in $(ls | sort -n); do
            if [ -d $PROJECT ];
            then
                cd $PROJECT
                echo "checking folder $PROJECT"

                 # find the blend file
                B=$(basename *.blend .blend)
                previewFile=""

                for stl in $(find ./ -iname "*.stl" | sort -n); do
                    STL=$(basename $stl .stl)
                    CDIR=$(pwd);
                    taretDir=$CATEGORY/$PROJECT/
                    stlFile=$stl
                    previewFile=$STL-diagonal.jpg
                    cd ../../
                    bash /opt/render/render-stl.sh $taretDir $stlFile $previewFile
                    cd $CDIR
                done

                DATE_FILE="thing.date"
                if [ ! -f $DATE_FILE ];
                then
                    echo $DEFAULT_DATE > $DATE_FILE
                fi
                MD_FILE="$(cat thing.date)-thing.md"
                TITLE_FILE="thing.title"
                DESCR_FILE="thing.descr"
                DESCRIPTION_FILE="thing.description"
                
                if [ ! -f $TITLE_FILE ];
                then
                    echo "$PROJECT" > $TITLE_FILE
                fi

                if [ ! -f $DESCR_FILE ];
                then
                    echo "Yet another STL file." > $DESCR_FILE
                fi
                
                rm *-thing.md

                echo "---" > $MD_FILE
                echo "category: thing" >> $MD_FILE
                echo "thing_category: $CATEGORY" >> $MD_FILE
                echo "title: $(tail $TITLE_FILE)" >> $MD_FILE
                echo "layout: post" >> $MD_FILE
                echo "description: $(tail $DESCR_FILE)" >> $MD_FILE
                echo "previewPath: /$CATEGORY/$PROJECT/$previewFile" >> $MD_FILE
                echo "---" >> $MD_FILE
                if [ -f $DESCRIPTION_FILE ];
                then
                    cat $DESCRIPTION_FILE >> $MD_FILE
                fi

                cd ..
            fi
        done
        cd ..
    fi
done