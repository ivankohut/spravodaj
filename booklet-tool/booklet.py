#!/usr/bin/python3

import sys

from classes import CachingIterable, InputPdfFile, BookletOrderedPages, SecondPageRightOfFirstMapping, OutputPdfFile, \
    FileNameWithSuffix, Pages2in1, RemainingItems, ConcatenatedIterables, InputFileName

inputFileName = InputFileName(sys.argv)
pages = CachingIterable(InputPdfFile(inputFileName))
bookletPages = BookletOrderedPages(pages)
twoToOneMapping = SecondPageRightOfFirstMapping()


def create_output_pdf_file(pages, suffix):
    return OutputPdfFile(
        pages,
        FileNameWithSuffix(inputFileName, "-" + suffix)
    )


bookletFile = create_output_pdf_file(
    Pages2in1(bookletPages, twoToOneMapping),
    "booklet"
)

remainingPages = CachingIterable(
    Pages2in1(
        RemainingItems(pages, bookletPages),
        twoToOneMapping
    )
)
remainderFile = create_output_pdf_file(
    ConcatenatedIterables(remainingPages, remainingPages),
    "remainder"
)

bookletFile.write()
remainderFile.write()
