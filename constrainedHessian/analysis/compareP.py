import numpy as np
from matplotlib import pyplot as plt
import glob


fig, ax = plt.subplots()
ax.set_yscale("log")
ax.set_xscale("log")
ax.set_xlim([10**-1, 20])
ax.set_xlabel(r"$\omega$")
ax.set_ylabel(r"$D(\omega)$")


for p, N in [[3, 7], [3, 8], [5, 4]]:
    files = glob.glob(f"../Data/{p}/{N}/Max*.txt")

    eigvalues = []

    for f in files: 
        eigs = np.loadtxt(f)
        eigvalues.append(-eigs)

    eigvalues = np.array(eigvalues) / np.sqrt(N) ** (p-2)

    eigvalues = np.sqrt(np.array(eigvalues).flatten())
    ax.hist(eigvalues, bins='fd', density=True, histtype='step', label=f"p={p}, N={N}")

ax.legend(loc='upper left')
fig.savefig("Comparep.png", bbox_inches='tight')