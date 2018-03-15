import unittest

from classes import BookletOrderedPages, RemainingItems, FileNameWithSuffix, ConcatenatedIterables, DoubledIterable


class BookletOrderedPagesTest(unittest.TestCase):

    def test_fourPagesPerDoubleSideSheetOfPaper(self):
        sut = BookletOrderedPages([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
        self.assertSequenceEqual([10, 1, 2, 9, 8, 3, 4, 7], list(sut))


class RemainingItemsTest(unittest.TestCase):

    def test_allItemFromFirstListNotExistingInSecondList(self):
        sut = RemainingItems([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], [10, 1, 2, 9, 8, 3, 4, 7])
        self.assertSequenceEqual([5, 6], list(sut))


class FileNameWithSuffixTest(unittest.TestCase):

    def test_suffixInsertedBeforeExtension(self):
        sut = FileNameWithSuffix("part1.part2.extension", "-suffix")
        self.assertEqual("part1.part2-suffix.extension", str(sut))

    def test_suffixAppendedToFIleNameIfNoExtensionExists(self):
        sut = FileNameWithSuffix("filename", "-suffix")
        self.assertEqual("filename-suffix", str(sut))


class ConcatenatedIterablesTest(unittest.TestCase):

    def test_iterableOfItemsFromFirstIterableFollowedByItemsFromSecondIterable(self):
        sut = ConcatenatedIterables([1, 2], [3, 4])
        self.assertSequenceEqual([1, 2, 3, 4], list(sut))


class DoubledIterableTest(unittest.TestCase):

    def test_iterableOfItemsFromIterableFollowedByItemsFromTheSameIterable(self):
        sut = DoubledIterable([1, 2])
        self.assertSequenceEqual([1, 2, 1, 2], list(sut))


if __name__ == '__main__':
    unittest.main()