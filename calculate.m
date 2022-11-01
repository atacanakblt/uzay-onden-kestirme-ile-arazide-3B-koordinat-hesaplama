
clc,clear;clear all;
% Düşey Yöneltme Elemanları ve Ek Bilgilerin Çağrılması
DYE=importdata('Düşey Yöneltme Elemanları.txt');
EB=importdata('Ek Bilgiler.txt');
% Resimlerin Açılması
numfiles=input('Yüklenecek resim sayısını giriniz: ');
for i=1:numfiles
    [FileName,PathName] = uigetfile('*.*','Görüntü dosyası seçimi...');
    M{i}=imread(FileName);
end
[row, sutun]=size(M{i}(:,:,1));
% Piksel Koordinatlarının Okunması
[kx,ky]=cpselect(M{i-1},M{i},'Wait', true);
[m n]=size(kx);
nn=(1:m)';
% Piksel-Resim Koordinat Dönüşümü
px=EB(1,1);
foc=EB(1,2);
xo=EB(1,3);
yo=EB(1,4);
% Sol Resim
xrl=(sutun/2-kx(:,1))*(px/1000)-xo;
yrl=(kx(:,2)-row/2)*(px/1000)-yo;
% Sag Resim
xrr=(sutun/2-ky(:,1))*(px/1000)-xo;
yrr=(ky(:,2)-row/2)*(px/1000)-yo;
tnokta=[xrl yrl xrr yrr];
%% Uzay Önden Kestirme (Intersection problem)

degrad=180/pi;

for i=1:m;
XL1=DYE(1,1);
YL1=DYE(1,2);
ZL1=DYE(1,3);
om1=DYE(1,4)/degrad;
ph1=DYE(1,5)/degrad;
kp1=DYE(1,6)/degrad;

XL2=DYE(2,1);
YL2=DYE(2,2);
ZL2=DYE(2,3);
om2=DYE(2,4)/degrad;
ph2=DYE(2,5)/degrad;
kp2=DYE(2,6)/degrad;
					

% initial approximation
X=425000.0;
Y=4541200.0;
Z=2215.0;

% fill in the two p-vectors

p1=zeros(14,1);
p2=zeros(14,1);
dp=ones(14,1)*1.0e-08;

p1(1)=tnokta(i,1);
p1(2)=tnokta(i,2);
p1(3)=xo;
p1(4)=yo;
p1(5)=foc;
p1(6)=om1;
p1(7)=ph1;
p1(8)=kp1;
p1(9)=XL1;
p1(10)=YL1;
p1(11)=ZL1;
p1(12)=X;
p1(13)=Y;
p1(14)=Z;
p2(1)=tnokta(i,3);
p2(2)=tnokta(i,4);
p2(3)=xo;
p2(4)=yo;
p2(5)=foc;
p2(6)=om2;
p2(7)=ph2;
p2(8)=kp2;
p2(9)=XL2;
p2(10)=YL2;
p2(11)=ZL2;
p2(12)=X;
p2(13)=Y;
p2(14)=Z;
partials=zeros(2,14);
for iter=1:5
 B=zeros(4,3);
 f=zeros(4,1);
 % equations for left photo
 F0=col(p1);
 for j=1:14
 pp=p1;
 pp(j)=pp(j) + dp(j);
 F1=col(pp);
 partials(:,j)=(F1-F0)*(1/dp(j));
 end
 B(1:2,:)=partials(:,12:14);
 f(1:2)=-F0;
 % equations for right photo
 F0=col(p2);
 for j=1:14
 pp=p2;
 pp(j)=pp(j) + dp(j);
 F1=col(pp);
 partials(:,j)=(F1-F0)*(1/dp(j));
 end
 B(3:4,:)=partials(:,12:14);
 f(3:4)=-F0;
 del=inv(B'*B)*B'*f;
 del'

 X=X+del(1);
 Y=Y+del(2);
 Z=Z+del(3);
 p1(12:14)=[X;Y;Z];
 p2(12:14)=[X;Y;Z];
 koord(i,:)=[X Y Z];
end

disp('XYZ intersected point');
[X Y Z]
disp('residuals');
v=f-B*del
end
% Noktaların kayıt edilmesi
No(:,1)=(1:1:size(koord,1));
X=koord(:,1);
Y=koord(:,2);
Z=koord(:,3);
NOKTA=[No X Y Z];
[~,~] = uiputfile('*.ncn*','kayit yeri');
save('harita.ncn','NOKTA','-ascii');

ccl=[No xrl yrl];
save('Sol Resim Koordinat Listesi .doc','ccl','-ascii');
ccr=[No xrr yrr];
save('Sað Resim Koordinat Listesi .doc','ccr','-ascii');
cpl=[No kx(:,1)  ky(:,1)];
save('Sol Piksel Koordinat Listesi .doc','cpl','-ascii');
cpr=[No kx(:,2)  ky(:,2)];
save('Sað Piksel Koordinat Listesi .doc','cpr','-ascii');
