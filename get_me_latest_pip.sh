#!/bin/bash

wget -O get-pip.py https://bootstrap.pypa.io/get-pip.py
chmod a+x get-pip.py
python get-pip.py
rm get-pip.py
