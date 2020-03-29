#!/bin/bash

targetDir=$1
stlFile=$2
previewFile=$3
targetMarkdown=$4

PDIR=$(pwd)

if [ -f $targetDir/$previewFile ];
then
    echo "skipping $stlFile"
else 
    cd /opt/render/files/$targetDir/

     /opt/blender/blender-2.82a-linux64/blender -noaudio -b /opt/render/render-20x20.blend --python /opt/render/render-all.py -- $stlFile

    convert  $previewFile -resize 256x  $(basename $previewFile .jpg)-sm.jpg

    cd $PDIR
fi