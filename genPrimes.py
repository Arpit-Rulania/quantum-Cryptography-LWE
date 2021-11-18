#!/usr/bin/python3

n = 16

##################

from math import sqrt, pow, log, floor
from itertools import count, islice
from json import dumps
from random import sample


def is_prime(n):
    return n > 1 and all(n % i for i in islice(count(2), int(sqrt(n) - 1)))

primes = []

i = 0
while i < pow(2, n):
    if is_prime(i):
        print(i)
        primes.append(i)
    i += 1

print("Generated %d primes up to 2^%d" % (len(primes), n))

primesFormatted = [*map(lambda s: bin(s)[2:].rjust(16, '0'), primes)]

with open("primes.txt", "w") as f:
    f.write(dumps(primesFormatted))

bitFitSize = floor(log(len(primes)) / log(2))
print("Pruning primes to fit a %d-bit space" % bitFitSize)

with open("primes.sampled.txt", "w") as f:
    f.write(dumps(sample(primesFormatted, int(pow(2, bitFitSize)))))
