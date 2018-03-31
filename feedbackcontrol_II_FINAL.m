clc;
clear;
%% 砞﹚把计
radCir = 20;
Tp = 100;
kkgain = 100;
jgain = 130;
sysC = tf([1], [1 20 0]); %硈尿╰参
sysD = c2d(sysC,0.01,'zoh'); %计╰参
[numD,denD] = tfdata(sysD,'v')
a1 = denD(2); a0 = denD(3); b1 = numD(2); b0 = numD(3);

%{
%% тroot locus 芠诡铆﹚猵gain
theta = double(inv(sym(Righttotal))) * Lefttotal
b1 = theta(3); b0 = theta(4); a1 = -theta(1); a0 = -theta(2); 
h = tf([b1 b0],[1 a1 a0]);
figure(1); rlocus(h);
%}

%% 锣簿ㄧ计臫莱瓜  (Forward contral)
ry = 0; rx = 0; u1 = 0; u0 = 0; y2 = 0; y1 = 0; y0 = 0; yd = 0; ddy = 0;
for i=0:1000
    ry = radCir*sin(i*2*pi/Tp);
    epy2 = radCir*sin((i+30)*2*pi/Tp);
    yd = y1 - y0;
    u0 = u1;
    u1 = kkgain*(ry-y1) + jgain*epy2;
    dyy =  -0.002*(atan(yd/0.01)-0.7*atan(yd/0.05)); %家览集揽
    y2 = -a1*y1 - a0*y0 + b1*u1 + b0*u0 + sign(yd)*dyy;
    y0 = y1;
    y1 = y2;
    yarr(i+1) = y2;
    yarrO(i+1) = ry;
    errYarr(i+1) = ry - y2;
end
u1 = radCir; u0 = radCir; y2 = 0; y1 = 0; y0 = 0; yd = 0; ddy = 0;
for i=0:1000
    rx = radCir*cos(i*2*pi/Tp);
    epx2 = radCir*cos((i+30)*2*pi/Tp);
    yd = y1 - y0;
    u0 = u1;
    u1 = kkgain*(rx-y1) + jgain*epx2;
    dyy =  -0.002*(atan(yd/0.01)-0.7*atan(yd/0.05)); %家览集揽
    y2 = -a1*y1 - a0*y0 + b1*u1 + b0*u0 + sign(yd)*dyy;
    y0 = y1;
    y1 = y2;
    xarr(i+1) = y2;
    xarrO(i+1) = rx;
    errXarr(i+1) = rx - y2;
end

%figure(1); plot(xarr,yarr); hold on; plot(xarrO,yarrO);
%figure(2); plot(xarr); hold on; plot(xarrO);
%figure(3); plot(errXarr);
%figure(4); rlocus(tf([b1 b0],[1 a1 a0]));
%figure(5); plot(errYarr);
%{
%% pole assignmentroot locus
Gp = tf([b1 b0],[1 a1 a0]);
Gs = tf([x1 x2],[1 x0]);
sys = Gp*Gs;
figure(4); rlocus(sys);
%}





%{
num2 = [1];
den2 = [1 10 10];
sys2 = tf (num2,den2);

t = (0.01:0.01:1000);
T = feedback(sysC,1);
y = impulse (T,t);
yf = fft(y);
yfabs = abs(yf)/100;
yh = yfabs(1:50000);
wh = (0.01:0.01:500);
loglog(wh,yh);
title('Frequency response');
xlabel('Frequency(rad/s)'); ylabel('Magnitude(dB)');
%}