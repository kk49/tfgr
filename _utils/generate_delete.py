import os
import argparse
from lxml import etree


def process_element(ele, output_prefix, indent=0):
    additional_files = []
    print('{}{}'.format('  ' * indent, ele.tag))

    process_children = False
    erase_all_children = False
    if ele.tag == 'root':
        process_children = True
    elif ele.tag in {
        'announcement', 'description', 'desktopframe', 'tokenroot', 'characterdbroot', 'viewerlistsettings',
        'tooltip', 'distance', 'imagesettings', 'textsettings', 'imageupdatefolder',
        'template', 'framedef', 'font', 'icon', 'portraitset', 'string',
    }:
        ele.getparent().remove(ele)
    elif ele.tag in {'windowclass', 'panel', 'die', 'customdie', 'diebox', 'pollbox', 'hotkeybar', 'menusettings'}:
        ele.set('merge', 'delete')
        erase_all_children = True
    elif ele.tag == 'script':
        ele.attrib.pop('file')
        ele.set('merge', 'delete')
    elif ele.tag == 'includefile':
        org = ele.attrib['source']
        additional_files.append(org)
        ele.set('source', os.path.join(output_prefix, org))
    elif hasattr(ele.tag, 'func_name') and ele.tag.func_name == 'Comment':
        ele.getparent().remove(ele)
    else:
        raise NotImplementedError(f'Missing case: {ele.tag}')

    if process_children:
        children = list(ele)
        for i, child in enumerate(children):
            additional_files += process_element(child, output_prefix, indent+1)

    if erase_all_children:
        children = list(ele)
        for child in children:
            ele.remove(child)
        ele.text = None

    return additional_files


def process_file(file, input_path, output_prefix, output_path):
    print(f'Processing {file}')

    additional_files = []

    abs_file = os.path.join(input_path, file)

    with open(abs_file, 'rb') as f:
        buffer = f.read()

    root = etree.XML(buffer)

    additional_files += process_element(root, output_prefix)

    abs_output = os.path.join(output_path, output_prefix, file)
    print(f'abs_output = {abs_output}')

    output_dir, _ = os.path.split(abs_output)
    os.makedirs(output_dir, exist_ok=True)
    with open(abs_output, 'wb') as f:
        f.write(b'<?xml version="1.0" encoding="iso-8859-1"?>\n\n')
        f.write(etree.tostring(root, pretty_print=True))

    return additional_files


def process(root_file, input_path, output_prefix, output_path):
    files = [root_file]
    completed_files = set()
    while files:
        file = files.pop(0)
        if file not in completed_files:
            addition_files = process_file(file, input_path, output_prefix, output_path)
            files = files + addition_files
            completed_files.add(file)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        'root_file', type=str, help='File to start generation delete files from, usually base.xml')

    parser.add_argument(
        '--input-path', type=str, default=None,
        help='Root directory that is used to find files referenced in parsed files. '
             'If not specified it is the directory the root file is in')

    parser.add_argument(
        '--output-prefix', type=str, default=None,
        help='Prefix path used to prepend to all generated files. If not specified it will be "delete"')

    parser.add_argument(
        '--output-path', type=str, default=None,
        help='Directory into which output-prefix directory will be created in. If not specified it will be ./')


    args = parser.parse_args()

    root_file = os.path.abspath(args.root_file)

    if args.input_path:
        input_path = args.input_prefix
    else:
        input_path, _ = os.path.split(root_file)
    input_path = os.path.abspath(input_path)

    if not root_file.startswith(input_path):
        raise Exception('root file does not exist within the input path')

    root_file = root_file[len(input_path)+1:]

    if args.output_prefix:
        output_prefix = args.output_prefix
    else:
        output_prefix = 'delete'

    if args.output_path:
        output_path = args.output_path
    else:
        output_path = '.'

    output_path = os.path.abspath(output_path)

    os.makedirs(output_prefix, exist_ok=True)

    print(f'root_file == {root_file}')
    print(f'input_path == {input_path}')
    print(f'output_prefix == {output_prefix}')
    print(f'output_path == {output_path}')

    process(root_file, input_path, output_prefix, output_path)


if __name__ == '__main__':
    main()
