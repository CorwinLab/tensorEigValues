import numpy as np
from matplotlib import pyplot as plt
import glob


fig, ax = plt.subplots()
ax.set_yscale("log")
ax.set_xscale("log")
ax.set_xlim([10**-1, 10])
ax.set_xlabel(r"$\omega$")
ax.set_ylabel(r"$D(\omega)$")

for N in [7, 8]:
    files = glob.glob(f"../Data/{N}/Max*.txt")

    eigvalues = []

    for f in files: 
        eigs = np.loadtxt(f)
        eigvalues.append(-eigs)

    eigvalues = np.sqrt(np.array(eigvalues).flatten())
    ax.hist(eigvalues, bins='fd', density=True, histtype='step', label=N)

ax.legend(loc='upper left')
fig.savefig("CompareN.png", bbox_inches='tight')