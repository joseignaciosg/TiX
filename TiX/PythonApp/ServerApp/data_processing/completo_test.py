import scipy
import scipy.optimize
import os
from multiprocessing.pool import ThreadPool

def loop(arg):
    print "%s" % os.getpid()

def start():
    pass

pool = ThreadPool(processes=1, initializer=start)

class A:
    def hola(self):
        pool.apply(self.chau,[1])

    def chau(self, a):
        print a

a = A()

a.hola()
