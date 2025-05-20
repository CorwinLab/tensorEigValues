classdef metropolisRangeEnsemble
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        logWeights
        histogram
        nc
        f
        lambdaMax
        pijk
        b
        width
        binLambdaMin
        binLambdaMax
        nBins
        N
        ensemble
        numWalkers
        tensors
        mcStep
        inLoops = 100
    end

    methods
        function obj = metropolisRangeEnsemble(ensemble, N, binLambdaMin, binLambdaMax, nBins, width, numWalkers)
            %UNTITLED2 Construct an instance of this class
            %   Detailed explanation goes here
            obj.N = N;
            obj.ensemble = ensemble;
            obj.binLambdaMin = binLambdaMin;
            obj.binLambdaMax = binLambdaMax;
            obj.nBins = nBins;
            obj.width = width;
            obj.numWalkers = numWalkers;
            obj.mcStep = 0;

            obj.logWeights = zeros(nBins, 1);
            obj.histogram = zeros(nBins, 1);
            obj.nc=0;
            obj.f = exp(1);
            obj.b = 0.92;

            % Pick the pijk to use
            if strcmp(ensemble, 'Cyclic')
                obj.pijk = @pijkCyclicVariance;
                tensorInitializer = @getCyclicTensor;
            elseif strcmp(ensemble, 'ConstantVariance')
                obj.pijk = @pijkConstantVariance;
                tensorInitializer = @getConstantVarianceTensor;
            else 
                ME = MException("Ensemble is not correct");
                throw(ME);
            end

            % Now initialize each array
            obj.tensors = cell(numWalkers, 1);
            obj.lambdaMax = zeros(numWalkers, 1);
            for i=1:numWalkers
                obj.tensors{i} = tensorInitializer(N);
                s = rng;
                lambda = zeig(double(full(obj.tensors{i})), 'symmetric');
                rng(s);
                obj.lambdaMax(i) = max(lambda);
            end

            % Need to create temporary directories for each walker
            for i=1:obj.numWalkers
                [status, msg, msgID] = mkdir(sprintf("./tmp_%i", i));
            end
        end

        function bin = computeBin(obj, lambda)
            bin = round((lambda - obj.binLambdaMin) / (obj.binLambdaMax - obj.binLambdaMin) * (obj.nBins-1)) + 1;
        end

        function obj = iterateTensors(obj)
            bins = [];
            
            % First calculate the perturbed tensors
            newTensors = cell(obj.numWalkers, 1);
            for i=1:obj.numWalkers
                indices = randi([1, obj.N], 1, 3);
                proposedJump = randn() * obj.width;

                Anew = obj.tensors{i};
                Anew(indices) = Anew(indices) + proposedJump;
                newTensors{i} = double(full(Anew));
            end
            
            % Now calculate the zeig values in parallel
            
            lambdaMaxNewList = zeros(obj.numWalkers, 1);
            s = rng;
            parfor i=1:obj.numWalkers
                cd(sprintf("./tmp_%i", i));
                lambda = zeig(newTensors{i}, 'symmetric');
                lambdaMaxNewList(i) = max(lambda);
                cd("../");
            end
            rng(s);
            
            for i=1:obj.numWalkers
                A = obj.tensors{i};
                Anew = symtensor(tensor(newTensors{i}));
                lambdaMax = obj.lambdaMax(i);
                lambdaMaxNew = lambdaMaxNewList(i);

                if lambdaMaxNew > obj.binLambdaMin && lambdaMaxNew < obj.binLambdaMax
                    binLambdaNew = computeBin(obj, lambdaMaxNew);
                    binLambda = computeBin(obj, lambdaMax);
                    monteCarloProbability = obj.pijk(Anew(indices), indices) / obj.pijk(A(indices), indices) * exp(obj.logWeights(binLambdaNew) - obj.logWeights(binLambda));
                    
                    if rand < monteCarloProbability
                        obj.lambdaMax(i) = lambdaMaxNew;
                        obj.tensors{i} = Anew;
                    end

                    binLambda = computeBin(obj, lambdaMax);
                    bins = [bins, binLambda];
                end
            end
            obj.mcStep = obj.mcStep + 1;
            
            % Vectorized version didn't consider multiplicity of indices
            for i=1:length(bins)
                binIdx = bins(i);
                obj.logWeights(binIdx) = obj.logWeights(binIdx) - log(obj.f);
                obj.histogram(binIdx) = obj.histogram(binIdx) + 1;
            end

            if mod(obj.mcStep, obj.inLoops) == 0
                disp(obj.histogram');
                if min(obj.histogram) > mean(obj.histogram) * obj.b
                    obj.f = sqrt(obj.f);
                    obj.nc = obj.nc + 1;
                    writematrix(obj.histogram, sprintf("./Data/Histogram_nc%i_N%i_%s.txt", obj.nc, obj.N, obj.ensemble));
                    writematrix(obj.logWeights, sprintf("./Data/Weights_nc%i_N%i_%s.txt", obj.nc, obj.N, obj.ensemble));
                    obj.histogram = obj.histogram * 0;
                end
            end
        end
    end
end
