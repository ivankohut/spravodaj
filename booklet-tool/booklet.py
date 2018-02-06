#!/usr/bin/python3

import sys

from classes import CachingIterable, InputPdfFile, BookletOrderedPages, SecondPageRightOfFirstMapping, OutputPdfFile, \
    FileNameWithSuffix, Pages2in1, RemainingItems

inputFileName = sys.argv[1]
pages = CachingIterable(InputPdfFile(inputFileName))
bookletPages = BookletOrderedPages(pages)
twoToOneMapping = SecondPageRightOfFirstMapping()

OutputPdfFile(
    Pages2in1(bookletPages, twoToOneMapping),
    FileNameWithSuffix(inputFileName, "-booklet"),
).write()

OutputPdfFile(
    Pages2in1(RemainingItems(pages, bookletPages), twoToOneMapping),
    FileNameWithSuffix(inputFileName, "-remainder")
).write()
