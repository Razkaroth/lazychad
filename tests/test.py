from typing import List


def merge(nums1: List[int], nums2:List[int]):
    print(nums1)
    print(nums2)

    nums1 = list(filter(lambda x: x != 0, nums1))
    print(nums1)
    nums1 = nums1 + nums2
    nums1
    print(nums1)
    nums1 = sorted(nums1)
    print(nums1)






merge([1,2,6,0,0,0], [2,3,4])
merge([1,2,0,0,0], [2,3,4])
