#!/usr/bin/python3

import sys

from classes import CachingIterable, InputPdfFile, BookletOrderedPages, SecondPageRightOfFirstMapping, OutputPdfFile, \
    FileNameWithSuffix, Pages2in1, RemainingItems, ConcatenatedIterables

inputFileName = sys.argv[1]
pages = CachingIterable(InputPdfFile(inputFileName))
bookletPages = BookletOrderedPages(pages)
twoToOneMapping = SecondPageRightOfFirstMapping()

OutputPdfFile(
    Pages2in1(bookletPages, twoToOneMapping),
    FileNameWithSuffix(inputFileName, "-booklet"),
).write()

remainingPages = CachingIterable(Pages2in1(RemainingItems(pages, bookletPages), twoToOneMapping))
OutputPdfFile(
    ConcatenatedIterables(remainingPages, remainingPages),
    FileNameWithSuffix(inputFileName, "-remainder")
).write()
