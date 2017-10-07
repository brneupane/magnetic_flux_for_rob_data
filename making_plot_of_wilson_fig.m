clear all
clc
%%%2007-266T10:43:49.151
%%%2004-299T16:38:09.178
%%%2004-299T16:38:09.178
%%THis file calculates the row-willsion figure as in willsion paper 
[path_name]=folder_path(2008,071,'18');
[D,Dinfo]=readheaderL3_test(path_name);
%[D,Dinfo] = readheaderL3_test('/Users/brneupane/Desktop/test_folder/SNG_200434818_V01.DAT');

LT=D.SC_POS_LOCAL_TIME;

R=D.SC_POS_R;
%%%%%Taking phi co-ordiantes from data
phi=D.DIM3_PHI;

ACT=270-phi;




figure(101)
plot(ACT,'-*')


theta=[80 60 40 20 0 -20 -40 -60 -80 ];
for m=1:length(theta)
    r=1; %%%%%Define a unit sphere in sphere craft frame reference
%%%%%%Converting spherical co-ordainate into catrecian co-ordiante using
%%%%%%unit radius of sphere
  x_sc=cosd(theta(m)).*cosd(phi);
  y_sc=cosd(theta(m)).*sind(phi);
  
  z_sc=sind(theta(m)).*ones(length(ACT),1);
 
 


%%%%converting phi from deg to radian
p=phi*pi./180;
%%%%% Transformation matrix form spacecraft to J2000 co-ordinate
A=my_matrix(D.SC_TO_J2000);

%%%%%conversion from J2000 to RTP co-ordinates
B=my_matrix(D.J2000_TO_RTP);
%%%%%% Transformation from spacecraft frame to J2000 frame
for i=1:length(phi)
    
X_J2000(i,:)=A(:,:,i)*[x_sc(i),y_sc(i),z_sc(i)]';
end
%%%%%% Transform co-ordinate  from Spacecraft frame
%%%%%% to J2000 frame 
x_J2000=X_J2000(:,1);y_J2000=X_J2000(:,2);z_J2000=X_J2000(:,3);


%%%%%%final transform co-ordinates from J2000 to RTP Saturn co-ordinate. 
for i=1:length(phi)
    
X_sat(i,:)=B(:,:,i)*[x_J2000(i),y_J2000(i),z_J2000(i)]';
end
%%%%%%%%%%Co-ordinates in saturn frame of reference
R_sat=X_sat(:,1);theta_sat=X_sat(:,2);phi_sat=X_sat(:,3);
%%%R_sat=R_sat(R_sat<0);theta_sat=theta_sat(R_sat<0);phi_sat=phi_sat(R_sat<0);
%%%%%%%%%%%making a unit circle
ref_theta=linspace(0,2*pi,100);
rho=ones(size(ref_theta));
figure(1)
p=polar(ref_theta,pi*rho,'-');

delete(findall(ancestor(p,'figure'),'HandleVisibility','off','type','line','-or','type','text'));
daspect([1 1 1])
hold on 
p=polar(ref_theta,pi./2*rho,'-');
%delete(findall(ancestor(p,'figure'),'HandleVisibility','off','type','line','-or','type','text'));
daspect([1 1 1])
hold on

my_phi=(2.5*pi-atan2(phi_sat,-theta_sat));
for i=1:length(R_sat)
     if R_sat(i)>0
         my_theta(i)=(pi-acos(R_sat(i)));
     else
        my_theta(i)=acos(-R_sat(i));
    end
end


h=polar(my_phi(400:416),my_theta(400:416)','*');
set(h,'markersize',30) 
%plot(0,-pi./2,'o')
hold on
%legend(['for theta = ' int2str(theta(m))])
%pause(1)
end
legend('','1','2', '3' ,'4','5', '6','7', '8','' )
plot(0,0,'+k')
set(gca,'fontsize',15,'fontweight','bold')
polar(ref_theta,pi*rho./9)
polar(ref_theta,8*pi*rho./9)

x_sat=cos(theta_sat).*cos(phi_sat);y_sat=cos(theta_sat).*sin(phi_sat);z_sat=sin(theta_sat);
x_cor=cos(LT.*pi./12-pi);y_cor=sin(LT.*pi./12-pi);
%%%%Looking at the dot product
for i=1:length(x_sat)
    A1=[x_sat(i),y_sat(i)]./norm([x_sat(i),y_sat(i),z_sat(i)]);
    B1=[x_cor(i),y_cor(i)];
    my_val(i)=dot(A1,B1);
end
hold off
figure()
plot(my_val,'.')
dates=D.UTC(abs(my_val)>0.8,:);
figure(202)
plot(my_theta*180./pi)
