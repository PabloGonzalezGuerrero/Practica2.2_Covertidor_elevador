clear; clc; close all;

Vo_ref = 48; 
f = 40e3;    
T = 1/f;     
C = 200e-6;  


model = "P2_2_cuestion5";
load_system(model);

R_vector = 1:5:100;
D_vector = [0.1 0.2 0.3 0.4 0.6];

Vo_med = zeros(length(R_vector), length(D_vector));

t0 = 0.01;
StopTime = "0.02";

set_param(model,'FastRestart','off');

for k = 1:length(D_vector)
    D = D_vector(k);
    assignin('base','D',D);

    for i = 1:length(R_vector)
        R = R_vector(i);
        assignin('base','R',R);

        out = sim(model,'StopTime',StopTime);

        t  = out.V0.time;
        v0 = out.V0.signals.values;

        idx = (t >= t0);
        if ~any(idx)
            error("t0=%.4f > t_final=%.4f. Sube StopTime o baja t0.", t0, t(end));
        end

        Vo_med(i,k) = mean(v0(idx), 'omitnan');
    end
end

set_param(model,'FastRestart','off');

figure; hold on; grid on;
for k = 1:length(D_vector)
    plot(R_vector, Vo_med(:,k), 'DisplayName',sprintf('D=%.1f',D_vector(k)));
end
xlabel('R (\Omega)');
ylabel('V_o medio (V)');
title('Familia de curvas: V_o = f(R,D)');
legend('Location','best');