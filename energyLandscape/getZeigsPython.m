arrayStruct = load("MatSymmetric.mat");
arr = arrayStruct.myArray;
[lambda, V] = zeig(arr);
writematrix(V, "Zeigs.txt")
eigs = [0.6213542412361578, -0.42855706806166605, -0.6559403527091675];
disp(lambda)
disp(V);