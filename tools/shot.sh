#!/bin/bash
# shot.sh NAME -> PPM-Screenshot nach PNG
D=/home/user/lithos/shots; echo "screendump /tmp/$1.ppm" | socat - UNIX-CONNECT:/tmp/qmon.sock >/dev/null; sleep 1
python3 -c "from PIL import Image; Image.open('/tmp/$1.ppm').save('$D/$1.png')" && echo $D/$1.png
