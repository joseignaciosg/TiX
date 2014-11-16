import scipy
import scipy.optimize
from multiprocessing.pool import ThreadPool

def loop(arg):
    fitfunc = lambda p, x: p[0]*scipy.exp(-(x-p[1])**2/(2.0*p[2]**2))
    errfunc = lambda p, x, y: fitfunc(p,x)-y
    p0 = scipy.c_[95,          12352.67737385,   4500.65737385];
    xcorr = (7852.02,8102.05652077,8352.09304154,8602.12956231,8852.16608308,9102.20260385,9352.23912462,9602.27564539,9852.31216616,10102.3486869,10352.3852077,10602.4217285,10852.4582492,11102.49477,11352.5312908,11602.5678115,11852.6043323,12102.6408531,12352.6773739,12602.7138946,12852.7504154,13102.7869362);
    ycorr = (2,4,3,3,11,21,43,43,47,54,55,73,76,77,69,75,80,79,95,85,78,68)
    p1, success = scipy.optimize.leastsq(errfunc, p0.copy()[0], args=(xcorr,ycorr))
    print "Did calc"

def start():
    pass

pool = ThreadPool(processes=1, initializer=start)
pool.map(loop, xrange(0,10000))

