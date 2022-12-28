'''
Author: LetMeFly
Date: 2022-10-19 15:41:14
LastEditors: LetMeFly
LastEditTime: 2022-10-20 10:22:52
@link: https://blog.csdn.net/Tisfy/article/details/127413787
'''

# numbers = [16, 2, 16, 0]
# operators = ["<<", "*", "+"]

numbers = [14, 22, 29, 6,
2, 2, 13, 4, 11,
23, 996, 19, 2, 2,
7, 2, 12, 27,
2, 6, 30, 19,
11, 4, 2, 30, 2,
1075, 14, 2, 2,
2, 1075, 2, 35]
operators = ["*", "&", "&", "^", "//", "|", "|"]


ok = []

print(f"{len(numbers)} ^ 4 * {len(operators)} ^ 3 = {len(numbers) ** 4 * len(operators) ** 3}")

for n1 in range(len(numbers)):
    for n2 in range(len(numbers)):
        for n3 in range(len(numbers)):
            for n4 in range(len(numbers)):
                for o1 in range(len(operators)):
                    for o2 in range(len(operators)):
                        for o3 in range(len(operators)):
                            if (n1 == n2 or n1 == n3 or n1 == n4 or n2 == n3 or n2 == n4 or n3 == n4) or (o1 == o2 or o2 == o3 or o1 == o3):
                                continue
                            string = f"((({numbers[n1]}{operators[o1]}{numbers[n2]}){operators[o2]}{numbers[n3]}){operators[o3]}{numbers[n4]})"
                            try:
                                if eval(string) == 1024:
                                    ok.append(string)
                            except:
                                pass

print(ok)

