import numpy as np
from matplotlib import pyplot as plt

def gaussian(x, mean, var):
    return 1/ np.sqrt(2 * np.pi * var) * np.exp(-(x - mean)**2 / 2 / var)

def gumbelDistribution(x, mu, beta):
    z = (x - mu) / beta 
    return 1 / beta * np.exp(-(z + np.exp(-z)))

beta = np.sqrt(6 / np.pi**2)
mu = -beta * np.euler_gamma

xvals = np.linspace(-5, 6)

dir = f'/mnt/talapasShared/EigenValues/Cyclic/CyclicN9.txt'
maxZEigs = np.loadtxt(dir, delimiter=',')[:, 0]
maxZEigs = (maxZEigs - np.mean(maxZEigs)) / np.std(maxZEigs)

nSystems = len(maxZEigs)
nGaussianSamples = 10000
randomGaussian = np.random.randn(nSystems, nGaussianSamples)

maxGauss = np.max(randomGaussian, axis=1)
maxGauss = (maxGauss - np.mean(maxGauss)) / np.std(maxGauss)

fig, ax = plt.subplots()
ax.set_yscale("log")
ax.set_ylim([10**-5, 1])
ax.hist(maxGauss, density=True, histtype='step', bins='fd', color='g')
ax.hist(maxZEigs, density=True, histtype='step', bins='fd')
ax.plot(xvals, gaussian(xvals, 0, 1), ls='--', c='r')
ax.plot(xvals, gumbelDistribution(xvals, mu, beta), c='k', ls='--')
fig.savefig("MaxGaussian.png", bbox_inches='tight')