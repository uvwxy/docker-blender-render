import bpy
import sys
from PIL import Image, ImageDraw, ImageFont

def renderAndSaveCamera ( cameraName, fileName):
    bpy.context.scene.camera = bpy.data.objects[cameraName]
    bpy.context.scene.render.filepath = './' + fileName + '-' + cameraName
    bpy.context.scene.render.image_settings.file_format='PNG'
    bpy.ops.render.render(use_viewport=False, write_still=True)

def prepareObject(selected):    
    bpy.ops.object.origin_set(type='ORIGIN_CENTER_OF_MASS', center='MEDIAN')
    bpy.ops.object.align(align_mode='OPT_2', relative_to='OPT_1', align_axis={'X'})
    bpy.ops.object.align(align_mode='OPT_2', relative_to='OPT_1', align_axis={'Y'})
    bpy.ops.object.align(align_mode='OPT_1', relative_to='OPT_1', align_axis={'Z'})

    mat = bpy.data.materials.get("thing-material")
    if mat is None:
        raise Exception("Material not found!")
    
    selected.data.materials.append(mat)

argv = sys.argv
argv = argv[argv.index("--") + 1:]  # get all args after "--"

inputFile = argv[0]

print("Will render file", inputFile)

if inputFile:
    bpy.ops.import_mesh.stl(filepath=inputFile)

if len(bpy.context.selected_objects) == 1:
    selected=bpy.context.selected_objects[0]
    # blender does some camel case magic with file names
    selected.name = selected.name.lower()
    # center object, apply material
    prepareObject(selected)
    
    print('creating render for ' + selected.name)
    
    bpy.context.scene.render.resolution_x=1024
    bpy.context.scene.render.resolution_y=1024
    
    renderAndSaveCamera("diagonal", selected.name)
    
    # combine cameras
    # finalWidth = bpy.context.scene.render.resolution_x*2
    # finalHeight = bpy.context.scene.render.resolution_y*2
    # combinedImage = Image.new('RGB', (finalWidth,finalHeight))

    # im=Image.open('./' + selected.name + '-right.png')
    # combinedImage.paste(im, (0,0))
    # im=Image.open('./' + selected.name + '-diagonal.png')
    # combinedImage.paste(im, (0,bpy.context.scene.render.resolution_y))
    # im=Image.open('./' + selected.name + '-front.png')
    # combinedImage.paste(im, (bpy.context.scene.render.resolution_x,0))
    # im=Image.open('./' + selected.name + '-top.png')
    # combinedImage.paste(im, (bpy.context.scene.render.resolution_x,bpy.context.scene.render.resolution_y))
    
    # add label
    # draw = ImageDraw.Draw(combinedImage)
    # msg = selected.name + ".stl"
    # font = ImageFont.truetype("./SourceCodePro-Regular.ttf", 24)
    # w, h = draw.textsize(msg, font)
    # draw.text((finalWidth/2 - w/2, 24), msg, font=font, fill="black")

    # save
    # combinedImage.save('./' + selected.name + '-combined.png')
else:
    print('Please select a single object')

if inputFile:
    bpy.ops.wm.quit_blender()