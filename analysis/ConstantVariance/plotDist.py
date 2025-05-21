import numpy as np
from matplotlib import pyplot as plt

def weightsToDist(weights, xvals):
    weights = -weights
    weights = weights - np.max(weights)
    binWidth = np.diff(xvals)[0]
    
    dist = np.exp(weights)
    norm = np.sum(dist * binWidth)
    dist /= norm

    mean = np.sum(dist * xvals * binWidth)
    var = np.sum(dist * xvals**2 * binWidth) - mean**2
    std = np.sqrt(var)

    xvals = (xvals - mean) / std 

    return xvals, dist

weights = np.loadtxt("/mnt/corwinLab/Code/tensorEigValues/metropolisEnsemble/Data/Weights_nc2_N3_ConstantVariance.txt")
weights = weights[1:]
bins = np.linspace(0.25, 14, 30)[1:]

xvals, dist = weightsToDist(weights, bins)

fig, ax = plt.subplots()
ax.set_yscale("log")
ax.plot(bins, dist)
fig.savefig("Dist.png", bbox_inches='tight')
