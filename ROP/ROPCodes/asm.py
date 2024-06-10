import sys
import keys
import struct
import re

padding_char= ['.','.']
class BinMap():
    
    
    
    def __init__(self, arg) -> None:
        self.lowest_addr = 1024*128
        self.largest_addr = 0
        if isinstance(arg,int):
            self.bin_size = arg
            self.bin_data = []
            for i in range(arg):
                tmp = []
                tmp.append('.')
                tmp.append('.')
                self.bin_data.append(tmp)
        elif isinstance(arg,list):
            self.bin_data = list
            self.bin_size = len(list)
        else:
            raise Exception("Invalid arguments for BinMap!")
    
    def die(self,text):
        print('\033[38;2;255;0;0m' + 'Memory-arrangement Error!' + '\033[0m')
        print('\033[33m'+'--> \033[34m'+text+'\033[0m')
        exit(-1)
    
    def try_write(self,offset,val:str):
        if offset < self.lowest_addr:
            self.lowest_addr = offset
        if offset > self.largest_addr:
            self.largest_addr = offset
        a,b = val[0],val[1]
        if self.bin_data[offset][0] != '.' and self.bin_data[offset][0] != a and a != '.':
            self.die('Conflict in writing to segment: '+hex(offset)+', already written as: '+self.bin_data[offset][0])
        if a!='.':
            self.bin_data[offset][0]=a 
        if self.bin_data[offset][1] != '.' and self.bin_data[offset][1] != b and b != '.':
            self.die('Conflict in writing to segment: '+hex(offset)+', already written as: '+self.bin_data[offset][1])
        if b != '.':
            self.bin_data[offset][1]=b 

    def write_n(self,data,dst_offset,size,src_offset=0):
        if isinstance(data,BinMap):
            if dst_offset+size > self.bin_size or src_offset + size > data.bin_size:
                self.die('Mem write exceed maximum address! try to access:'+hex(dst_offset+size))
            for i in range(size):
                self.try_write(dst_offset+i,data.bin_data[src_offset+i])
        else:
            raise Exception("Bad type for data!")

    def padding(self,size,offset=0,ch=padding_char):
        for i in range(size):
            self.try_write(offset+i, ch)
    
    def append_val(self,offset,val):
        self.try_write(offset,val)
    def append_num(self,offset,num,need_void = False):
        low = num % 0x10
        hi = num // 0x10
        a,b='.','.'
        if hi != 0 or need_void:
            a = hex(hi).removeprefix('0x')
        if low != 0 or need_void:
            b = hex(low).removeprefix('0x')
        self.try_write(offset,a+b)
        
    def append_sym_adr(self,adr:int,offset):
        hi = adr % 0x100
        self.append_num(offset,hi,True)
        adr //= 0x100
        mid = adr % 0x100
        self.append_num(offset+1,mid,True)
        adr //= 0x100
        if adr == 0:
            self.try_write(offset+2,'.0')
        else:
            self.append_num(offset+2,adr)
        self.try_write(offset+3,padding_char)
    
    def append_adr(self,adr:int,offset):
        hi = adr % 0x100
        self.append_num(offset,hi,True)
        lo = adr // 0x100
        self.append_num(offset+1,lo,True)
    
    def generate(self,rep = True):
        result=''
        # print('Low: '+hex(self.lowest_addr))
        # print('High: '+hex(self.largest_addr))
        sz_need = self.largest_addr - self.lowest_addr+1
        result+= '---> '+hex(self.lowest_addr)+'<---\n'
        for i in range(sz_need):
            if i % 16 == 0:
                result+='\n'
            ch = self.bin_data[i+self.lowest_addr]
            a,b = ch[0],ch[1]
            if rep:
                if a == '.':
                    a='3'
                if b == '.':
                    b='2'
            result +=a
            result +=b
            result +=' '
                # if 1st digit is '.', '3' is likely the best choice
        result+= '\n\n---> '+hex(self.largest_addr)+'<---\nTotal: '+str(sz_need)+'bytes!'
        
        return result

class ROPAssembler():
    def __init__(self, func_list) -> None:
        self.func_list = func_list
        self.segment_addr = 0xd522
        self.output = BinMap(1024 * 64) # 64k memory
        self.no_line = 0
        self.parent_seg_addr = 0
        self.is_second_pass = False
        self.labels = []
        self.current_src = ''
        self.symbols = []
        
    def die(self,text):
        print('\033[38;2;255;0;0m' + 'Syntax Error!' + '\033[0m')
        print('At Line: ' + '\033[38;2;0;255;0m' + str(self.no_line)+'\033[0m'+' Around: '+self.current_src)
        print('\033[33m'+'--> \033[34m'+text+'\033[0m')
        exit(-1)
        
    def consume_line(self,src:str):
        src = src.strip()
        segs = [item.strip() for item in src.split(' ') if item.strip() != '']
        return segs
    
    def consume_single_num(self,src:str):
        segs = self.consume_line(src)
        if segs[0].startswith('0x'):
            n = segs[0].removeprefix('0x')
            
            return int(n,16)
        else:
            n = segs[0]
            if not n.isnumeric():
                self.die('Expect a number (a 10-base number or a 16-base number START with "0x")')
            return int(n,10)
    
    def consume_hex_literal(self,src:str):
        segs = self.consume_line(src)
        for i in segs:
            if i == '':
                continue
            if i.startswith(';'):
                break
            if len(i) != 2:
                self.die('Expect 2-character hex after "hex"')
            if self.is_second_pass:
                self.output.append_val(self.segment_addr,i)
            self.segment_addr+=1
        
    def search_label(self,name):
        for i in self.labels:
            if i[0] == name:
                return i
        return ['',0]    
        
        
    def consume_org(self,src):
        segs = self.consume_line(src)
        addr = 0
        if len(segs) == 0:
            self.die("Expect args after org")
        if segs[0].startswith('&'):
            lb_name = segs[0].removeprefix('&')
            offset = 0
            if lb_name == '':
                offset = self.segment_addr
            else:
                lb = self.search_label(lb_name)
                if lb[0] == '':
                    self.die('Fail to find label: '+lb_name)
                offset = lb[1]
            if len(segs)>1 and segs[1] != '{':
                num = int(segs[1])
                offset += num
            addr = offset
        else:
            addr = self.consume_single_num(src)
        
        old_addr = self.segment_addr
        self.segment_addr = addr
        if len(segs)>1:
            if segs[len(segs)-1] == '{':
                self.parent_seg_addr = old_addr
    
    def consume_adr(self,src):
        segs = self.consume_line(src)
        if len(segs) == 0:
            if self.is_second_pass:
                self.output.append_adr(self.segment_addr,self.segment_addr)
            self.segment_addr+=2
            return
        name = segs[0]
        lb_find = ['',0]
        for i in self.labels:
            if i[0] == name:
                lb_find = i
                break
        if lb_find[0]=='':
            # may be it is a number
            try:
                num = int(name)
                if self.is_second_pass:
                    self.output.append_adr(num+self.segment_addr,self.segment_addr)
                self.segment_addr+=2
                return
            except Exception as e:
                self.die('Cannot find label: '+name)
            
        addr = lb_find[1]
        if len(segs)>1:
            offset = int(segs[1])
            addr += offset
        if self.is_second_pass:
            self.output.append_adr(addr,self.segment_addr)
        self.segment_addr+=2
        
    def solve_sym(self, src:str,sep = ''):
        if src.startswith('[') and src.endswith(']'):
            return ['',0]
        segs = []
        if sep == '':
            src = src.replace('\t','    ')
            segs = src.split('       ')
        else:
            segs = self.consume_line(src)
        if src == '':
            return ['',0,0]
        offset = 0
        if len(segs) != 2:
            print(segs)
            self.die('Bad symbol format: '+src)
        if segs[0].startswith('@'):
            offset = 2
            segs[0]=segs[0].removeprefix('@')
        addr_raw = segs[0]
        addr = int(addr_raw[:5],16)+offset
        param_num = re.search(r'\([0-9]+\)',addr_raw)
        pop_num = 0
        if param_num:
            raw = param_num.group()
            pop_num = int(raw.removeprefix('(').removesuffix(')'))
        name = segs[1].strip()
        return [name,addr,pop_num]
    
    def consume_def(self,src):
        segs = self.consume_line(src)
        if len(segs) != 2:
            self.die('Need def [addr](N-pops) [name] to define a symbol!')
        sym = self.solve_sym(src,' ')
        if sym[0] == '':
            self.die('Fail to solve the symbol!')
        self.symbols.append(sym)
        print('Def: '+sym[0]+' : '+hex(sym[1])+' : '+str(sym[2]))
    
    def line_parse(self,src:str,no_line):
        self.no_line = no_line
        src = src.strip().lower()
        src = re.sub(r';.*','',src)
        self.current_src = src
        if src.startswith('space'):
            padding = self.consume_single_num(src.removeprefix('space'))
            if self.is_second_pass:
                self.output.padding(padding,offset=self.segment_addr)
            self.segment_addr+=padding
        elif src.startswith('hex'):
            self.consume_hex_literal(src.removeprefix('hex'))
        elif src.startswith('org'):
            self.consume_org(src.removeprefix('org'))
        elif src.startswith('}'):
            if self.parent_seg_addr:
                self.segment_addr = self.parent_seg_addr
                self.parent_seg_addr = 0
            else:
                self.die('"}" must be matched with a "org {"')
        elif src.startswith('adr'):
            if self.is_second_pass:
                self.consume_adr(src.removeprefix('adr'))
            else:
                self.segment_addr+=2
        elif src.startswith('def'):
            if not self.is_second_pass:
                self.consume_def(src.removeprefix('def'))
        elif src.startswith(';') or src=='':
            pass
        else:
            possibles = self.consume_line(src)
            if possibles[0].endswith(':'):
                # label
                name = possibles[0].removesuffix(':')
                if not self.is_second_pass:
                    self.labels.append([name,self.segment_addr])
            else:
                res = re.search(r'\(.*\)',src)
                param:str = ''
                if res:
                    param = res.group()
                if param != '':
                    src = src.replace(param,'')
                name = src
                sym = self.find_symbol(name)
                if sym[0] == '':
                    self.die('Fail to find symbol: '+name)
                if self.is_second_pass:
                    self.output.append_sym_adr(sym[1],self.segment_addr)
                self.segment_addr+=4
                if param != '':
                    param = param.removeprefix('(').removesuffix(')')
                    param = param.strip().lower()
                    self.consume_hex_literal(param)
                
                
    
    def parser_codes(self,src:str,type = True):
        lines = src.splitlines()
        self.is_second_pass = False
        no_line = 1
        for i in lines:
            self.line_parse(i,no_line)
            no_line+=1
        print("First Pass : Get labels...")
        print("---> Labels <---")
        for i in self.labels:
            print('[name:'+i[0]+',addr:'+hex(i[1])+']')
        print("--->  End   <---")
        print("Second Pass : Generate codes...")
        self.is_second_pass = True
        self.segment_addr = 0xd522
        no_line = 1
        for i in lines:
            self.line_parse(i,no_line)
            no_line+=1
        
        print(self.output.generate(type))
    
    def find_symbol(self,name:str):
        name = name.strip()
        for i in self.symbols:
            if i[0] == name:
                return i  
        return ['',0]
    
    def load_symbols(self,sym_file):
        lines = []
        with open(sym_file,encoding='utf-8') as f:
            lines = [re.sub(r';.*','',i).strip().lower() for i in f.readlines()]
        for i in lines:
            sym = self.solve_sym(i)
            if sym[0] != '':
                self.symbols.append(sym)
                print('Load: '+sym[0]+' : '+hex(sym[1])+' : '+str(sym[2]))

p_dot = True

if __name__ == '__main__':
    if len(sys.argv)<2:
        print('Need input file')
        exit(-1)
    if len(sys.argv)>2:
        if sys.argv[2] == '-min':
            p_dot = False
    with open(sys.argv[1],encoding='utf-8') as f:
        codes = f.read()
        asm = ROPAssembler([])
        asm.load_symbols('./sym.txt')
        asm.parser_codes(codes,p_dot)