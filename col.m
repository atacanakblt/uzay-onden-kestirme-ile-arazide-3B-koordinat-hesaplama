%% Kollinearite denklemleri (Collinearity eqns)
function result=col(p);
x=p(1);
y=p(2);
x0=p(3);
y0=p(4);
f=p(5);
om=p(6);
ph=p(7);
kp=p(8);
XL=p(9);
YL=p(10);
ZL=p(11);
X=p(12);
Y=p(13);
Z=p(14);
m1=[1 0 0;0 cos(om) sin(om);0 -sin(om) cos(om)];
m2=[cos(ph) 0 -sin(ph);0 1 0;sin(ph) 0 cos(ph)];
m3=[cos(kp) sin(kp) 0;-sin(kp) cos(kp) 0;0 0 1];
M=m3*m2*m1;
UVW=M*[X-XL;Y-YL;Z-ZL];
U=UVW(1);
V=UVW(2);
W=UVW(3);
Fx=x-x0+f*(U/W);
Fy=y-y0+f*(V/W);
result=[Fx;Fy];