# Docker Blender STL Render

My forganization of `.stl` and `.blend` files is the following.
I have a folder called `stl/`, with the following content structure:

```
categoryX/
    projectA/
        myFile.blend
        someFile.stl
        anotherFile.stl
        ...
    projectB/
        aFile.blend
        someFile2.stl
        ...
    ...
categoryY/
    projectC/
    projectD/
    ...
...
```

Which means, each project is in a category, and has a single blender source file `.blend` and multiple resulting `.stl` files.

I use the following docker container to render the `.stl` files to `.png` previews, and a Markdown file for description, which I embedd in my blog via Jekyll.

## Setup

Get the Blender archive:

    wget https://ftp.nluug.nl/pub/graphics/blender/release/Blender2.82/blender-2.82a-linux64.tar.xz

Build the docker container:

    docker build -t dbr .

## Run

Run the image and mount the directory you want to render:

    docker run --rm -it -v .../path/...to/.../stl/:/opt/render/files dbr /opt/render/render-md.sh