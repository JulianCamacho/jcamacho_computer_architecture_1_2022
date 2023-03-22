
# x/11x $sp
#x/11dw $sp
# x/20dw $sp-40
# print/d *((unsigned long long*)&partial_result)

def concatena_binario(msb, lsb):
    msb_binario = bin(msb)[2:].zfill(8)
    lsb_binario = bin(lsb)[2:].zfill(8)
    numero_binario = msb_binario + lsb_binario
    numero_decimal = int(numero_binario, 2) 
    print(numero_decimal)
    return numero_decimal


def my_fastExpMod(base, expo, n):
    lenExp = expo.bit_length()-2
    res = base
    while lenExp >= 0:
        bit = (expo & (1 << lenExp)) != 0
        if bit:
            res = base * res * res
        else:
            res = res * res
        res = res%n
        lenExp -= 1
    print(res)
    return res


def expmod(msb, lsb, d, n):
    base = concatena_binario(msb, lsb)
    my_fastExpMod(base, d, n)

def myMod(a, b):
    while a >= 0:
        a -= b
    return a+b

def fastExpMod(msb, lsb, expo, n):
    base = concatena_binario(msb, lsb)
    lenExp = expo.bit_length()-2
    print(lenExp)
    res = base
    resl = [res]
    while lenExp >= 0:
        bit = (expo & (1 << lenExp)) != 0
        print(bit)
        if bit:
            res = base * res * res
        else:
            res = res * res
        resl.append([res, n])
        res = myMod(res, n)
        resl.append(res)
        lenExp -= 1
    print(resl)
    return res

expmod(7, 180, 1631, 5963)
#fastExpMod(234, 55, 1631, 5963) #--> deja de funcionar

# base^1631 mod(5963)

# 0 5     = 5      --> 125
# 234 55  = 59959  --> 
# 2 54    = 566    --> 105
# 169 76  = 43340  --> 
# 20 104  = 5224   --> 
# 1 1     = 257    --> 
# 255 255 = 65535  --> 

#25


# base^200 mod(50)

# 0 5     = 5      --> 25
# 234 55  = 59959  --> 1
# 2 54    = 566    --> 26
# 169 76  = 43340  --> 0
# 20 104  = 5224   --> 26
# 1 1     = 257    --> 1
# 255 255 =65535   --> 25
 
# 18 66   = 4674   --> 26
# 7 180   = 1972   --> 26
# 11 123  = 2939   --> 1
# 3 144   = 912    --> 26
# 0 163   = 163    --> 1



# 26 1 25 0 26 
# 26 1 26 26 26 