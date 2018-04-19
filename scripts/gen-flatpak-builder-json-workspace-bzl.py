import argparse
import json
import os
import re
import sys

from urllib.parse import urlparse

_first_re_parse_file = r'tf_http_archive\(\s+name = "(?P<name>[A-Za-z0-9_\.]*?)",\s+urls\s=\s\[\s+\"(?P<url>.*?)"[^\)]+?sha256\s=\s\"(?P<sha256>.*?)"'
_second_re_parse_file = r'tf_http_archive\(\s+name = "(?P<name>[A-Za-z0-9_\.]*?)",\s+sha256\s=\s\"(?P<sha256>.*?)"[^\)]+?urls\s=\s\[\s+\"(?P<url>.*?)".'

EXCLUDED_NAMES = [
    "llvm",
    "arm_compiler",
    "aws",
    "kafka",
    "arm_neon_2_x86_sse",
    "tflite_mobilenet",
    "tflite_smartreply"
]

def excluded_name(name):
    return name in EXCLUDED_NAMES


def yield_matches(contents, parser):
    for match in re.finditer(parser, contents.replace('\n', '')):
        if not excluded_name(match.group("name")):
            yield match


def get_extension(url):
    parsed = urlparse(url)
    return os.path.basename(parsed.path).split(".", 1)[1]


def yield_sources_entries(contents, parser):
    for match in yield_matches(contents, parser):
        url = match.group("url")
        yield {
            "type": "file",
            "url": match.group("url"),
            "sha256": match.group("sha256"),
            "dest-filename": "{name}.{ext}".format(name=match.group("name"),
                                                   ext=get_extension(match.group("url"))),
        }


def yield_mv_entries(contents, parser):
    for match in yield_matches(contents, parser):
        yield "mv {name}.{ext} /usr/tensorflow-deps".format(name=match.group("name"),
                                                            ext=get_extension(match.group("url")))


def main():
    '''Parse the workspace.bzl file for dependencies.'''
    parser = argparse.ArgumentParser('Parse workspace.bzl for dependencies.')
    parser.add_argument('workspace',
                        help='The workspace file.',
                        type=str)

    args = parser.parse_args()

    with open(args.workspace, 'r') as f:
        contents = f.read()
        _re_parse_file = r'tf_http_archive\(\s+name = "(.*?)",\s+urls\s=\s\[\s+\"(.*?)".*?sha256\s=\s\"(.*?)"'

        print(json.dumps({
            "build_commands": (
                ["mkdir -p /usr/tensorflow-deps",
                 "mv rules_closure.tar.gz /usr/tensorflow-deps"] +
                list(yield_mv_entries(contents, _first_re_parse_file)) +
                list(yield_mv_entries(contents, _second_re_parse_file))
            ),
            "buildsystem": "simple",
            "name": "tensorflow-requirements",
            "sources": [
                {
                    "url": "https://mirror.bazel.build/github.com/bazelbuild/rules_closure/archive/08039ba8ca59f64248bb3b6ae016460fe9c9914f.tar.gz",
                    "dest-filename": "rules_closure.tar.gz",
                    "sha256": "6691c58a2cd30a86776dd9bb34898b041e37136f2dc7e24cadaeaf599c95c657",
                    "type": "file"
                },
            ] + (
                list(yield_sources_entries(contents, _first_re_parse_file)) +
                list(yield_sources_entries(contents, _second_re_parse_file))
            )
        }, indent=4))
        

if __name__ == '__main__':
    main()
