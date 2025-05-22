classdef metropolisRange
    %METROPOLISRANGE Summary of this class goes here
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
        A
        N
        ensemble
        mcStep
        sysID
        dir
        inLoops = 100
    end
    
    methods
        function obj = metropolisRange(ensemble, N, binLambdaMin, binLambdaMax, nBins, width, sysID)
            %METROPOLISRANGE Construct an instance of this class
            %   Detailed explanation goes here
            
            % Initialize all the constants that we will need
            obj.logWeights = zeros(nBins, 1);
            obj.histogram = zeros(nBins, 1);
            obj.nc = 0;
            obj.f = exp(1);
            obj.b = 0.92;
            obj.nBins = nBins;
            obj.binLambdaMin = binLambdaMin;
            obj.binLambdaMax = binLambdaMax;
            obj.width = width;
            obj.N = N;
            obj.ensemble = ensemble;
            obj.mcStep = 0;
            obj.sysID = sysID;
            
            obj.dir = sprintf("./tmp_%i", obj.sysID);
            [status, msg, msgID] = mkdir(obj.dir);

            % First set the initial tensor and pijk function
            if strcmp(ensemble, 'Cyclic')
                obj.pijk = @pijkCyclicVariance;
                A = getCyclicTensor(N);
                obj = obj.getMaxEigenValue(A);
                % Need to keep sampling until lambdaMax is within range
                if ~((obj.binLambdaMin < obj.lambdaMax) && (obj.lambdaMax < obj.binLambdaMax))
                    avgLambda = (obj.binLambdaMax + obj.binLambdaMin) / 2;
                    A = A * avgLambda / obj.lambdaMax;
                    obj = obj.getMaxEigenValue(A);
                end
                obj.A = A; 

            elseif strcmp(ensemble, 'ConstantVariance')
                obj.pijk = @pijkConstantVariance;
                A = getConstantVarianceTensor(N);
                obj = obj.getMaxEigenValue(A);
                
                if ~((obj.binLambdaMin < obj.lambdaMax) && (obj.lambdaMax < obj.binLambdaMax))
                    avgLambda = (obj.binLambdaMax + obj.binLambdaMin) / 2;
                    A = A * avgLambda / obj.lambdaMax;
                    obj = obj.getMaxEigenValue(A);
                end
                obj.A = A; 

            else
                ME = MException("Ensemble is not correct");
                throw(ME);
            end
        end

        function obj = getMaxEigenValue(obj, A)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            cd(obj.dir);
            s = rng;
            lambda = zeig(double(full(A)));
            rng(s);
            cd("../");
            obj.lambdaMax = max(lambda);
        end
    
        function bin = computeBin(obj, lambda)
            bin = round((lambda - obj.binLambdaMin) / (obj.binLambdaMax - obj.binLambdaMin) * (obj.nBins-1)) + 1;
        end

        function obj = iterateTimeStep(obj)
            indices = randi([1, obj.N], 1, 3);
            proposedJump = randn() * obj.width;
            
            Anew = obj.A;
            Anew(indices) = Anew(indices) + proposedJump;
            cd(obj.dir);
            s = rng();
            lambda = zeig(double(full(Anew)));
            rng(s);
            cd("../");
            lambdaMaxNew = max(lambda);
            
            if lambdaMaxNew > obj.binLambdaMin && lambdaMaxNew < obj.binLambdaMax
                binLambdaNew = computeBin(obj, lambdaMaxNew);
                binLambda = computeBin(obj, obj.lambdaMax);
                monteCarloProbability = obj.pijk(Anew(indices), indices) / obj.pijk(obj.A(indices), indices) * exp(obj.logWeights(binLambdaNew) - obj.logWeights(binLambda));
                
                if rand < monteCarloProbability
                    obj.lambdaMax = lambdaMaxNew;
                    obj.A = Anew;
                end
                
                binLambda = computeBin(obj, obj.lambdaMax);
                obj.logWeights(binLambda) = obj.logWeights(binLambda) - log(obj.f);
                obj.histogram(binLambda) = obj.histogram(binLambda) + 1;
                obj.mcStep = obj.mcStep + 1;
            end

            if mod(obj.mcStep, obj.inLoops) == 0
                disp(sprintf("System (%i): ", obj.sysID));
                disp(obj.histogram')
                if min(obj.histogram) > mean(obj.histogram) * obj.b
                    obj.f = sqrt(obj.f);
                    obj.nc = obj.nc + 1;
                    
                    [status, msg, msgID] = mkdir(sprintf("./Data/%i/", obj.nc));
                    writematrix(obj.histogram, sprintf("./Data/%i/Histogram_%i_%s_%f.txt", obj.nc, obj.N, obj.ensemble, obj.binLambdaMin));
                    writematrix(obj.logWeights, sprintf("./Data/%i/Weights_%i_%i_%s_%f.txt", obj.nc, obj.N, obj.ensemble, obj.binLambdaMin));
                    obj.histogram = obj.histogram * 0;
                end
            end
        end    
    end
end

