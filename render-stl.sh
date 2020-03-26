#!/bin/bash

targetDir=$1
stlFile=$2
previewFile=$3
targetMarkdown=$4

if [ -f $targetDir/$previewFile ];
then
    echo "skipping $previewFile"
else 

     /opt/blender/blender-2.82a-linux64/blender /opt/render/render-20x20.blend --python /opt/render/render-all.py -b -- $stlFile

    convert $previewFile -resize 256x $(basename $previewFile .png)-sm.png

    mv *.png $targetDir
fi