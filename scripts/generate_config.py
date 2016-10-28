#!/usr/bin/env python
import math
#this is a python 3 script

def run():
    radix2 = [ str(pow(2,expon)) for expon in range(2,32) ]
    radix3 = [ str(pow(3,expon)) for expon in range(2,20) ]
    radix5 = [ str(pow(5,expon)) for expon in range(2,14) ]
    radix7 = [ str(pow(7,expon)) for expon in range(2,11)  ]

    radix19 = [ str(pow(19,expon)) for expon in range(2,8)  ]

    value = [ "" ]
    value.append("#radix-2")
    value.append("\n".join(radix2))
    
    value.append("#radix-3")
    value.append("\n".join(radix3))
    
    value.append("#radix-5")
    value.append("\n".join(radix5))
    
    value.append("#radix-7")
    value.append("\n".join(radix7))

    value.append("#radix-19")
    value.append("\n".join(radix19))

    return value;
    
if __name__ == '__main__':

    lines = run()

    for l in lines:
        print(l)
    
