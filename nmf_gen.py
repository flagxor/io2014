#!/usr/bin/python

import os

data = open('voronoi.nmf.template').read()

code = '150657dc'
for item in os.listdir('lib32'):
  if item.startswith('libm.so.'):
    code = item[len('libm.so.'):]

with open('voronoi.nmf', 'w') as fh:
  fh.write(data % {'code': code})
