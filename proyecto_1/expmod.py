
def concatena_binario(msb, lsb):
    msb_binario = bin(msb)[2:].zfill(8)
    lsb_binario = bin(lsb)[2:].zfill(8)
    numero_binario = msb_binario + lsb_binario
    numero_decimal = int(numero_binario, 2) 
    print(numero_decimal)
    return numero_decimal


def fastExpMod(base, expo, n):
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
    fastExpMod(base, d, n)

expmod(20, 104, 200, 50)


# 0 5       --> 25
# 234 55    --> 1
# 2 54      --> 26
# 20 104    --> 26