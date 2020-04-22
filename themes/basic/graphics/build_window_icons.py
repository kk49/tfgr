from PIL import Image

# w = 31
# master = Image.open('window_icons_31.png')
w = 19
master = Image.open('window_icons_19.png')

icons = []


x_begin = 0
x_end = x_begin + w
icons = icons + [
    ('window_resize.png', [x_begin, 0, x_end, w]),
    ('window_0_1.png', [x_begin, w, x_end, (w*2)]),
    ('window_0_2.png', [x_begin, (w*2), x_end, (w*3)]),
]

x_begin = w
x_end = x_begin + w
icons = icons + [
    ('window_blank_normal.png', [x_begin, 0, x_end, w]),
    ('window_blank_hover.png', [x_begin, w, x_end, (w*2)]),
    ('window_blank_pressed.png', [x_begin, (w*2), x_end, (w*3)]),
]
x_begin = (w* 2)
x_end = x_begin + w
icons = icons + [
    ('window_minimize_normal.png', [x_begin, 0, x_end, w]),
    ('window_minimize_hover.png', [x_begin, w, x_end, (w*2)]),
    ('window_minimize_pressed.png', [x_begin, (w*2), x_end, (w*3)]),
]
x_begin = (w*3)
x_end = x_begin + w
icons = icons + [
    ('window_maximize_normal.png', [x_begin, 0, x_end, w]),
    ('window_maximize_hover.png', [x_begin, w, x_end, (w*2)]),
    ('window_maximize_pressed.png', [x_begin, (w*2), x_end, (w*3)]),
]
x_begin = (w*4)
x_end = x_begin + w
icons = icons + [
    ('window_close_normal.png', [x_begin, 0, x_end, w]),
    ('window_close_hover.png', [x_begin, w, x_end, (w*2)]),
    ('window_close_pressed.png', [x_begin, (w*2), x_end, (w*3)]),
]
x_begin = (w*5)
x_end = x_begin + w
icons = icons + [
    ('window_link_normal.png', [x_begin, 0, x_end, w]),
    ('window_link_hover.png', [x_begin, w, x_end, (w*2)]),
    ('window_link_pressed.png', [x_begin, (w*2), x_end, (w*3)]),
]

for fn, bounds in icons:
    icon = master.crop(bounds)
    icon.save(fn)
