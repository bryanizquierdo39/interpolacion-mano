clear; clc; close all;

figure('Color','w');
hold on; grid on; axis equal;
title('Clickea 50 puntos: cada click se dibuja', 'FontSize', 14, 'FontWeight','bold');
xlabel('X'); ylabel('Y');
xlim([0 10]); ylim([0 10]);

disp('=== INSTRUCCIONES ===');
disp('1. Pon tu palma frente al monitor como guía');
disp('2. Clickea 50 puntos del contorno de la palma');
disp('4. Cada click se marca con un punto rojo');
disp('5. Click derecho o Enter para terminar antes');

n_max = 50;
x = zeros(n_max, 1);
y = zeros(n_max, 1);
n = 0;

for i = 1:n_max
    [xi, yi, button] = ginput(1); % 1 click a la vez
    
    if isempty(xi) || button ~= 1
        break;
    end
    
    n = n + 1;
    x(n) = xi;
    y(n) = yi;
    
    plot(xi, yi, 'ro', 'MarkerSize', 8, 'MarkerFaceColor','r');
    text(xi+0.1, yi+0.1, num2str(n), 'FontSize', 8, 'Color', 'b');

    if n > 1
        plot([x(n-1) xi], [y(n-1) yi], 'r--', 'LineWidth', 0.5);
    end
    
    title(sprintf('Punto %d de 50 - Sigue clickeando', n));
    drawnow;
end


x = x(1:n);
y = y(1:n);
title(sprintf('Listo: %d puntos clickeados', n));

%% 3. INTERPOLACIONES
t = 1:n; 
t_fino = linspace(1, n, 500);

% --- LAGRANGE ---
x_lagrange = zeros(size(t_fino));
y_lagrange = zeros(size(t_fino));
for k = 1:length(t_fino)
    Lx = 0; Ly = 0;
    for i = 1:n
        Li = 1;
        for j = 1:n
            if i ~= j
                Li = Li * (t_fino(k) - t(j)) / (t(i) - t(j));
            end
        end
        Lx = Lx + x(i) * Li;
        Ly = Ly + y(i) * Li;
    end
    x_lagrange(k) = Lx;
    y_lagrange(k) = Ly;
end

% --- NEWTON ---
x_newton = zeros(size(t_fino));
y_newton = zeros(size(t_fino));
Dx = zeros(n, n); Dx(:,1) = x(:);
Dy = zeros(n, n); Dy(:,1) = y(:);
for j = 2:n
    for i = 1:n-j+1
        Dx(i,j) = (Dx(i+1,j-1) - Dx(i,j-1)) / (t(i+j-1) - t(i));
        Dy(i,j) = (Dy(i+1,j-1) - Dy(i,j-1)) / (t(i+j-1) - t(i));
    end
end
for k = 1:length(t_fino)
    xi = t_fino(k);
    yi_x = Dx(1,1); yi_y = Dy(1,1);
    for p = 2:n
        prod = 1;
        for j = 1:p-1, prod = prod * (xi - t(j)); end
        yi_x = yi_x + Dx(1,p) * prod;
        yi_y = yi_y + Dy(1,p) * prod;
    end
    x_newton(k) = yi_x; y_newton(k) = yi_y;
end

% --- MATRICIAL ---
V = vander(t); 
x_matricial = polyval(V \ x(:), t_fino);
y_matricial = polyval(V \ y(:), t_fino);

% --- SPLINE CÚBICO ---
x_spline = pchip(t, x, t_fino);
y_spline = pchip(t, y, t_fino);

%% COMPARACIÓN
figure('Position', [100 100 1200 800]);

subplot(2,2,1);
plot(x, y, 'ro', 'MarkerSize', 6, 'MarkerFaceColor','r'); hold on;
plot(x_lagrange, y_lagrange, 'b-', 'LineWidth', 2);
title('Lagrange'); axis equal; grid on; legend('Tus puntos', 'Lagrange');

subplot(2,2,2);
plot(x, y, 'ro', 'MarkerSize', 6, 'MarkerFaceColor','r'); hold on;
plot(x_newton, y_newton, 'g-', 'LineWidth', 2);
title('Newton'); axis equal; grid on; legend('Tus puntos', 'Newton');

subplot(2,2,3);
plot(x, y, 'ro', 'MarkerSize', 6, 'MarkerFaceColor','r'); hold on;
plot(x_matricial, y_matricial, 'm-', 'LineWidth', 2);
title('Matricial'); axis equal; grid on; legend('Tus puntos', 'Matricial');

subplot(2,2,4);
plot(x, y, 'ro', 'MarkerSize', 6, 'MarkerFaceColor','r'); hold on;
plot(x_spline, y_spline, 'k-', 'LineWidth', 2);
title('Spline cúbico'); axis equal; grid on; legend('Tus puntos', 'Spline');

sgtitle(sprintf('Comparación', n), 'FontSize', 16);

fprintf('\nCondición de Vandermonde: %e\n', cond(vander(t)));