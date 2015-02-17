def fourierMatrix(o, d, scalar=1, mod=7):
    for j in range(d):
        for i in range(d):
            print(o**(j*i) * scalar % mod, end=' ') 
        print()