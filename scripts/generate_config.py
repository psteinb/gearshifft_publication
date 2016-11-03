#!/usr/bin/env python
import math
import sys
#this is a python 3 script

def divisor_list(n):
    upper_bound = int(n)//2 + 1
    for i in range(1,upper_bound):
        if n%i == 0: yield i
    yield n

def ranged_divisor_list(n,lbound=1,ubound=None):
    if not ubound:
        ubound = 2*int(n)//3

    for i in range(lbound,ubound):
        if n%i == 0: yield i
    yield n

def equal_size_divisor_pair(n, tgt = None ):

    if not tgt:
        tgt = math.sqrt(n)
    
    if type(n) != type(tgt):
        tgt = int(tgt)

    tgt = tgt + 1

    factor = 1
    for i in range(tgt,1,-1):
        if n % i == 0:
            factor = i
            break

    return (factor, n//factor)

def equal_size_divisor_triple(n, tgt = None ):

    if not tgt:
        tgt = int(round(math.pow(n,1/3.)))

    tgt = tgt + 1


    value = [0,0,0]
    for i in range(tgt,1,-1):
        if n % i == 0:
            value[0] = i
            break

    value[1],value[2] = equal_size_divisor_pair(n//value[0])

    return value

def join_2_list(radix2,radix3,radix5,radix7,radix19):
    rvalue = []
    rvalue.append("#radix-2")
    rvalue.append("\n".join([ str(x) for x in radix2 ]))
    
    rvalue.append("#radix-3")
    rvalue.append("\n".join([ str(x) for x in radix3 ]))
    
    rvalue.append("#radix-5")
    rvalue.append("\n".join([ str(x) for x in radix5 ]))
    
    rvalue.append("#radix-7")
    rvalue.append("\n".join([ str(x) for x in radix7 ]))

    rvalue.append("#radix-19")
    rvalue.append("\n".join([ str(x) for x in radix19 ]))
    
    return rvalue

def radix_list(radix, range_start,range_end):
    return [ pow(radix,expon) for expon in range(range_start,range_end) ]

def run_1D():
    radix2 = radix_list(2,2,31)
    radix3 = radix_list(3,2,20)
    radix5 = radix_list(5,2,14)
    radix7 = radix_list(7,2,11)
    radix19 = radix_list(19,1,7)

    value = [ "#1D shapes" ]
    value.extend(join_2_list(radix2,
                             radix3,
                             radix5,
                             radix7,
                             radix19))
    return value;

def run_2D():
    value = [ "#2D shapes" ]

    scalar_radix2 = radix_list(2,2,31)
    scalar_radix3 = radix_list(3,2,20)
    scalar_radix5 = radix_list(5,2,14)
    scalar_radix7 = radix_list(7,2,11)
    scalar_radix19 = radix_list(19,2,7)

    radix2 = [ "{0!s},{1!s}".format(*equal_size_divisor_pair(x)) for x in scalar_radix2 ]
    radix3 = [ "{0!s},{1!s}".format(*equal_size_divisor_pair(x)) for x in scalar_radix3 ]
    radix5 = [ "{0!s},{1!s}".format(*equal_size_divisor_pair(x)) for x in scalar_radix5 ]
    radix7 = [ "{0!s},{1!s}".format(*equal_size_divisor_pair(x)) for x in scalar_radix7 ]
    radix19 = [ "{0!s},{1!s}".format(*equal_size_divisor_pair(x)) for x in scalar_radix19 ]

    value.extend(join_2_list(radix2,radix3,radix5,radix7,radix19))
    return value

def run_3D():
    value = [ "#3D shapes" ]
    scalar_radix2 = radix_list(2,3,31)
    scalar_radix3 = radix_list(3,3,20)
    scalar_radix5 = radix_list(5,3,14)
    scalar_radix7 = radix_list(7,3,11)
    scalar_radix19 = radix_list(19,3,7)

    radix2 = [ "{0!s},{1!s},{2!s}".format(*equal_size_divisor_triple(x)) for x in scalar_radix2 ]
    radix3 = [ "{0!s},{1!s},{2!s}".format(*equal_size_divisor_triple(x)) for x in scalar_radix3 ]
    radix5 = [ "{0!s},{1!s},{2!s}".format(*equal_size_divisor_triple(x)) for x in scalar_radix5 ]
    radix7 = [ "{0!s},{1!s},{2!s}".format(*equal_size_divisor_triple(x)) for x in scalar_radix7 ]
    radix19 = [ "{0!s},{1!s},{2!s}".format(*equal_size_divisor_triple(x)) for x in scalar_radix19 ]

    value.extend(join_2_list(radix2,radix3,radix5,radix7,radix19))

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
