from PyPDF2 import PdfFileReader, PdfFileWriter
from PyPDF2.pdf import PageObject
from collections import Iterable


class OutputPdfFile:

    def __init__(self, pages, filename):
        self.__pages = pages
        self.__filename = filename

    def write(self):
        writer = PdfFileWriter()
        for page in self.__pages:
            writer.addPage(page)
        if writer.getNumPages() > 0:
            with open(str(self.__filename), 'wb') as file:
                writer.write(file)


class BookletOrderedPages(Iterable):

    def __init__(self, pages):
        self.__pages = pages

    def __iter__(self):
        pages_list = list(self.__pages)
        pages_count = len(pages_list)
        quadruples_count = divmod(pages_count, 4)[0]
        return [
            page
            for i in range(0, quadruples_count)
            for page in [
                pages_list[pages_count - 1 - (i * 2)],
                pages_list[i * 2],
                pages_list[i * 2 + 1],
                pages_list[pages_count - 2 - (i * 2)]
            ]
        ].__iter__()


class Pages2in1(Iterable):
    def __init__(self, pages, two_to_one_mapping):
        self.__two_to_one_mapping = two_to_one_mapping
        self.__pages = pages

    def __iter__(self):
        pages = list(self.__pages)
        if not pages:
            return [].__iter__()
        else:
            return [
                self.__two_to_one_mapping.map(pages[i * 2], pages[i * 2 + 1])
                for i in range(0, divmod(len(pages), 2)[0])
            ].__iter__()


# Non-OOP class unfortunately because we cannot create own implementation of PyPDF2's PageObject class
class SecondPageRightOfFirstMapping:

    def map(self, page1, page2):
        box1 = page1.mediaBox
        box2 = page2.mediaBox
        page = PageObject.createBlankPage(
            None,
            box1.getWidth() + box2.getWidth(),
            max(box1.getHeight(), box2.getHeight())
        )
        page.mergePage(page1)
        page.mergeTranslatedPage(page2, box1.getWidth(), 0)
        return page


class InputPdfFile(Iterable):
    def __init__(self, filename):
        self.__filename = filename

    def __iter__(self):
        reader = PdfFileReader(open(str(self.__filename), 'rb'))
        return [(reader.getPage(i)) for i in range(0, reader.getNumPages())].__iter__()


class GreatestMultiple(Iterable):
    def __init__(self, items, divisor):
        self.__items = items
        self.__divisor = divisor

    def __iter__(self):
        count = len(list(self.__items))
        remainder = divmod(count, self.__divisor)[1]
        return (list(self.__items)[0:count - remainder]).__iter__()


class RemainingItems(Iterable):
    def __init__(self, items, items_to_remove):
        self.__items = items
        self.__items_to_remove = items_to_remove

    def __iter__(self):
        return [item for item in self.__items if item not in self.__items_to_remove].__iter__()


class FileNameWithSuffix:
    def __init__(self, obj, suffix):
        self.__obj = obj
        self.__suffix = suffix

    def __str__(self):
        parts = str(self.__obj).rsplit('.', 1)
        return parts[0] + self.__suffix + (("." + parts[1]) if len(parts) == 2 else "")


class CachingIterable(Iterable):
    def __init__(self, iterable):
        # TODO make lazy
        self.__iterable = list(iterable)

    def __iter__(self):
        return self.__iterable.__iter__()


class ConcatenatedIterables(Iterable):
    def __init__(self, iterable1, iterable2):
        self.__iterable1 = list(iterable1)
        self.__iterable2 = list(iterable2)

    def __iter__(self):
        return [item for items in [self.__iterable1, self.__iterable2] for item in items].__iter__()


class InputFileName():
    def __init__(self, arguments):
        self.__arguments = arguments

    def __str__(self):
        return self.__arguments[1]
