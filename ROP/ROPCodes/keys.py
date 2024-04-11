key_codes=[
    #
    ['[nul]','[space]',*['@']*14],
    [*['@']*9,'[]',*['@']*6],
    ['i','e','兀',':','$','?',*['@']*6,',','x10','.','@'],
    ['0','1','2','3','4','5','6','7','8','9','[A]','[B]','[C]','[D]','[E]','[F]'],
    ['M','ANS','A','B','C','D','E','F','x','y','PreAns',*['@']*5],
    [*['@']*16],
    ['(',*['@']*5,'Conjg','Arg','Abs','Rnd(',*['@']*2,'sinh','cosh','tanh','sinh-1'],
    ['cosh-1','tanh-1','e^','10^','√','ln','∛','sin','cos','tan','sin-1','cos-1','tan-1','log(',*['@']*2],
    [*['@']*15,'Rep'],
    [*['@']*16],
    [*['@']*5,'=','+','-','*','∻','∻R','·','∠','|P','|C','@'],
    [*['@']*16],
    [*['@']*8,'∟','^(','x√x',*['@']*5],
    [')','@','>a+bi','>r∠0','-1','square','cube','%','!',*['@']*3,'∘','E','P','T'],
    ['G','M','k','m','u','n','p','f',*['@']*8],
    [*['@']*16]
]

tmp_uglyc=[]

def assist_ugly():
    print("Special Characters "+str(len(tmp_uglyc))+":")
    for a in tmp_uglyc:
        print(a,end=' ')
    print("\n")

def byte2keys(b):
    if len(b) != 2:
        return '',False
    y,x = 0,0

    if b[0] >= 'a':
        y = ord(b[0]) -ord('a')+10
    elif '0' <= b[0] <= '9':
        y = ord(b[0]) -ord('0')
    else:
        return '',False
    if b[1] >= 'a':
        x = ord(b[1]) -ord('a')+10
    elif '0' <= b[1] <= '9':
        x = ord(b[1]) -ord('0')
    else:
        return '',False
    try:
        s = key_codes[y][x]
    except:
        tmp_uglyc.append(str(b))
        return '<'+b+'>',True
    if s == '@':
        tmp_uglyc.append(str(b))
        return '<'+b+'>',True
    return key_codes[y][x],True

def b2k(l):
    if l[0]>9:
        l[0]=chr(ord('a')+l[0]-10)
    else:
        l[0]=str(l[0])
    if l[1]>9:
        l[1]=chr(ord('a')+l[1]-10)
    else:
        l[1]=str(l[1])
    return byte2keys((l[0])+(l[1]))[0],str(l[0])+str(l[1])

def ascii2key(char):
    if ord(char)>=ord('0') and ord(char)<=ord('9'):
        return b2k([3,ord(char)-ord('')])
    if char>='A' and char<='O':
        return b2k([4,ord(char)-ord('A')+1])
    if char>='P' and char<='Z':
        return b2k([5,ord(char)-ord('P')])
    if char>='a' and char<='o':
        return b2k([6,ord(char)-ord('a')+1])
    if char>='p' and char<='z':
        return b2k([7,ord(char)-ord('p')])
    if char == ' ':
        return b2k([2,0])
    
def input2str(sz):
    target = input("input string :")
    print(target[0:sz])
    dump = ''
    dumphex = ''
    n = 0
    for c in target:
        a=ascii2key(c)
        dump+=a[0]+' '
        dumphex+=a[1]+' '
        n+=1
        if n >= sz:
            break
    if n<sz:
        dump+='i '*(sz-n)
        dumphex+='20 '*(sz-n)
    return dump,dumphex