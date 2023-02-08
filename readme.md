# data-max-internship-assignment

Data Max Internship Assignment

## Contact Details
`Rigers` `Zaimi`

## Proposed Solution Details
- Time Complexity in terms of Big-O notation: <b>O(n)</b>

- Algorithm summary: This code is written to find the missing integer in a given sequence of integers. It achives this by comparing the integers in the string with their index. If the difference is between these 2 elemetns if found to be != 1 then we have found the missing number. 

## Single Digit Numbers
Each single-digit numbers is subtracted its index value. As stated before if the results is != than the missing number is returned immediately.<n>
``` python
for i in range(8): # goes up to number 8
      if int(nrString[i]) - i != 1:
        return int(nrString[i]) - 1 # returns the current value - 1

      elif i == len(nrString) - 1:
        return i + 2; # This code is used to check if the missing value is n
                      # If the missing number hasn't been found by this point it means that it means that the missing value is n
```
The code above is used to check all single digit numbers up to and including 9.

## When n >= 10 2 spcial casdes need te be covered:
``` python
if nrString[8] == '1':
        return 9 # If the value of index = 8 is '1' it means that 9 has been removed
    elif n == 10:
        return 10  # If n == 10, it can be the only missing elemnt
```
## Double Digit Numbers 
A counter value will be used to simulate the index on a normal ordered numbers list. The counter value will start at 9 and will be incremented (+1) for each successful iterration of the loop. <n>
``` python
counter = 9
    for i in range(9, 186, 2): # i will reach a max of 185 which is the first-digit of 98

        if  int(nrString[i]) * 10 + int(nrString[i+1]) - counter != 1: # first-digit * 10 + second-digits subtracted the counter value
            return int(nrString[i]) * 10 + int(nrString[i+1]) - 1 # returns current value - 1
        
        elif i == len(nrString) - 2: 
            return counter + 2; # covers the case when n == 99 and 98 is the last element
        
        counter += 1 # Counter which simulates an index for double-digit numbers incremented
```
## 99 and 100
These will be handled similiar to their single-digits equivalents 
``` python
if nrString[187] == '1':  
        return 99 # nrString[187] => '1' (The first digit of 99). If in its place we find '1' means that 99 is missing
    else:
        return 100
```

