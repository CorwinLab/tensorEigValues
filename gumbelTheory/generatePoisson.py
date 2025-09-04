import numpy as np
from matplotlib import pyplot as plt
from scipy.interpolate import interp1d
from scipy import integrate

bins = np.loadtxt("./Data/Bins9.txt")
counts = np.loadtxt("./Data/Counts9.txt")
nSystems = 1000000

binCenter= (bins[:-1]+bins[1:])/2
lambdaVals = counts/np.sum(counts)

# Just take the positive values
lambdaVals = lambdaVals[binCenter > 0]
binCenter = binCenter[binCenter > 0]

lambdaCurve = interp1d(binCenter, lambdaVals)
LambdaIntegral = integrate.simps(lambdaVals, binCenter)

maxVal = max(binCenter)
minVal = min(binCenter)

numPoints = 1_000_000_000
data = np.zeros(numPoints)

pointsGenerated = 0
while pointsGenerated < numPoints:
    randomSample = np.random.uniform(minVal, maxVal)
    if np.random.uniform() < (lambdaCurve(randomSample) / LambdaIntegral):
        data[pointsGenerated] = randomSample
        pointsGenerated += 1
    if pointsGenerated % 10_000 == 0:
        print(pointsGenerated)
np.savetxt("./Data/PPPLarge.txt", data)

data = np.loadtxt("./Data/PPPLarge.txt")

fig, ax = plt.subplots()
ax.plot(binCenter, lambdaVals / LambdaIntegral, c='k')
ax.hist(data, histtype='step', color='r', bins='fd', density=True)
fig.savefig("PPPLarge.png", bbox_inches='tight')