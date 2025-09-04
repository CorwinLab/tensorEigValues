import numpy as np
from matplotlib import pyplot as plt
from scipy.stats import norm

N = 9
poissonData = np.loadtxt("./Data/PPP.txt")
zeigData = np.loadtxt('./Data/AllZeigsCyclicN9.txt')

minColumn = np.argmax((zeigData < 0).all(axis=0))
zeigData = zeigData[:10000, :minColumn]

# Have to rescale by sqrt(N) to match theory
zeigData = zeigData * np.sqrt(N)

flat = zeigData.flatten()
flat = flat[flat > 0]

poissonData = poissonData[:zeigData.size]
poissonData = poissonData.reshape(zeigData.shape)

maxZeigs = np.max(zeigData, axis=1)
signZeigs = np.sign(zeigData)
poissonData = poissonData * signZeigs

poissonMax = np.max(poissonData, axis=1)
normalizedMax = (poissonMax - np.mean(poissonMax)) / np.std(poissonMax)

normalizedZeigs = (maxZeigs - np.mean(maxZeigs)) / np.std(maxZeigs)

xvals = np.linspace(min(normalizedMax), max(normalizedMax), num=500)

fig, ax = plt.subplots()
ax.set_yscale("log")
ax.hist(normalizedZeigs, bins='fd', histtype='step', density=True)
ax.hist(normalizedMax, bins='fd', histtype='step', color='k', density=True)
# ax.plot(xvals, norm.pdf(xvals), ls='--')
fig.savefig("MaxZeigs.png", bbox_inches='tight')

fig, ax = plt.subplots()
ax.set_yscale("log")
ax.hist(flat, density=True, bins=500, histtype='step')
ax.hist(poissonData.flatten(), density=True, bins=500, color='k', histtype='step')
fig.savefig("DensityofPoisson.png")