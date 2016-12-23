import sys, os
sys.path.insert(0, os.path.abspath('../'))
sys.path.insert(0, os.path.abspath('../../fhpclib'))

from unittest import TestCase
import unittest
from myhdl import block, instances, instance, intbv, Signal, ResetSignal, always, delay
from random import randrange
from fhpc import fifo, bus
from acorn import acorn

class TestAcorn(TestCase):
    
    def testBuffer(self):
        """ Check that buffer can be write and read """
        ADDR = 8
        DATA = 8
        OFFSET = 8
        LOWER = 0
        UPPER =2**ADDR-4
        WATCHDOG = 3000
        SIMULATION = True
         
        def createbuff(DATA, ADDR):
            return [Signal(intbv(randrange(2**DATA))) for i in range(2**4)]
        
        @block
        def test_acorn(): 
            clk = Signal(bool(0))
            rst = ResetSignal(0, active=1, async=False)
            keybus, ivbus, adbus, mbus, cbus = [bus.databus(DATA=DATA, ADDR=ADDR) for i in range(5)]
            start, encrypt, busy = [Signal(bool(0)) for i in range(3)]
            acorn_inst = acorn.acorn(clk, rst, keybus, ivbus, adbus, mbus, cbus, start, encrypt, busy,
                               DATA=DATA, ADDR=ADDR, LOWER=LOWER, UPPER=UPPER, OFFSET=OFFSET, SIMULATION=SIMULATION)
            
            
            @always(delay(8))
            def clkgen():
                clk.next = not clk
            
            keyArray = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f]
            ivArray  = [0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f]
            #ivArray  = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
            
            @instance
            def stimulus():
                yield delay(20)
                rst.next = 1
                yield delay(20)
                rst.next = 0
                yield delay(20)
                
            @instance
            def write():
                keybus.we.next = 0
                ivbus.we.next = 0
                start.next = 0
                yield delay(50)
                
                for key in keyArray:                        
                    yield clk.posedge
                    while keybus.inbusy:
                        keybus.we.next = 0
                        yield clk.posedge                        
                    keybus.we.next = 1                    
                    keybus.din.next = key                    
                yield clk.posedge
                keybus.we.next = 0
                
                for iv in ivArray:                        
                    yield clk.posedge
                    while ivbus.inbusy:
                        ivbus.we.next = 0
                        yield clk.posedge                        
                    ivbus.we.next = 1                    
                    ivbus.din.next = iv
                yield clk.posedge
                ivbus.we.next = 0
                
                start.next = 1
                yield clk.posedge
                start.next = 0
                
            '''@instance
            def read():
                watchdog = 30
                watchctr = 0
                yield delay(250)
                j = 0
                while 1:
                    yield outclk.posedge
                    if watchctr == watchdog:
                        watchctr = 0
                        break
                        
                    if hfull:# not outbusy:
                        rd.next = Signal(bool(1))
                    else:
                        rd.next = Signal(bool(0))
                        watchctr = watchctr + 1
                        #print watchctr
                        
                    if (rdout):
                        print hex(dout), hex(rambuff[j])
                        #self.assertEqual(dout, rambuff[j])
                        j = j + 1
                        
                yield outclk.posedge
                rd.next = Signal(bool(0))'''
                
                
            return instances()
        
        
        tb = test_acorn()
        tb.config_sim(trace=True)
        tb.run_sim(duration=3500)
        tb.quit_sim()

    
if __name__ == '__main__':
    unittest.main()
