import sys, os
sys.path.insert(0, os.path.abspath('../../fhpclib'))

from myhdl import block, instances, instance, intbv, Signal, ResetSignal, always, delay, modbv, enum, always_seq, always_comb
from fhpc import fifo, dpram, bus
  
DATA=8
ADDR=8
LOWER=4
UPPER=2**ADDR-4
OFFSET=8
SIMULATION=True

@block
def acorn(clk, rst, keybus, ivbus, adbus, mbus, cbus, start, encrypt, busy,
          DATA=DATA, ADDR=ADDR, LOWER=LOWER, UPPER=UPPER, OFFSET=OFFSET, SIMULATION=SIMULATION):

    abus, bbus = [bus.rambus(DATA=DATA, ADDR=16) for i in range(2)]
    keyCtr = Signal(modbv(0)[8:])
    bCtr = Signal(modbv(0)[8:])
    byteCtr = Signal(modbv(0)[8:])
    keySize = Signal(modbv(0)[8:])
    ivSize = Signal(modbv(0)[8:])
    mreg = Signal(modbv(0)[8:])
    mregEn = Signal(bool(0))
    mregBusy = Signal(bool(0))
    
    keyFifo = fifo.fifobus(clk, keybus, rst,
                           DATA=DATA, ADDR=ADDR, LOWER=LOWER, UPPER=UPPER, OFFSET=OFFSET, SIMULATION=SIMULATION)
    ivFifo  = fifo.fifobus(clk, ivbus, rst,
                           DATA=DATA, ADDR=ADDR, LOWER=LOWER, UPPER=UPPER, OFFSET=OFFSET, SIMULATION=SIMULATION)
    adFifo  = fifo.fifobus(clk, adbus, rst,
                           DATA=DATA, ADDR=ADDR, LOWER=LOWER, UPPER=UPPER, OFFSET=OFFSET, SIMULATION=SIMULATION)
    mFifo   = fifo.fifobus(clk, mbus, rst,
                           DATA=DATA, ADDR=ADDR, LOWER=LOWER, UPPER=UPPER, OFFSET=OFFSET, SIMULATION=SIMULATION)
    cFifo   = fifo.fifobus(clk, cbus, rst,
                           DATA=DATA, ADDR=ADDR, LOWER=LOWER, UPPER=UPPER, OFFSET=OFFSET, SIMULATION=SIMULATION)
    
    msgRam  = dpram.dpram_bus(abus, bbus, clk, ADDR, DATA, SIMULATION)
    
    t_State = enum('IDLE', 'KEYREAD', 'IVREAD', 'ENC', 'ERROR')
    state = Signal(t_State.IDLE)
    
    #@always_comb
    #def logic():
    #    pass
        
    @always_seq(clk.posedge, reset = rst)    
    def stateMachine():
        if state == t_State.IDLE:
            if start:
                state.next = t_State.KEYREAD
                keyCtr.next = 0
                bCtr.next = 0
                keySize.next = keybus.level
                ivSize.next  = ivbus.level
                keybus.rd.next = 1
        if state == t_State.KEYREAD:
            abus.din.next = keybus.dout
            abus.addr.next = keyCtr
            abus.we.next = keybus.rdout
            if keybus.rdout:
                keyCtr.next = keyCtr + 1
            if keyCtr == keySize:
                keybus.rd.next = 0
                ivbus.rd.next = 1
                state.next = t_State.IVREAD
        if state == t_State.IVREAD:
            abus.din.next = ivbus.dout
            abus.addr.next = keyCtr
            abus.we.next = ivbus.rdout
            if ivbus.rdout:
                keyCtr.next = keyCtr + 1
            if keyCtr == keySize + ivSize:
                state.next = t_State.ENC
                keyCtr.next = 0
                byteCtr.next = 0
        if state == t_State.ENC:
            abus.addr.next = keyCtr
            byteCtr.next = byteCtr + 1
            if byteCtr == 2:
                mregEn.next = 1
                mreg.next = abus.dout
            else:
                mregEn.next = 0                
                mreg.next = mreg >> 1
            if byteCtr == 7:
                byteCtr.next = 0
                keyCtr.next = keyCtr + 1
            
    
    
    return instances()

@block
def maj(x, y, z, o):
    @always_comb
    def logic():
        o.next = ((x & y) ^ (x & z) ^ (y & z))
    return instances()
    
@block
def ch(x, y, z, o):
    @always_comb
    def logic():
        o.next = ((x & y) ^ ((x ^ 1) & z))
    return instances()
    
@block
def KSG128(state, o):
    majOut = Signal(bool(0))
    
    maj_inst = maj(state[235], state[61], state[193], majOut)
    @always_comb
    def logic():
        o.next = state[12] ^ state[154] ^ majOut
    return instances()
   
@block 
def FBK128(state, ca, cb, ks, f):
    majOut = Signal(bool(0))
    chOut = Signal(bool(0))
    
    KSG128_inst = KSG128(state, ks)
    maj_inst = maj(state[244], state[23], state[160], majOut)
    ch_inst = ch(state[230], state[111], state[66], chOut)
    
    @always_comb
    def logic():
        f.next = (state[0] ^ (state[107] ^ 1) ^ majOut ^ chOut ^ (ca & state[196]) ^ (cb & ks))
    return instances()
    
    
@block 
def Encrypt_StateUpdate128_1bit(clk, rst, state, plaintextbit, ks, ca, cb, ciphertextbit):
    state0 = Signal(modbv(0)[292:])
                
    FBK128_inst = FBK128(state, ca, cb, ks, f)
    
    @always_comb
    def logic():
        state0[292:290].next = state[292:290]
        state0[289:231].next = state[289:231]
        state0[230:194].next = state[230:194]
        state0[193:155].next = state[193:155]
        state0[154:108].next = state[154:108]
        state0[107: 62].next = state[107: 62]
        state0[ 61:  0].next = state[ 61:  0]
        state0[289].next = state[289] ^ state[235] ^ state[230]
        state0[230].next = state[230] ^ state[196] ^ state[193]
        state0[193].next = state[193] ^ state[160] ^ state[154]
        state0[154].next = state[154] ^ state[111] ^ state[107]
        state0[107].next = state[107] ^ state[ 66] ^ state[ 61]
        state0[ 61].next = state[ 61] ^ state[ 23] ^ state[  0]
    
    @always_seq(clk.posedge, reset = rst)
    def stateUpdate():
        state[292:].next = state0[293:1]
        state[292] = f ^ plaintextbit
        ciphertextbit = ks ^ plaintextbit
    return instances()
    
@block
def acorn128_enc_onebyte(state, plaintextbyte, cabyte, cbbyte):
    ciphertextbyte = 0
    kstem = 0
    ksbyte = 0
    for i in range(8):
        ca = (cabyte >> i) & 1
        cb = (cbbyte >> i) & 1
        plaintextbit = (plaintextbyte >> i) & 1
        #print(plaintextbit)
        state, kstem, ciphertextbit = Encrypt_StateUpdate128_1bit(state, plaintextbit, kstem, ca, cb)
        ciphertextbyte |= (ciphertextbit << i)
        ksbyte |= (kstem << i)
    return state, ksbyte, ciphertextbyte

def acorn128_initialization(key, iv):
    state = [0 for i in range(294)]
    m = key + iv + [key[i & 0xf] for i in range(32, 224)]    
    m[32] ^= 1
    m += [0]*(293-len(m)+1)
    for i in range(224):
        #print(m[i])
        state, ksbyte, ciphertextbyte = acorn128_enc_onebyte(state, m[i], 0xff, 0xff)
    return state

#the finalization state of acorn
def acorn128_tag_generation(msglen, adlen, maclen, mac, state):
    plaintextbyte  = 0
    ciphertextbyte = 0
    ksbyte = 0
    for i in range(int(768/8)):
        state, ksbyte, ciphertextbyte = acorn128_enc_onebyte(state, plaintextbyte, 0xff, 0xff)
        if i >= (768/8 - 16):
            mac[i-(int(768/8)-16)] = ksbyte
    return mac
    