N = 3;
J = symtensor(@randn, 3, N);

J = double(full(J));

[lambda, V] = zeig(J);

maxLambda = lambda(end);
maxVector = V(:, end);

hess = getConstrainedHessian(J, maxVector);

theta = linspace(-pi/2, pi/2, 50);
phi = linspace(-pi, pi, 50);

[theta, phi] = meshgrid(theta, phi);

[x, y, z] = sph2cart(phi, theta, 1);

% Flatten the arrays
x = x(:);
y = y(:);
z = z(:);

vecs = [x, y, z];
energy = zeros(length(x), 1);

for i=1:length(x)
    energy(i) = getEnergy(tensor(J), vecs(i, :), 3);
end

energy = reshape(energy, size(theta));
[maxPhi, maxTheta, ~] = cart2sph(maxVector(1), maxVector(2), maxVector(3));

h = figure;
set(h, 'Visible', 'off');
contourf(phi, theta, energy);
hold on

for i=1:length(lambda)
    eigVector = V(:, i);
    val = getMinSaddleMax(J, eigVector);
    if val == 1
        color = 'r';
    elseif val ==0
        color = 'k';
    else
        color = 'g';
    end
    [eigPhi, eigTheta, ~] = cart2sph(eigVector(1), eigVector(2), eigVector(3));
    scatter(eigPhi, eigTheta, "filled", color);
    hold on
end
hold off
saveas(h, "Figure.png")