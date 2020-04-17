from PIL import Image

master = Image.open('window_icons.png')

icons = [
    ('window_resize.png', [0, 0, 31, 31]),
    ('window_0_1.png', [0, 31, 31, 62]),
    ('window_0_2.png', [0, 62, 31, 93]),
]

x_begin = 31
x_end = x_begin + 31
icons = icons + [
    ('window_blank_normal.png', [x_begin, 0, x_end, 31]),
    ('window_blank_hover.png', [x_begin, 31, x_end, 62]),
    ('window_blank_pressed.png', [x_begin, 62, x_end, 93]),
]
x_begin = 62
x_end = x_begin + 31
icons = icons + [
    ('window_minimize_normal.png', [x_begin, 0, x_end, 31]),
    ('window_minimize_hover.png', [x_begin, 31, x_end, 62]),
    ('window_minimize_pressed.png', [x_begin, 62, x_end, 93]),
]
x_begin = 93
x_end = x_begin + 31
icons = icons + [
    ('window_maximize_normal.png', [x_begin, 0, x_end, 31]),
    ('window_maximize_hover.png', [x_begin, 31, x_end, 62]),
    ('window_maximize_pressed.png', [x_begin, 62, x_end, 93]),
]
x_begin = 124
x_end = x_begin + 31
icons = icons + [
    ('window_close_normal.png', [x_begin, 0, x_end, 31]),
    ('window_close_hover.png', [x_begin, 31, x_end, 62]),
    ('window_close_pressed.png', [x_begin, 62, x_end, 93]),
]
x_begin = 155
x_end = x_begin + 31
icons = icons + [
    ('window_link_normal.png', [x_begin, 0, x_end, 31]),
    ('window_link_hover.png', [x_begin, 31, x_end, 62]),
    ('window_link_pressed.png', [x_begin, 62, x_end, 93]),
]

for fn, bounds in icons:
    icon = master.crop(bounds)
    icon.save(fn)
