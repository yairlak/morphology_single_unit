#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Oct 15 13:52:19 2021

@author: yl254115
"""

import os
from PIL import Image, ImageDraw, ImageFont

# PATHs
path2stimuli = '../../stimuli/single_letters.txt'
path2images = '../../stimuli/images/single_letters/'
os.makedirs(path2images, exist_ok=True)

# FONTS AND TEXT sIZE
fonts = ['LiberationMono-Regular.ttf', 'AlexBrush-Regular.ttf']
sizes = [50, 50]
positions = ['left', 'right'] # left/right/center
dx = 150 # number of pixels used to shift text from center

# LOAD STIMULI
with open(path2stimuli, 'r') as f:
    letters = f.readlines()
letters = [l.strip('\n') for l in letters]

# GENERATE FIGURES
W, H = (500, 500)
for l in letters:
    for font, size in zip(fonts, sizes):
        for upper in [False, True]:
            if upper:
                l = l.upper()
            else:
                l = l.lower()
                size = int(2*size)
            print(f'{l}, {font}')
            for position in positions:
                image_font = ImageFont.truetype(font=font, size=size)
                img = Image.new('RGB', (W, H), color='black')
                d = ImageDraw.Draw(img)
                image_font = ImageFont.truetype(font=font, size=size)
                w, h = d.textsize(l)
                
                x = (W-w)/2
                y = (H-h)/2
                if position == 'left':
                    x -= dx
                elif position == 'right':
                    x += dx
                elif position == 'center':
                    x = x
                else:
                    raise(f'Unknown position label: {position}')
        
                
                d.text((x,y),
                       l,
                       font=image_font,
                       fill='white',
                       align='center')
                
                # SAVE IMAGE
                fn = f'{l}_{position}_{font}'
                if upper:
                    fn += '_upper'
                else:
                    fn += '_lower'
                img.save(os.path.join(path2images, fn + '.png'))