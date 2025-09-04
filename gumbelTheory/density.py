import numpy as np
from matplotlib import pyplot as plt
from scipy.special import gamma
from scipy.stats import norm
from scipy.optimize import curve_fit
from tqdm import tqdm

plt.rcParams.update({'font.size': 20, 'text.usetex': True, 'text.latex.preamble': r'\usepackage{amsfonts}'})

def omega(x):
    return 2 * np.pi ** (x / 2) / gamma(x / 2)

def rho(u, N, p, numSamples=100):
    omegaN = omega(N) * ((p-1) / (2 * np.pi) * (N-1)) ** ((N-1)/2)
    gaussian = 1 / np.sqrt(2 * np.pi * N) * np.exp(-u**2 / (2 * N))
    meanDet = getMeanDeterminant(u, N, p, numSamples)
    return omegaN * gaussian * meanDet

def getGOE(N):
    randMatrix = np.random.randn(N-1, N-1)
    return (randMatrix + randMatrix.T) / np.sqrt(2 * N)

def gammaP(p): 
    return np.sqrt(p / (p-1))

def getMeanDeterminant(u, N, p, numSamples=100):
    identity = np.identity(N-1)
    identityPrefactor = identity * gammaP(p) * u / np.sqrt(N *(N-1))
    
    determinants = np.zeros(numSamples)
    for i in range(numSamples):
        matrix = getGOE(N) - identityPrefactor
        det = np.abs(np.linalg.det(matrix))
        determinants[i] = det 

    return np.mean(determinants)

def mN(N):
    return (0.366915 + 1.657 * N - 0.799973 * np.log(N)) / np.sqrt(N)

def gaussian(xvals, mean, var, A):
    return A*norm.pdf(xvals, mean, np.sqrt(var))

def stretchedExponential(xvals, mean, var, A):
    return A * np.exp(-np.abs(xvals-mean)**2 / var)

def japanDensity(xvals, N):
    ''' This distribution shouldn't match whate we're doing'''
    alpha = 1/2
    return 2 **(2 - N/2) * alpha**(1/2) ** np.pi**(-1/2) * gamma(N+1) / gamma(N/2) / gamma(N / 2 + 1) * np.exp(-alpha / 4 *xvals**2)

if __name__ == '__main__':
    N = 9
    p = 3
    xvals = np.linspace(-50, 50, num=100)

    rhoVals = np.zeros(xvals.shape)

    for i, x in tqdm(enumerate(xvals)):
        rhoVals[i] = rho(x, N, p, numSamples=100000)
    
    parameters, _ = curve_fit(stretchedExponential, xvals, rhoVals)

    allZeigs = np.loadtxt('/mnt/talapasShared/AllEigenValues/Cyclic/allZeigsCyclicN9.txt')
    nSystems = 1000000

    fig, ax = plt.subplots()
    ax.set_yscale('log')
    ax.set_ylim([10**-7, max(rhoVals) * 2])
    ax.set_xlabel(r"$x$")
    ax.set_ylabel(r"$\rho_N(x)$")
    ax.plot(xvals, rhoVals)
    # ax.plot(xvals, stretchedExponential(xvals, *parameters), ls='--', c='g')
    counts, bins = np.histogram(allZeigs * np.sqrt(N), bins=50)
    np.savetxt("Counts9.txt", counts)
    np.savetxt("Bins9.txt", bins)
    bins = np.loadtxt("Bins9.txt")
    counts = np.loadtxt("Counts9.txt")
    nSystems = 1000000
    ax.set_xlim([min(bins), max(bins)])
    plt.plot((bins[:-1]+bins[1:])/2, counts/nSystems/(bins[1]-bins[0]), ls='--', c='k')
    fig.savefig(f"Rho{N}_{p}.pdf", bbox_inches='tight')