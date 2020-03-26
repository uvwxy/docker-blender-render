FROM debian:10-slim
LABEL maintainer="code@uvwxy.de"

RUN apt-get update
RUN apt-get install -y libx11-6 libxi6 libxxf86vm1 libxfixes3 libxrender1 libgl1 imagemagick

ADD blender-2.82a-linux64.tar.xz /opt/blender/
ADD get-pip.py /opt/blender/blender-2.82a-linux64/2.82/python/bin

ADD get-pip.py /opt/blender/blender-2.82a-linux64/2.82/python/bin
RUN /opt/blender/blender-2.82a-linux64/2.82/python/bin/python3.7m /opt/blender/blender-2.82a-linux64/2.82/python/bin/get-pip.py 
RUN /opt/blender/blender-2.82a-linux64/2.82/python/bin/pip install Pillow

RUN mkdir /opt/render/
RUN mkdir /opt/render/files/
ADD render-* /opt/render/
RUN chmod +x /opt/render/render-md.sh

