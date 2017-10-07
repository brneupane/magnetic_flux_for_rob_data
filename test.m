clear all
clc




[D,Dinfo] = readheaderL3_test('/Users/brneupane/Desktop/test_folder/SNG_200400112_V01.DAT');

LT=D.SC_POS_LOCAL_TIME;
R=D.SC_POS_R;
xa=cos(LT*pi./12-pi);ya=cos(LT*pi./12-pi);
za=zeros(length(xa),1);

ACT=270-D.DIM3_PHI;
plot(ACT)
% for i=1:8
% figure()
% plot(D.DIM2_THETA(:,i))
% end
phi=D.DIM3_PHI;
theta=0;
%phi=10:10:360;
x_sc=cos(LT*pi./12-pi);
y_sc=sin(LT*pi./12-pi);
z=zeros(length(ACT),1);

%%%%%conversion transformation matrix form spacecraft to J2000 co-ordinate
A=my_matrix(D.SC_TO_J2000);

%%%%%conversion from J2000 to RTP co-ordinates
B=my_matrix(D.J2000_TO_RTP);

%%%%%%%%%%% Space craft position from saturn in J2000 cartecian
%%%%%%%%%%% co-ordinates
X_J2000=D.SC_POS_SATURN_J2000XYZ(:,1)./60268;Y_J2000=D.SC_POS_SATURN_J2000XYZ(:,2)./60268;
Z_J2000=D.SC_POS_SATURN_J2000XYZ(:,3)./60268;
for i=1:length(x_sc)
    X_sat(i,:)=B(:,:,i)*[X_J2000(i),Y_J2000(i),Z_J2000(i)]';
    X_sat(i,1)=X_sat(i,1);X_sat(i,2)=X_sat(i,2)*180/pi;X_sat(i,3)=X_sat(i,3)*180/pi;
end
figure()
plot(X_J2000,'r')
hold on
plot(Y_J2000,'g')
plot(Z_J2000,'b')
grid on
% figure(2)
% plot(X_sat(:,2))
% figure(3)
% plot(X_sat(:,3))
R_sat=X_sat(:,1);theta_sat=X_sat(:,2);phi_sat=X_sat(:,3);

%%%%%%%%%%%%%%%%%%%%%%%% with respect to space crft frame 
% Vx_J2000=D.SC_VEL_SATURN_J2000XYZ(:,1);Vy_J2000=D.SC_VEL_SATURN_J2000XYZ(:,2);Vz_J2000=D.SC_VEL_SATURN_J2000XYZ(:,3);
% for i=1:length(x_sc);
%     V_sat(i,:)=B(:,:,i)*[Vx_J2000(i),Vy_J2000(i),Vz_J2000(i)]';
%      Vx(i)=V_sat(i,1);Vy(i)=V_sat(i,2);Vz(i)=V_sat(i,3);
%      V(i)=sqrt(Vx(i).^2+Vy(i).^2+Vz(i).^2);
% end
 %%%%%%%%Transformation with respect to space craft frame
[X_sc]=inverse_transformation2(X_J2000./60268,Y_J2000./60268,Z_J2000./60268,A);
% [phi_sc,theta_sc,R_sc] = cart2sph(X_sc(:,1),X_sc(:,2),X_sc(:,3));
% R_sc=R_sc./60268;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% space craft vector and co-rotation vector with respect to saturn co-ordinate system 
x_sat=R_sat.*cosd(phi_sat);y_sat=R_sat.*sind(phi_sat);
x_cor=R_sat.*cosd(LT.*pi./12-pi);y_cor=R_sat.*sind(LT.*pi./12-pi);
for i=1:length(x_sat)
    norm1(i)=norm([x_sat(i),y_sat(i)]);norm2(i)=norm([x_cor(i),y_cor(i)]);
    angle(i)=acosd(dot([x_sat(i),y_sat(i)],[x_cor(i),y_cor(i)])./(norm1(i)*norm2(i)));
end
figure()
plot(angle)
I=find(angle<1);