#!/usr/bin/python3

import sys

from classes import CachingIterable, InputPdfFile, BookletOrderedPages, SecondPageRightOfFirstMapping, Pages2in1, \
    RemainingItems, InputFileName, OutputPdfFileWithSuffix, DoubledIterable, OutputFiles

inputFileName = InputFileName(sys.argv)
pages = CachingIterable(InputPdfFile(inputFileName))
bookletPages = BookletOrderedPages(pages)
twoToOneMapping = SecondPageRightOfFirstMapping()

OutputFiles(
    OutputPdfFileWithSuffix(
        Pages2in1(bookletPages, twoToOneMapping),
        inputFileName,
        "booklet"
    ),
    OutputPdfFileWithSuffix(
        DoubledIterable(
            CachingIterable(
                Pages2in1(
                    RemainingItems(pages, bookletPages),
                    twoToOneMapping
                )
            )
        ),
        inputFileName,
        "remainder"
    )
).write()
