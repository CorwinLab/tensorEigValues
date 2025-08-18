import numpy as np
from matplotlib import pyplot as plt
from tqdm import tqdm

def getEnergy(tensor, vec):
    ten = tensor.copy()
    p = len(tensor.shape)
    for i in range(p):
        ten = np.einsum('i...,i', ten, vec)
    return ten

def to_x(theta, phi):
    return np.sin(theta) * np.cos(phi)

def to_y(theta, phi):
    return np.sin(theta) * np.sin(phi)

def to_z(theta, phi):
    return np.cos(theta)

def makeEnergyLandscape(N, p, numSamples=1000):
    randTensor = np.random.randn(*([N]*p))
    np.save(f"RandTensor{p}.npy", randTensor)

    numSamples = 1000
    theta = np.linspace(0, np.pi, numSamples, endpoint=True)
    phi = np.linspace(0, 2*np.pi, numSamples, endpoint=True)

    theta, phi = np.meshgrid(theta, phi)
    thetaflat = theta.flatten()
    phiflat = phi.flatten()

    xvals = to_x(thetaflat, phiflat)
    yvals = to_y(thetaflat, phiflat)
    zvals = to_z(thetaflat, phiflat)

    energy = np.zeros(xvals.shape)

    for i in tqdm(range(len(xvals))):
        vec = np.array([xvals[i], yvals[i], zvals[i]])
        energy[i] = getEnergy(randTensor, vec)

    return energy.reshape(theta.shape)

N = 3 
p = 15

energy = makeEnergyLandscape(N, p)

fig, ax = plt.subplots()
ax.set_xlabel(r"$\theta$")
ax.set_ylabel(r"$\phi$")
CS = ax.imshow(energy)
fig.colorbar(CS)
fig.savefig(f"EnergyLandscape{p}.png", bbox_inches='tight')

# fig, ax = plt.subplots(subplot_kw={"projection": "3d"})
# surf = ax.plot_surface(theta, phi, energy, cmap=cm.coolwarm,
#                        linewidth=0, antialiased=False)
# fig.colorbar(surf)
# fig.savefig("EnergySurface.png", bbox_inches='tight')