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

# FONTS AND TEXT SIZE
fonts = ['LiberationMono-Regular.ttf', 'AlexBrush-Regular.ttf']
sizes = [50, 50]
positions = ['left', 'right'] # left/right/center
dx = 100 # number of pixels used to shift text from center

# LOAD STIMULI
with open(path2stimuli, 'r') as f:
    letters = f.readlines()
letters = [l.strip('\n') for l in letters]

# SCALE FONT
def get_scale_factor_for_font(font):
    if font == 'AlexBrush-Regular.ttf':
        scale_factor = 2
    elif font == 'LiberationMono-Regular.ttf':
        scale_factor = 1.2
    else:
        scale_factor = None
        raise(f'Unkwnown font name {font}')
    return scale_factor


# GENERATE FIGURES
W, H = (600, 600)
for l in letters:
    for font, size in zip(fonts, sizes):
        for upper in [False, True]:
            if upper:
                l = l.upper()
                size_corrected = size
            else:
                l = l.lower()
                # scale up lower case letters
                scale_factor = get_scale_factor_for_font(font)
                size_corrected = int(scale_factor*size) 
            for position in positions:
                image_font = ImageFont.truetype(font=font, size=size)
                img = Image.new('RGB', (W, H), color='black')
                d = ImageDraw.Draw(img)
                w, h = d.textsize(l)
                print(f'{l}, {upper}, {font}, {size}, {w}, {h}')    
                y = H/2-h#/2
                if position == 'left':
                    x = W/2 - dx
                elif position == 'right':
                    x = W/2 + dx - w
                elif position == 'center':
                    x = W/2 - w/2
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