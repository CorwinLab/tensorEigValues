import numpy as np
from matplotlib import pyplot as plt
from scipy.io import savemat

# randTensor = np.random.randn(3, 3, 3)
# np.save("RandomTensor.npy", randTensor)
# savemat("MatRandomTensor.mat", {"myArray": randTensor})
randTensor = np.load("RandomTensor.npy")
# symTensor = 1/6 * (randTensor + np.transpose(randTensor, [0, 2, 1]) + np.transpose(randTensor, [1, 0, 2]) + np.transpose(randTensor, [1, 2, 0]) + np.transpose(randTensor, [2, 0, 1]) + np.transpose(randTensor, [2, 1, 0]))
# randTensor = symTensor
# savemat("MatSymmetric.mat", {"myArray": symTensor})
def to_x(theta, phi):
    return np.sin(theta) * np.cos(phi)

def to_y(theta, phi):
    return np.sin(theta) * np.sin(phi)

def to_z(theta, phi):
    return np.cos(theta)

numSamples = 1000
theta = np.linspace(0, np.pi, numSamples, endpoint=True)
phi = np.linspace(0, 2*np.pi, numSamples, endpoint=True)

theta, phi = np.meshgrid(theta, phi)
thetaflat = theta.flatten()
phiflat = phi.flatten()

xvals = to_x(thetaflat, phiflat)
yvals = to_y(thetaflat, phiflat)
zvals = to_z(thetaflat, phiflat)

print(xvals**2 + yvals**2 + zvals**2)

def getEnergy(vec, tensor):
    return np.einsum('ijk,i,j,k', tensor, vec, vec, vec)

def getVector(vec, tensor):
    return np.einsum('ijk,j,k', tensor, vec, vec)

energy = np.zeros(xvals.shape)

for i in range(len(xvals)):
    vec = np.array([xvals[i], yvals[i], zvals[i]])
    energy[i] = getEnergy(vec, randTensor)
    # print(vec[0]**2 + vec[1]**2 + vec[2]**2)
    # print(energy[i])
m = np.argmax(energy)
print(f'max energy = {energy[m]}, max vec = {xvals[m]}, {yvals[m]}, {zvals[m]}')
print(f'Is this evec? {getVector(np.array([xvals[m], yvals[m], zvals[m]]), randTensor)}')

energy = energy.reshape(theta.shape)

zeigs = np.loadtxt("Zeigs.txt", delimiter=',')
zeigs = zeigs.T 
zeigs = zeigs / np.sqrt(zeigs[:, 0]**2 + zeigs[:, 1]**2 + zeigs[:, 2]**2)[:, None]

for i in range(zeigs.shape[0]):
    print(getEnergy(zeigs[i, :], randTensor))
    print(f'Input Vector: {zeigs[i,:]}')
    print(f'Not the same: {getVector(zeigs[i,:], randTensor)}')
    vecBack = getVector(zeigs[i,:], randTensor)
    vecBack /= np.sqrt(np.sum(vecBack**2))
    print(f'Now the same: {vecBack}')

thetaZ = np.arccos(zeigs[:, 2] / np.sqrt(zeigs[:, 0]**2 + zeigs[:, 1]**2 + zeigs[:, 2]**2))
phiZ = np.sign(zeigs[:, 1]) * np.arccos(zeigs[:, 0] / np.sqrt(zeigs[:, 0]**2 + zeigs[:, 1]**2)) + np.pi

fig, ax = plt.subplots()
ax.set_xlabel(r"$\theta$")
ax.set_ylabel(r"$\phi$")
CS = ax.contourf(theta, phi, energy)
ax.scatter(np.pi - thetaZ, phiZ, color='r', marker='.')
fig.colorbar(CS)
fig.savefig("EnergyLandscape.png", bbox_inches='tight')

# fig, ax = plt.subplots(subplot_kw={"projection": "3d"})
# surf = ax.plot_surface(theta, phi, energy, cmap=cm.coolwarm,
#                        linewidth=0, antialiased=False)
# fig.colorbar(surf)
# fig.savefig("EnergySurface.png", bbox_inches='tight')