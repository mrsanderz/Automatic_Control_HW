clc;
clear;
%% 設定參數
totalstep = 98;
totaltheta = [0;0;0;0];
Lefttotal = [0;0;0;0];
Righttotal = [0,0,0,0;0,0,0,0;0,0,0,0;0,0,0,0];
theta = [0;0;0;0];
phi = [0;0;0;0];
out = load('xx.txt'); %匯入矩陣u,y
u = out(:,1);
y = out(:,2);

u1 = 0;
u0 = 0;
y1 = 0;
y0 = 0;

%% 匯入y u的結果 算出轉移函數
for i=1:totalstep
    phi = [y(i+1);y(i);u(i+1);u(i)];
    phiT = phi';
    phiM = phi * phiT;
    Lefttotal = Lefttotal + y(i+2) .* phi;
    Righttotal = Righttotal + phiM;
end

%% 找root locus 觀察穩定狀況的gain值
theta = double(inv(sym(Righttotal))) * Lefttotal
b1 = theta(3); b0 = theta(4); a1 = -theta(1); a0 = -theta(2); 
h = tf([b1 b0],[1 a1 a0]);
figure(1); rlocus(h);

%% pole assignment法
%設pole在 +0.5j -0.5j 0.4 => 係數=[1 -0.4 0.25 -0.1]
A = inv([1 b1 0;a1 b0 b1;a0 0 b0]) * [-0.4-a1;0.25-a0;-0.1];
x0 = A(1);
x1 = A(2);
x2 = A(3);
r1 = 0; r0 = 0; u1 = 0; u0 = 0; y2 = 0; y1 = 0; y0 = 0;
for i=1:100
    r0 = sin(i*pi/20);
    u0 = u1;
    u1 = -x0*u0 + x1*(r1-y1) + x2*(r0 - y0);
    y2 = -a1*y1 - a0*y0 + b1*u1 + b0*u0;
    y0 = y1;
    y1 = y2;
    r0 = r1;
    yarr(i) = y2;
end
figure(2); plot(yarr);

%% 原轉移函數響應圖  
r = 1; u1 = 0; u0 = 0; y2 = 0; y1 = 0; y0 = 0;
for i=1:100
    %r = sin(i*pi/20);
    u0 = u1;
    u1 = (r - y1);
    y2 = -a1*y1 - a0*y0 + b1*u1 + b0*u0;
    y0 = y1;
    y1 = y2;
    yarr(i) = y2;
    r = 0;
end
figure(3); plot(yarr);

%% pole assignment後的root locus
Gp = tf([b1 b0],[1 a1 a0]);
Gs = tf([x1 x2],[1 x0]);
sys = Gp*Gs;
figure(4); rlocus(sys);
