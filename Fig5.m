%% Setting path

addpath('module');

%% parameters for Model_ODE

param.ne       = 300;
param.ni       = 100;
param.s_ee     = 5*0.15;
param.s_ie     = 2*0.5;
param.s_ei     = 4.91*0.413;
param.s_ii     = 4.91*0.4;
param.p_ee     = 1;
param.p_ie     = 1;
param.p_ei     = 1;
param.p_ii     = 1;
param.M        = 100;
param.Mr       = 66;
param.lambda_e = 7;
param.lambda_i = 7;
param.n_exe = 10;
param.tau_ee   = 1.4;
param.tau_ie   = 1.2;
param.tau_ei   = 4.5;
param.tau_ii   = 4.5;
param.duration = 3;
param.delta_time = 0.1;
param.dt = 0.01;

%% Model_ode Period 3

param.s_ei     = 4.91*0.413;

tic;
res_ode3=model_ode2(param);
toc;
%% Model_ode Period 2

param.s_ei     = 4.91*0.42;

tic;
res_ode2=model_ode2(param);
toc;
%% Model_ode Period 1

param.s_ei     = 4.91*0.4;

tic;
res_ode1=model_ode2(param);
toc;
%%
figure;
subplot(1,2,1);
plot(t1, res_ode.spikecount_e/delta_time,'r');
%ylim([0, max_fr]);
xlabel('Time (ms)');
ylabel('Firing Rate');
title('HE spikecount');
xlim([2000,3000]);

subplot(1,2,2);
plot(t1, res_ode.spikecount_i/delta_time,'r');
%ylim([0, max_fr]);
xlabel('Time (ms)');
legend('ODE');
xlim([2000,3000]);
tile('HI spikecount');
sgtitle('Spike Density');

set(gcf,'Position',[10,10,1000,400]);

%% Parameters for Model_lif

alpha = 1;
beta = 10;
param.ne = 300;
param.ni = 100;
param.M        = 100*beta;
param.Mr       = 66*beta;
% param.p_ee     = 0.15;
% param.p_ie     = 0.5;
% param.p_ei     = 0.415;
% param.p_ii     = 0.4;
param.p_ee     = 1;
param.p_ie     = 1;
param.p_ei     = 1;
param.p_ii     = 1;
% param.s_ee     = 5/alpha*beta;
% param.s_ie     = 2/alpha*beta;
% param.s_ei     = 4.91/alpha*beta;
% param.s_ii     = 4.91/alpha*beta;
param.s_ee     = 5*0.15/alpha*beta;
param.s_ie     = 2*0.5/alpha*beta;
param.s_ei     = 4.91*0.413/alpha*beta;
param.s_ii     = 4.91*0.40/alpha*beta;

param.lambda_e = 7000*beta;
param.lambda_i = 7000*beta;
param.tau_ee   = 1.4;
param.tau_ie   = 1.2;
param.tau_ei    = 4.5;
param.tau_ii    = 4.5;
param.tau_re=0;
param.tau_ri=0;
param.duration = 3;
param.delta_time = 0.1;

param.factor_Leak=0;
param.LeakE = 20;

param.LeakI = 16.7;
param.factor_Leak = inf;
param.ns_ee=alpha;
param.ns_ie=alpha;
param.ns_ei=alpha;
param.ns_ii=alpha;

param2=param;
param2.gridsize=0.1;

%% Model_lif Period 3
param2.s_ei     = 4.91*0.413/alpha*beta;
ve = zeros(1,300);
vi = zeros(1,100);
he = zeros(2,300);
hi = zeros(2,100);
tic;
res_lif3=model_LIF2(param2,ve,vi,he,hi);
toc;
figure;
rasterplot(res_lif3,param2);

%% Model_lif Period 2

param2.s_ei     = 4.91*0.425/alpha*beta;
tic;
res_lif2=model_LIF2(param2,ve,vi,he,hi);
toc;
figure;
rasterplot(res_lif2,param2);
xlim([2000,3000]);

%% Model_lif Period 1
param2.s_ei     = 4.91*0.4/alpha*beta;
tic;
res_lif1=model_LIF2(param2,ve,vi,he,hi);
toc;
figure;
rasterplot(res_lif1,param2);


%% Rasterplot of Model_lif
figure;
rasterplot(res_lif,param2);

%% Save Rasterplot

set(gcf,'Position',[10,10,1000,300]);
name='pei=0.415-s=n-r=0';    
title(name);
saveas(gcf,['ode full model/output/Raster-',name,'.fig']);

%% SD plots
delta_time = param.delta_time/1000;
size = floor(param2.duration/delta_time);
sd_lif1 = zeros(size,2);
spike_E = res_lif1.spike(:,1:300);
spike_I = res_lif1.spike(:,301:400);
spike_E = spike_E(1:max(spike_E(1,:))+1,:);
spike_I = spike_I(1:max(spike_I(1,:))+1,:);
for i = 1:size
    sd_lif1(i,1) = sum(sum(spike_E< i*delta_time & spike_E>= (i-1)*delta_time))/delta_time;
    sd_lif1(i,2) = sum(sum(spike_I< i*delta_time & spike_I>= (i-1)*delta_time))/delta_time;
end

sd_lif2 = zeros(size,2);
spike_E = res_lif2.spike(:,1:300);
spike_I = res_lif2.spike(:,301:400);
spike_E = spike_E(1:max(spike_E(1,:))+1,:);
spike_I = spike_I(1:max(spike_I(1,:))+1,:);
for i = 1:size
    sd_lif2(i,1) = sum(sum(spike_E< i*delta_time & spike_E>= (i-1)*delta_time))/delta_time;
    sd_lif2(i,2) = sum(sum(spike_I< i*delta_time & spike_I>= (i-1)*delta_time))/delta_time;
end

sd_lif3 = zeros(size,2);
spike_E = res_lif3.spike(:,1:300);
spike_I = res_lif3.spike(:,301:400);
spike_E = spike_E(1:max(spike_E(1,:))+1,:);
spike_I = spike_I(1:max(spike_I(1,:))+1,:);
for i = 1:size
    sd_lif3(i,1) = sum(sum(spike_E< i*delta_time & spike_E>= (i-1)*delta_time))/delta_time;
    sd_lif3(i,2) = sum(sum(spike_I< i*delta_time & spike_I>= (i-1)*delta_time))/delta_time;
end



t1 = param.delta_time:param.delta_time:param.duration*1000;
t2 = param.delta_time:param.delta_time: size*param.delta_time;

%%
mV_LIF1 = mean(res_lif1.VE,2)/10-mean(res_lif1.VI,2)/10;
mV_LIF2 = mean(res_lif2.VE,2)/10-mean(res_lif2.VI,2)/10;
mV_LIF3 = mean(res_lif3.VE,2)/10-mean(res_lif3.VI,2)/10;

%%
mV_ODE1 = zeros(30000,1);
res_ode = res_ode1;
for i =1:30000
    % mVE
    peak_E = res_ode.peak_e(i,:);
    peak_I = res_ode.peak_i(i,:);
    peak_E = reshape(peak_E, 3, 10);
    peak_I = reshape(peak_I, 3, 10);
    if res_ode.npe(i) ==1 
        mVE = peak_E(1,1);
    else 
        lub = norminv([0.0001, peak_E(3,1)], peak_E(1,1),sqrt(peak_E(2,1)));
        a = lub(1);
        b = lub(2);
        x=[a+(b-a)/200:(b-a)/100:b-(b-a)/200];
        v = peak_E(2,1);
        mu = peak_E(1,1);
        mVE=(1/sqrt(2*pi*v)*exp(-(x-mu).^2/2/v).*((b-a)/100))*x';
        for j =2:res_ode.npe
            mVE = mVE + peak_E(1,j)*peak_E(3,j);
        end
    end
    if res_ode.npi(i) == 1
        mVI = peak_I(1,1);
    else 
        lub = norminv([0.0001, peak_I(3,1)], peak_I(1,1),sqrt(peak_I(2,1)));
        a = lub(1);
        b = lub(2);
        x=[a+(b-a)/200:(b-a)/100:b-(b-a)/200];
        v = peak_I(2,1);
        mu = peak_I(1,1);
        mVI=(1/sqrt(2*pi*v)*exp(-(x-mu).^2/2/v).*((b-a)/100))*x';
        for j =2:res_ode.npi
            mVI = mVI + peak_I(1,j)*peak_I(3,j);
        end
    end 
    mV_ODE1(i) = mVE-mVI;
end

mV_ODE2 = zeros(30000,1);
res_ode = res_ode2;
for i =1:30000
    % mVE
    peak_E = res_ode.peak_e(i,:);
    peak_I = res_ode.peak_i(i,:);
    peak_E = reshape(peak_E, 3, 10);
    peak_I = reshape(peak_I, 3, 10);
    if res_ode.npe(i) ==1 
        mVE = peak_E(1,1);
    else 
        lub = norminv([0.0001, peak_E(3,1)], peak_E(1,1),sqrt(peak_E(2,1)));
        a = lub(1);
        b = lub(2);
        x=[a+(b-a)/200:(b-a)/100:b-(b-a)/200];
        v = peak_E(2,1);
        mu = peak_E(1,1);
        mVE=(1/sqrt(2*pi*v)*exp(-(x-mu).^2/2/v).*((b-a)/100))*x';
        for j =2:res_ode.npe
            mVE = mVE + peak_E(1,j)*peak_E(3,j);
        end
    end
    if res_ode.npi(i) == 1
        mVI = peak_I(1,1);
    else 
        lub = norminv([0.0001, peak_I(3,1)], peak_I(1,1),sqrt(peak_I(2,1)));
        a = lub(1);
        b = lub(2);
        x=[a+(b-a)/200:(b-a)/100:b-(b-a)/200];
        v = peak_I(2,1);
        mu = peak_I(1,1);
        mVI=(1/sqrt(2*pi*v)*exp(-(x-mu).^2/2/v).*((b-a)/100))*x';
        for j =2:res_ode.npi
            mVI = mVI + peak_I(1,j)*peak_I(3,j);
        end
    end 
    mV_ODE2(i) = mVE-mVI;
end

mV_ODE3 = zeros(30000,1);
res_ode = res_ode3;
for i =1:30000
    % mVE
    peak_E = res_ode.peak_e(i,:);
    peak_I = res_ode.peak_i(i,:);
    peak_E = reshape(peak_E, 3, 10);
    peak_I = reshape(peak_I, 3, 10);
    if res_ode.npe(i) ==1 
        mVE = peak_E(1,1);
    else 
        lub = norminv([0.0001, peak_E(3,1)], peak_E(1,1),sqrt(peak_E(2,1)));
        a = lub(1);
        b = lub(2);
        x=[a+(b-a)/200:(b-a)/100:b-(b-a)/200];
        v = peak_E(2,1);
        mu = peak_E(1,1);
        mVE=(1/sqrt(2*pi*v)*exp(-(x-mu).^2/2/v).*((b-a)/100))*x';
        for j =2:res_ode.npe
            mVE = mVE + peak_E(1,j)*peak_E(3,j);
        end
    end
    if res_ode.npi(i) == 1
        mVI = peak_I(1,1);
    else 
        lub = norminv([0.0001, peak_I(3,1)], peak_I(1,1),sqrt(peak_I(2,1)));
        a = lub(1);
        b = lub(2);
        x=[a+(b-a)/200:(b-a)/100:b-(b-a)/200];
        v = peak_I(2,1);
        mu = peak_I(1,1);
        mVI=(1/sqrt(2*pi*v)*exp(-(x-mu).^2/2/v).*((b-a)/100))*x';
        for j =2:res_ode.npi
            mVI = mVI + peak_I(1,j)*peak_I(3,j);
        end
    end 
    mV_ODE3(i) = mVE-mVI;
end
%%
subplot(2,1,1);
plot(t2, mVE_LIF(2:end)-mvI_LIF(2:end));
xlim([2000,3000]);
subplot(2,1,2);
plot(t1,mvE_ODE - mvI_ODE);
xlim([2000,3000]);
%%

figure;
subplot(3,5,1);
rasterplot(res_lif1,param2);
xlim([2850,3000]);
xlabel('Time (ms)');


subplot(3,5,2);
plot(t2(2:end), sd_lif1(2:end,1));
xlabel('Time (ms)');
ylabel('Firing Rate');
xlim([2850,3000]);
ylim([0,3*10^6]);
title('LIF E-spikecount');



subplot(3,5,3);
plot(t1, res_ode1.spikecount_e/delta_time);
xlabel('Time (ms)');
ylabel('Firing Rate');
title('ODE E-spikecount');
ylim([0,3*10^6]);
xlim([2850,3000]);

subplot(3,5,4);
plot(t1, mV_LIF1(2:end));
xlabel('Time (ms)');
title('LIF \Delta V');
ylim([-100,100]);
xlim([2850,3000]);

subplot(3,5,5);
plot(t2, mV_ODE1);
xlabel('Time (ms)');
title('ODE \Delta V');
ylim([-100,100]);
xlim([2850,3000]);

subplot(3,5,6);
rasterplot(res_lif2,param2);
xlim([2850,3000]);
xlabel('Time (ms)');


subplot(3,5,7);
plot(t2(2:end), sd_lif2(2:end,1));
xlabel('Time (ms)');
ylabel('Firing Rate');
xlim([2850,3000]);
ylim([0,3*10^6]);
%title('LIF E-spikecount');



subplot(3,5,8);
plot(t1, res_ode2.spikecount_e/delta_time);
xlabel('Time (ms)');
ylabel('Firing Rate');
ylim([0,3*10^6]);
%title('ODE E-spikecount');
xlim([2850,3000]);

subplot(3,5,9);
plot(t1, mV_LIF2(2:end));
xlabel('Time (ms)');
ylim([-100,100]);
%title('LIF \Delta V');
xlim([2850,3000]);

subplot(3,5,10);
plot(t2, mV_ODE2);
xlabel('Time (ms)');
ylim([-100,100]);
%title('ODE \Delta V');
xlim([2850,3000]);

subplot(3,5,11);
rasterplot(res_lif3,param2);
xlim([2850,3000]);
xlabel('Time (ms)');


subplot(3,5,12);
plot(t2(2:end), sd_lif3(2:end,1));
xlabel('Time (ms)');
ylabel('Firing Rate');
xlim([2850,3000]);
ylim([0,3*10^6]);
%title('LIF E-spikecount');



subplot(3,5,13);
plot(t1, res_ode3.spikecount_e/delta_time);
xlabel('Time (ms)');
ylabel('Firing Rate');
%title('ODE E-spikecount');
ylim([0,3*10^6]);
xlim([2850,3000]);

subplot(3,5,14);
plot(t1, mV_LIF3(2:end));
ylim([-100,100]);
xlabel('Time (ms)');
%title('LIF \Delta V');
xlim([2850,3000]);

subplot(3,5,15);
plot(t2, mV_ODE3);
ylim([-100,100]);
xlabel('Time (ms)');
%title('ODE \Delta V');
xlim([2850,3000]);
set(gcf,'Position',[10,10,1800,900]);
exportgraphics(gcf,'fig-5.eps','ContentType','vector')
%%
