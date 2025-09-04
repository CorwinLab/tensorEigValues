import numpy as np
from matplotlib import pyplot as plt
import glob

N = 4
p = 5

files = glob.glob(f"../Data/{p}/{N}/Typical*.txt")

eigvalues = []

for f in files: 
    eigs = np.loadtxt(f)
    eigvalues.append(-eigs)

eigvalues = np.sqrt(np.array(eigvalues).flatten())

fig, ax = plt.subplots()
ax.set_yscale("log")
ax.set_xscale("log")
# ax.set_xlim([10**-1, 10])
ax.set_xlabel(r"$\omega$")
ax.set_ylabel(r"$D(\omega)$")
ax.hist(eigvalues, bins='fd', density=True, histtype='step', color='b', label='Typical Minimum')

files = glob.glob(f"../Data/{p}/{N}/Max*.txt")

eigvalues = []

for f in files: 
    eigs = np.loadtxt(f)
    eigvalues.append(-eigs)

eigvalues = np.sqrt(np.array(eigvalues).flatten())
ax.hist(eigvalues, bins='fd', density=True, histtype='step', color='r', label='Global Minimum')

ax.legend(loc='upper left')
fig.savefig(f"Distribution_N-{N}_p-{p}.png", bbox_inches='tight')