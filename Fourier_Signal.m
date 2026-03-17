
clc;
clear all;
close all ;
clf; 
dt = 0.0001 ;
t= -0.1:dt:0.1 ;
xt = 5*cos(2*pi*25*t) + 2*cos(2*pi*50*t) + 3*sin(2*pi*175*t); 
x2t = sin(2*pi*50*t) ; % +cos(2*pi*90*t)+sin(2*pi*150*t); 
plot(t,xt)
grid on; 

np = length(t) ; 
fmax = 1/dt ; % 500 ;
df = fmax/np ; %1000/2000 ;
f = -fmax/2:df:fmax/2-df ; 

nfft = 2^nextpow2(np) ;
fpoints = fix(nfft/2) ; 
f2 = fmax*(0:nfft-1)/nfft ; 
faxis = f2(1:fpoints) ; 

xf = fft(xt);
xf = fftshift(xf);
xfa = abs(xf).^2;

xf2 = fft(xt,nfft) ;
xf2 = xf2(1:fpoints);
xfa2 = abs(xf2).^2;

figure(2) 
plot(f,xfa) ; 
%xlim([0 100]) ; 
grid on; 
xlim([0 200]) ; 
xlabel('Frequency (Hz)') ; 
ylabel('Power spectrum ') ; 

figure(3) ; 
plot(faxis,xfa2) ; 
xlim([0 200]) ; 
grid on ;
xlabel('Frequency (Hz)') ; 
ylabel('Power spectrum ') ; 
%*************************
% rng default;
% Fs = 1000; 
% dt = 1/Fs ; 
% t0 = 0:dt:(1-dt) ;
% xs = cos(2*pi*100.*t0) ; 
% ns = randn(size(t0));
% x = xs + ns ; 
% sound(x,Fs); 
% figure(3) 
% plot(t0,x) 
% 
% N = length(x);
% xdft = fft(x);  
% xdft = fftshift(xdft) ; 
% % xdft = xdft(1:N/2+1);
% len = length(x) ; 
% df = Fs/len ; 
% f = -(Fs/2):df:(Fs/2-df);
% figure(4)
% plot(f,abs(xdft)); 
% grid on;
% xlabel('Frequency (Hz)'); 
% ylabel('Power/Frequency (dB/Hz)');






