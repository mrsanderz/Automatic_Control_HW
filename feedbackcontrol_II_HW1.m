clc;
clear;
i=sqrt(-1);
%三個根
x1 = 5;
x2 = 4;
x3 = 50;
%閉迴路分母係數
b = x1+x2+x3;
c = x1*x2+(x1+x2)*x3;
d = x1*x2*x3;
C = [1 1 0;-3 3 1;2 0 3];
X = inv(C)*[b+3;c-2;d]
h = tf([X(2) 3*X(2)+X(3) 3*X(3)],[1 b c d]);
figure(1);
stepplot(h)
figure(2);
rlocus(h)