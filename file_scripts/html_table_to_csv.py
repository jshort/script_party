#!/usr/bin/env python

from HTMLParser import HTMLParser
import argparse
import re
import sys

class HTMLTableParser(HTMLParser):
    def __init__(self, cell_delim=",", row_delim="\n"):
        HTMLParser.__init__(self)
        self.despace_re = re.compile(r'\s+')
        self.data_interrupt = False
        self.first_row = True
        self.first_cell = True
        self.in_cell = False
        self.row_delim = row_delim
        self.cell_delim = cell_delim

    def handle_starttag(self, tag, attrs):
        self.data_interrupt = True
        if tag == "table":
            self.first_row = True
            self.first_cell = True
        elif tag == "tr":
            if not self.first_row:
                sys.stdout.write(self.row_delim)
            self.first_row = False
            self.first_cell = True
            self.data_interrupt = False
        elif tag == "td" or tag == "th":
            if not self.first_cell:
                sys.stdout.write(self.cell_delim)
            self.first_cell = False
            self.data_interrupt = False
            self.in_cell = True

    def handle_endtag(self, tag):
        self.data_interrupt = True
        if tag == "td" or tag == "th":
            self.in_cell = False

    def handle_data(self, data):
        if self.in_cell:
            raw_data = self.despace_re.sub(' ', data).strip()
            if self.cell_delim in raw_data:
                raw_data = "\"" + raw_data + "\""
            sys.stdout.write(raw_data)
            self.data_interrupt = False


arg_parser = argparse.ArgumentParser(description='Process some html table into CSV.')
arg_parser.add_argument('file', metavar='FILE', nargs='?', help='File to parse.')
arg_parser.add_argument('-d', '--delim', dest='delim', default=',',
        help='Delimiter for output (default: ,)')
args = arg_parser.parse_args()

html_parser = HTMLTableParser(args.delim)
if args.file is None:
    html_parser.feed(sys.stdin.read())
else:
    with open(args.file, 'r') as file:
        html_parser.feed(file.read())
