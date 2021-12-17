#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Oct 15 13:52:19 2021

@author: yl254115
"""

import os
from PIL import Image, ImageDraw, ImageFont

# PATHs
ngram = 'unigrams' # unigrams/ngrams/pseudowords
path2stimuli = f'../../stimuli/{ngram}.csv'
path2images = f'../../stimuli/visual/{ngram}/'
os.makedirs(path2images, exist_ok=True)

# FONTS AND TEXT SIZE

scale_factor = 1
fonts = ['LiberationMono-Regular.ttf', 'AlexBrush-Regular.ttf']
sizes = [scale_factor*50, scale_factor*50]
size_fixation = 15*scale_factor
positions = ['left', 'right', 'center'] # left/right/center
positions = ['center'] # left/right/center
dx = scale_factor*50 # number of pixels used to shift text from center

# LOAD STIMULI
with open(path2stimuli, 'r') as f:
    letters = f.readlines()
letters = [l.strip('\n') for l in letters]
letters += ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0']

# SCALE FONT
def get_scale_factor_for_font(font):
    if font == 'AlexBrush-Regular.ttf':
        factor = 2
    elif font == 'LiberationMono-Regular.ttf':
        factor = 1
    else:
        factor = 1
        raise(f'Unkwnown font name {font}')
    return factor


def get_text_dimensions(text_string, font):
    # https://stackoverflow.com/a/46220683/9263761
    ascent, descent = font.getmetrics()

    text_width = font.getmask(text_string).getbbox()[2]
    text_height = font.getmask(text_string).getbbox()[3] + descent

    return (text_width, text_height)


# GENERATE FIGURES
W, H = (600*scale_factor, 600*scale_factor)
for l in letters:
    for font, size in zip(fonts, sizes):
        for upper in [False, True]:
            if upper:
                l = l.upper()
                size_corrected = size
            else:
                l = l.lower()
                # scale up lower case letters
                letter_scale_factor = 1
                letter_scale_factor = get_scale_factor_for_font(font)
                size_corrected = letter_scale_factor*size
            for position in positions:
                image_font = ImageFont.truetype(font=font, size=size_corrected)
                img = Image.new('RGB', (W, H), color='black')
                d = ImageDraw.Draw(img)
                # w, h = d.textsize(l)
                w, h = get_text_dimensions(l, image_font)
                y = H/2# - h/2
                if position == 'left':
                    x = W/2 - dx
                elif position == 'right':
                    x = W/2 + dx
                elif position == 'center':
                    x = W/2# - w/2
                else:
                    raise(f'Unknown position label: {position}')
        
                
                d.text((x,y),
                       l,
                       font=image_font,
                       fill='white',
                       anchor='ms')
                print(f'{l}, {upper}, {font}, {size}, {x}, {y}, {w}, {h}')    
                 
                # ADD FIXATION AT THE CENTER
                if position != 'center':
                    image_font = ImageFont.truetype(font='LiberationMono-Regular.ttf', size=size_fixation*scale_factor)
                    d = ImageDraw.Draw(img)
                    w, h = d.textsize(l)
                    y = H/2
                    x = W/2

                    d.text((x, y),
                           '+',
                           font=image_font,
                           fill='white',
                           anchor='mm')
                # SAVE IMAGE
                fn = f'{l.lower()}_{position}_{font}'
                if upper:
                    fn += '_upper'
                else:
                    fn += '_lower'
                img.save(os.path.join(path2images, fn + '.png'))

# IMAGE FIXATION ONLY
img = Image.new('RGB', (W, H), color='black')
image_font = ImageFont.truetype(font='LiberationMono-Regular.ttf', size=size_fixation*scale_factor)
d = ImageDraw.Draw(img)
w, h = d.textsize(l)
w, h = get_text_dimensions(l, image_font)
                
y = H/2
x = W/2

d.text((x, y),
       '+',
       font=image_font,
       fill='white',
       anchor='ms')
# SAVE IMAGE
fn = 'fixation'
img.save(os.path.join(path2images, '..', fn + '.png'))
