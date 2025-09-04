import numpy as np
from tqdm import tqdm

def readAllZEigs(topDir, numDirs, numFiles):
    allZ = -np.ones((numDirs*numFiles,400))
    col = 0
    for dir in tqdm(range(numDirs)):
        # print(dir)
        for file in range(numFiles):
            temp = np.array(np.loadtxt(f'{topDir}/{dir}/EigenValues{file+1}.txt'))
            temp = temp[temp>=0]
            allZ[col, :len(temp)] = temp
            col += 1
    return allZ

if __name__ == '__main__':
    topDir = '/mnt/talapasShared/AllEigenValues/Cyclic/9'
    numDirs = 1000
    numFiles = 100

    allZ = readAllZEigs(topDir, numDirs, numFiles)
    np.savetxt("AllZeigsCyclicN9.txt", allZ)