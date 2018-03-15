# Monthly newsletter of BJB Palisády church in Bratislava, Slovakia.

This repos contains

1. TeX sources of newsletter and macros used (`makra.tex`)
2. *booklet-tool* (Python3) script used to generate booklet pages for printing


## TeX sources

- Plain TeX (CSPlain format) with OPmac and custom macros
- xetex engine, use this command to generate format

    `xetex -jobname pdfcsplain -ini -etex csplain.ini`

    and this command to generate PDF from tex file (`2018_02_spravodaj_februar.tex` in this case)
    using format generated with previous command

    `xetex -fmt pdfcsplain.fmt 2018_02_spravodaj_februar.tex`

- developed using TeX Live 2017


## Booklet tool
Generates PDF file(s) (landscape A4 pages) used for printing the newsletter (portrait A5 pages).
Generates one PDF file (for input pages count being multiple of 4) or two PDF files (for even pages count not being multiple of 4).
Examples:
  * four input A5 portrait pages => two A4 landscape pages (pages 4 and 1 on the first page, pages 2 and 3 on the second pages)
  * six input A5 portrait pages => two documents (if you to print 100 copies then print 100 copies of the first document and 50 copies of the second document)
    - first document = two A4 landscape pages (pages 6 and 1 on the first page, pages 2 and 5 on the second page)
    - second document = with two A4 landscape pages (pages 3 and 4 on the first page, pages 3 and 4 on the second page)

Developed using Python 3.4