clear all
clc
%%%%%%Random practice 
theta=linspace(0,360,100);
x=cosd(theta); y=sind(theta);
figure()
plot(x,y,'--')
daspect([1 1 1])

hold on 
x1=2*x;y1=2*y;
plot(x1,y1)
daspect([1 1 1])
[D,Dinfo] = readheaderL3_test('/Users/brneupane/Desktop/test_folder/SNG_200434800_V01.DAT');

LT=D.SC_POS_LOCAL_TIME;
R=D.SC_POS_R;

ACT=270-D.DIM3_PHI;

%%%%%Taking phi co-ordiantes from data
phi=D.DIM3_PHI;



  
  
   
  hold on
  plot(0,0,'+')
  plot(0+0.05*cosd(linspace(0,360,40)),1+0.05*sind(linspace(0,360,40)),'r')
  plot(0,1,'.r','MarkerSize',10)
  plot(0+0.05*cosd(linspace(0,360,40)),-1+0.05*sind(linspace(0,360,40)),'r')
  plot(0,-1,'*r','MarkerSize',10)
  
%  x_sc=cosd(phi);
%  y_sc=sind(phi);
% plot(x_sc,y_sc,'.k')

polar(theta,ones(size(theta)))


