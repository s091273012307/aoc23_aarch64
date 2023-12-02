#!/usr/bin/env python3
sum = 0
nums = '0123456789'
lines = open('day_1_input').read().split('\n')
calibation_vales = []
for line in lines:
    dec_in_line = ''
    for c in line:
        if c in nums:
            dec_in_line += c
    # calibration values are the first and last number in a line
    val = int(dec_in_line[0] + dec_in_line[-1])
    # print(val)
    calibation_vales.append(val)
    sum += val
print('p1: sum of calibration values:', sum)

sum = 0
nums = ['zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine']
numsz = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']
calibation_vales = []
for line in lines:
    val = 0
    lowest = 0xffffffff
    highest = 0
    # find first
    for i, num in enumerate(nums):
        pos = line.find(num)
        if pos > -1 and pos < lowest:
            lowest = pos
            val = i
    for num in numsz:
        pos = line.find(num)
        if pos > -1 and pos < lowest:
            lowest = pos
            val = int(num)
    dec_in_line1 = val

    # find last
    for i, num in enumerate(nums):
        pos = line.rfind(num)
        if pos > -1 and pos > highest:
            highest = pos
            val = i
    for num in numsz:
        pos = line.rfind(num)
        if pos > -1 and pos > highest:
            highest = pos
            val = int(num)
    dec_in_line2 = val
    # calibration values are the first and last number in a line
    val = dec_in_line1 * 10 + dec_in_line2
    # print(line,val)
    calibation_vales.append(val)
    sum += val
print('p2: sum of calibration values:', sum)