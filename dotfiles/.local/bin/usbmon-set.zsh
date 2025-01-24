#!/usr/bin/env zsh

emulate -L zsh

fset()
{
    local DEV="/dev/usb/hiddev0"
    usbmonctl -s F,"$@" $DEV
}

fset 0x16=227   # Red gain
fset 0x18=222   # Green gain
fset 0x1A=217   # Blue gain
fset 0x12=180   # Contrast

# /dev/usb/hiddev0: Samsung Electronics Sam Sung Electronics (0x0419:0x8002) v2.00
# OUTPUT : 0x01 - Degauss
#   field 0, flags=2, range=0..1
#       usage 0 = 0 (0x0)
# FEATURE: 0x10 - Brightness
#   field 0, flags=2, range=0..40
#       usage 0 = 0 (0x0)
# FEATURE: 0x12 - Contrast
#   field 0, flags=2, range=0..255
#       usage 0 = 179 (0xb3)
# FEATURE: 0x16 - Red Video Gain
#   field 0, flags=2, range=0..255
#       usage 0 = 107 (0x6b)
# FEATURE: 0x18 - Green Video Gain
#   field 0, flags=2, range=0..255
#       usage 0 = 102 (0x66)
# FEATURE: 0x1a - Blue Video Gain
#   field 0, flags=2, range=0..255
#       usage 0 = 97 (0x61)
# FEATURE: 0x22 - Horizontal Size
#   field 0, flags=2, range=0..200
#       usage 0 = 92 (0x5c)
# FEATURE: 0x20 - Horizontal Position
#   field 0, flags=2, range=0..200
#       usage 0 = 200 (0xc8)
# FEATURE: 0x32 - Vertical Size
#   field 0, flags=2, range=0..127
#       usage 0 = 109 (0x6d)
# FEATURE: 0x30 - Vertical Position
#   field 0, flags=2, range=0..100
#       usage 0 = 63 (0x3f)
# FEATURE: 0x44 - Tilt (Rotation)
#   field 0, flags=2, range=0..255
#       usage 0 = 127 (0x7f)
# FEATURE: 0x24 - Horizontal Pincushion
#   field 0, flags=2, range=0..127
#       usage 0 = 91 (0x5b)
# FEATURE: 0x26 - Horizontal Pincushion Balance
#   field 0, flags=2, range=0..127
#       usage 0 = 64 (0x40)
# FEATURE: 0x40 - Parallelogram Balance (Key Distortion)
#   field 0, flags=2, range=0..127
#       usage 0 = 74 (0x4a)
# FEATURE: 0x42 - Trapezoidal Distortion (Key)
#   field 0, flags=2, range=0..100
#       usage 0 = 31 (0x1f)
# FEATURE: 0x6c - Red Video Black Level
#   field 0, flags=2, range=0..255
#       usage 0 = 146 (0x92)
# FEATURE: 0x6e - Green Video Black Level
#   field 0, flags=2, range=0..255
#       usage 0 = 148 (0x94)
# FEATURE: 0x70 - Blue Video Black Level
#   field 0, flags=2, range=0..255
#       usage 0 = 148 (0x94)
# FEATURE: 0xdc - Highlight Zone/OSD Control (0=off, 2=on, 4=fullscreen/8=lock OSD, 16=unlock OSD)
#   field 0, flags=2, range=0..127
#       usage 0 = 0 (0x0)
# FEATURE: 0xa1 - Highlight Zone Horizontal Position
#   field 0, flags=2, range=0..255
#       usage 0 = 0 (0x0)
# FEATURE: 0xa2 - Highlight Zone Vertical Position
#   field 0, flags=2, range=0..255
#       usage 0 = 0 (0x0)
# FEATURE: 0xa3 - Highlight Zone Horizontal Size
#   field 0, flags=2, range=0..255
#       usage 0 = 121 (0x79)
# FEATURE: 0xa4 - Highlight Zone Vertical Size
#   field 0, flags=2, range=0..255
#       usage 0 = 112 (0x70)
# FEATURE: 0xa5 - Highlight Zone Contrast
#   field 0, flags=2, range=0..255
#       usage 0 = 38 (0x26)
# FEATURE: 0xb1 - Highlight Zone Horizontal Size (read-only)
#   field 0, flags=2, range=0..255
#       usage 0 = 0 (0x0)
# FEATURE: 0xb2 - Highlight Zone Vertical Size (read-only)
#   field 0, flags=2, range=0..255
#       usage 0 = 0 (0x0)
# FEATURE: 0xb3 - Highlight Zone ??? (read-only)
#   field 0, flags=2, range=0..255
#       usage 0 = 121 (0x79)
# FEATURE: 0xb4 - Highlight Zone ??? (read-only)
#   field 0, flags=2, range=0..255
#       usage 0 = 112 (0x70)
# FEATURE: 0xb5 - Highlight Zone ??? (read-only)
#   field 0, flags=2, range=0..255
#       usage 0 = 38 (0x26)
# FEATURE: 0xa6 - Highlight Zone Red
#   field 0, flags=2, range=0..63
#       usage 0 = 63 (0x3f)
# FEATURE: 0xa7 - Highlight Zone Green
#   field 0, flags=2, range=0..63
#       usage 0 = 63 (0x3f)
# FEATURE: 0xa8 - Highlight Zone Blue
#   field 0, flags=2, range=0..63
#       usage 0 = 63 (0x3f)
# FEATURE: 0xa9 - Highlight Zone Sharpness
#   field 0, flags=2, range=0..63
#       usage 0 = 0 (0x0)
# FEATURE: 0xaa - Red Video Custom Value
#   field 0, flags=2, range=0..30
#       usage 0 = 15 (0xf)
# FEATURE: 0xab - Green Video Custom Value
#   field 0, flags=2, range=0..30
#       usage 0 = 15 (0xf)
# FEATURE: 0xaf - Blue Video Custom Value
#   field 0, flags=2, range=0..30
#       usage 0 = 15 (0xf)
# FEATURE: 0x56 - Horizontal Moire
#   field 0, flags=2, range=0..127
#       usage 0 = 0 (0x0)
# FEATURE: 0x58 - Vertical Moire
#   field 0, flags=2, range=0..127
#       usage 0 = 0 (0x0)
# FEATURE: 0xee - Vertical Focus
#   field 0, flags=2, range=0..127
#       usage 0 = 57 (0x39)
# FEATURE: 0xf0 - Unknown
#   field 0, flags=2, range=0..127
#       usage 0 = 107 (0x6b)
# FEATURE: 0x46 - Top Corner Distortion Control
#   field 0, flags=2, range=0..127
#       usage 0 = 64 (0x40)
# FEATURE: 0x4a - Bottom Corner Distortion Control
#   field 0, flags=2, range=0..127
#       usage 0 = 62 (0x3e)
# FEATURE: 0x48 - Top Corner Distortion Balance
#   field 0, flags=2, range=0..127
#       usage 0 = 64 (0x40)
# FEATURE: 0x4c - Bottom Corner Distortion Balance
#   field 0, flags=2, range=0..127
#       usage 0 = 64 (0x40)
# FEATURE: 0x54 - Color Temperature
#   field 0, flags=2, range=0..43
#       usage 0 = 0 (0x0)
# FEATURE: 0xc6 - Settings Management (1 = save current settings, 2 = recall default values)
#   field 0, flags=2, range=0..255
#       usage 0 = 0 (0x0)
# FEATURE: 0xd8 - Horizontal Size (not in OSD)
#   field 0, flags=0, range=1..2
#       usage 0 = 163 (0xa3)
#
# Found 1 USB HID monitors.
