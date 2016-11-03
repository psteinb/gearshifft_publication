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
        
    # divs = [ x for x in ranged_divisor_list(n,1,3*tgt//4) ]
    # diff = [ abs(x-tgt) for x in divs ]
    # print("ranged_divisor_list >> ",n,tgt)
    # print(divs)
    # print(diff)
    # factor = divs[diff.index(min(diff))]
    
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
    
    # divs = [ x for x in ranged_divisor_list(n,1,3*tgt//4) ]
    # diff = [ abs(x-tgt) for x in divs ]
    # print("ranged_divisor_list >> ",n,tgt)
    # print(divs)
    # print(diff)
    # factor = divs[diff.index(min(diff))]
    
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
    # radix2 = [ str(pow(2,expon)) for expon in range(2,32) ]
    # radix3 = [ str(pow(3,expon)) for expon in range(2,20) ]
    # radix5 = [ str(pow(5,expon)) for expon in range(2,14) ]
    # radix7 = [ str(pow(7,expon)) for expon in range(2,11)  ]
    # radix19 = [ str(pow(19,expon)) for expon in range(2,8)  ]
    radix2 = radix_list(2,2,32)
    radix3 = radix_list(3,2,20)
    radix5 = radix_list(5,2,14)
    radix7 = radix_list(7,2,11)
    radix19 = radix_list(19,2,8)

    value = [ "#1D shapes" ]
    value.extend(join_2_list(radix2,
                             radix3,
                             radix5,
                             radix7,
                             radix19))
    return value;

def run_2D():
    value = [ "#2D shapes" ]

    scalar_radix2 = radix_list(2,2,32)
    scalar_radix3 = radix_list(3,2,20)
    scalar_radix5 = radix_list(5,2,14)
    scalar_radix7 = radix_list(7,2,11)
    some_radix19 = radix_list(19,2,5)
    
    radix19_pairs = []
    count = 0;
    for i in scalar_radix2[-4-len(some_radix19):-4]:
        item = (some_radix19[count],i//some_radix19[count])
        radix19_pairs.append(item)
        count+=1

    count = 0
    for i in scalar_radix3[-4-len(some_radix19):-4]:
        item = (some_radix19[count],i//some_radix19[count])
        radix19_pairs.append(item)
        count+=1

    count = 0
    for i in scalar_radix5[-4-len(some_radix19):-4]:
        item = (some_radix19[count],i//some_radix19[count])
        radix19_pairs.append(item)
        count+=1

        
    radix2 = [ "{0!s},{1!s}".format(*equal_size_divisor_pair(x)) for x in scalar_radix2 ]
    radix3 = [ "{0!s},{1!s}".format(*equal_size_divisor_pair(x)) for x in scalar_radix3 ]
    radix5 = [ "{0!s},{1!s}".format(*equal_size_divisor_pair(x)) for x in scalar_radix5 ]
    radix7 = [ "{0!s},{1!s}".format(*equal_size_divisor_pair(x)) for x in scalar_radix7 ]
    
    radix19 = [ "{0!s},{1!s}".format(*x) for x in radix19_pairs  ]
    
    value.extend(join_2_list(radix2,radix3,radix5,radix7,radix19))
    return value

def run_3D():
    value = [ "#3D shapes" ]
    scalar_radix2 = radix_list(2,3,32)
    scalar_radix3 = radix_list(3,3,20)
    scalar_radix5 = radix_list(5,3,14)
    scalar_radix7 = radix_list(7,3,11)
    some_radix19 = radix_list(19,1,4)
    
    radix19_triple = []
    count = 0;
    for i in scalar_radix2[-4-len(some_radix19):-4]:
        rem = i//some_radix19[count]
        double_expon = round(math.log(rem)/math.log(2))#extract power of 2 
        item = (some_radix19[count],2**(double_expon//2),2**(double_expon//2))
        radix19_triple.append(item)
        count+=1

    count = 0
    for i in scalar_radix3[-4-len(some_radix19):-4]:
        rem = i//some_radix19[count]
        double_expon = round(math.log(rem)/math.log(3))#extract power of 3 
        item = (some_radix19[count],3**(double_expon//2),3**(double_expon//2))
        radix19_triple.append(item)
        count+=1

    count = 0
    for i in scalar_radix5[-4-len(some_radix19):-4]:
        rem = i//some_radix19[count]
        double_expon = round(math.log(rem)/math.log(5))#extract power of 5 
        item = (some_radix19[count],5**(double_expon//2),5**(double_expon//2))
        radix19_triple.append(item)
        count+=1
        
    radix2 = [ "{0!s},{1!s},{2!s}".format(*equal_size_divisor_triple(x)) for x in scalar_radix2 ]
    radix3 = [ "{0!s},{1!s},{2!s}".format(*equal_size_divisor_triple(x)) for x in scalar_radix3 ]
    radix5 = [ "{0!s},{1!s},{2!s}".format(*equal_size_divisor_triple(x)) for x in scalar_radix5 ]
    radix7 = [ "{0!s},{1!s},{2!s}".format(*equal_size_divisor_triple(x)) for x in scalar_radix7 ]
    
    radix19 = [ "{0!s},{1!s},{2!s}".format(*(x)) for x in  radix19_triple ]
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
