# Docker Blender STL Render

My organization of `.stl` and `.blend` files is the following.
I have a folder called `things/`, with the following content structure:

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

I use the following docker container to render the `.stl` files to `.png` previews, and a Markdown file for Jekyll for each project, which I then embedd in my blog via Jekyll.

For each project the following files are initialized:

- `thing.date`: todays date
- `thing.descr`: "Yet another STL file."
- `thing.description`: "This thing has no description."
- `thing.preview`: the last preview image file name (*.jpg)
- `thing.title`: taken from the parent directory

... and the following file is overwritten every time:

- `thing.previews`: the jekyll template generated to display stl previews, see **_include/preview-stl.html

You can modify the `thing.*` to change the respective values when re-running the container across your files/folders.

## Setup

Get the Blender archive:

    wget https://ftp.nluug.nl/pub/graphics/blender/release/Blender2.82/blender-2.82a-linux64.tar.xz

Build the docker container:

    docker build -t dbr .

## Run

Run the image and mount the directory you want to render:

    docker run --rm -it -v .../path/...to/.../stl/:/opt/render/files dbr /opt/render/render-md.sh