#!/bin/bash

cd /opt/render/files

DEFAULT_DATE=$(date "+%Y-%m-%d")

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
                PREVIEWS_FILE="thing.previews"
                PREVIEW_FILE="thing.preview"

                echo "" > $PREVIEWS_FILE

                for stl in $(find ./ -iname "*.stl" | sort -n); do
                    STL=$(basename $stl .stl)
                    CDIR=$(pwd);
                    taretDir=$CATEGORY/$PROJECT/
                    stlFile=$stl
                    previewFile=$STL-diagonal.jpg
                    echo "{% include preview-stl.html \
                        src=\"/things/$CATEGORY/$PROJECT/$STL-diagonal-sm.jpg\" \
                        lg=\"/things/$CATEGORY/$PROJECT/$STL-diagonal.jpg\" \
                        href=\"/things/$CATEGORY/$PROJECT/$STL.stl\" \
                        blend=\"/things/$CATEGORY/$PROJECT/$B.blend\"
                        title=\"$STL.stl\" %}" >> $PREVIEWS_FILE
                    cd ../../
                    bash /opt/render/render-stl.sh $taretDir $stlFile $previewFile
                    previewFile="$STL-diagonal-sm.jpg"
                    cd $CDIR
                done

                DATE_FILE="thing.date"
                if [ ! -f $DATE_FILE ];
                then
                    echo $DEFAULT_DATE > $DATE_FILE
                fi
                MD_FILE="$(cat thing.date)-$PROJECT.md"
                TITLE_FILE="thing.title"
                DESCR_FILE="thing.descr"
                DESCRIPTION_FILE="thing.description"
                
                # create defaults

                if [ ! -f $TITLE_FILE ];
                then
                    echo "$PROJECT" > $TITLE_FILE
                fi

                if [ ! -f $DESCR_FILE ];
                then
                    echo "Yet another STL file." > $DESCR_FILE
                fi

                if [ ! -f $DESCRIPTION_FILE ];
                then
                    echo "This thing has no description." > $DESCRIPTION_FILE
                fi

                if [ ! -f $PREVIEW_FILE ];
                then
                    echo "$previewFile" > $PREVIEW_FILE
                fi

                echo "---" > $MD_FILE
                echo "category: thing" >> $MD_FILE
                echo "thing_category: $CATEGORY" >> $MD_FILE
                echo "title: $(tail $TITLE_FILE)" >> $MD_FILE
                echo "layout: post" >> $MD_FILE
                echo "description: $(tail $DESCR_FILE)" >> $MD_FILE
                echo "previewPath: /things/$CATEGORY/$PROJECT/$(tail $PREVIEW_FILE)" >> $MD_FILE
                echo "---" >> $MD_FILE
                cat $DESCR_FILE >> $MD_FILE
                echo "" >> $MD_FILE
                echo "#### STL files" >> $MD_FILE
                cat $PREVIEWS_FILE >> $MD_FILE
                echo "" >> $MD_FILE
                echo "#### Description" >> $MD_FILE
                echo "" >> $MD_FILE
                cat $DESCRIPTION_FILE >> $MD_FILE
                echo "#### Source file" >> $MD_FILE
                echo "[$B.blend](/things/$CATEGORY/$PROJECT/$B.blend)" >> $MD_FILE
                echo "<br/><br/><small>You can edit this with Blender. You can get it here: [https://blender.org](https://blender.org)</small>" >> $MD_FILE
                echo "" >> $MD_FILE
                cd ..
            fi
        done
        cd ..
    fi
done