#!/usr/bin/env python
import math
import sys
#this is a python 3 script

def run_1D():
    radix2 = [ str(pow(2,expon)) for expon in range(2,32) ]
    radix3 = [ str(pow(3,expon)) for expon in range(2,20) ]
    radix5 = [ str(pow(5,expon)) for expon in range(2,14) ]
    radix7 = [ str(pow(7,expon)) for expon in range(2,11)  ]

    radix19 = [ str(pow(19,expon)) for expon in range(2,8)  ]

    value = [ "#1D shapes" ]
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

def run_2D():
    value = [ "#2D shapes" ]
    return value

def run_3D():
    value = [ "#3D shapes" ]
    return value

if __name__ == '__main__':

    argv = sys.argv

    args_string = (" ".join(argv[1:]))

    if "help" in args_string or "-h" in args_string:
        print("{}, utility to produce shape files for running gearshift".format(__file__))
        print("usage : python3 {} <args>\n".format(__file__))
        header = "\t<arg>\t..\tdescription"
        print(header)
        print("\t"+(50*"-"))
        print("\thelp\t..\tproduce this help message")
        for i in range(1,4):
            print("\t{0!s}\t..\tproduce {0!s}D extents".format(i))
        print("\tall\t..\tproduce extents for all dimensions")
        sys.exit(1)
    
    lines = ""
    if "1" in args_string:
        lines = run_1D()
        
    if "2" in args_string:
        lines = run_2D()

    if "3" in args_string:
        lines = run_3D()

    if len(argv)==1 or "all" in args_string:
        lines = run_1D()
        lines.extend(run_2D())
        lines.extend(run_3D())
        
    for l in lines:
        print(l)
    
    sys.exit(0)
