%HW2 - Frequency Response Improve
clc;
clear;
t = (0.01:0.01:1000);
num1 = [1];
den1 = [1 0.1 10];
sys1 = tf (num1,den1);
T = feedback(sys1,1);
y = impulse (sys1,t);
%y = sin(2*pi*2*t);
yf = fft(y);
yfabs = abs(yf)/100;
yh = yfabs(1:50000)
wh = (0.01:0.01:500);


num2 = [1 0.1 10];
den2 = [1 10 10];
sys2 = tf (num2,den2);
Tnew = feedback(sys1*sys2,1);
y = impulse (Tnew,t);
yf = fft(y);
yfabs = abs(yf)/100;
yhnew = yfabs(1:50000);
whnew = (0.01:0.01:500);

loglog(wh,yh,'k',whnew,yhnew,'*')
title('Frequency response');
xlabel('Frequency(rad/s)'); ylabel('Magnitude(dB)');
legend('original','improve')
grid on