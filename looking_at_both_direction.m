% clear all
% clc
%2004-299T16:38:09.178
%test date kk=2007-266T10:43:49.151
%%%%This gives the path name for accessing the files
function [both_direction]=looking_at_both_direction(rob_yr,rob_day,rob_hr,rob_min,rob_sec)

if rob_hr<6
    file_number='00';
elseif rob_hr<12
    file_number='06';
elseif rob_hr<18
    file_number='12';
else
    file_number='18';
end
[path_name]=folder_path(rob_yr,rob_day,file_number);
%%%acess to the given file of data
[D,Dinfo]=readheaderL3_test(path_name);

LT=D.SC_POS_LOCAL_TIME;

Dates=D.UTC;

R=D.SC_POS_R;
%%%%%Taking phi co-ordiantes from data
phi=D.DIM3_PHI;

ACT=270-phi;

Dates=my_dates(rob_yr,rob_day,file_number);

%%%%%%This is finding of the date near to the rob-date 4 is for minute and
%%%%%%3 is for hour 
kk=find(Dates(4,:)==rob_min & Dates(3,:)==rob_hr) ;
if isempty(kk)
    both_direction=0;
    return
end
%%%%%Here kk1 gives the corresponding minimum value while I gives the
%%%%%position of the minimum in vector 
[kk1,I] = min(abs(Dates(5,kk)-rob_sec));
%%%%%This is the refrence position
ref_value=kk(I);
%%%%%%%%This is looking at the for data for one actuationtime assuming 4
%%%%%%%%min on either sides of the data 
ref_min=ref_value-8;
ref_max=ref_value+8;
 if ref_min<9
     ref_min=ref_value;
     ref_max=ref_value+16;
 end
 if ref_max>=length(ACT)
     ref_max=ref_value;
     ref_min=ref_value-16;
 end
     
% figure(101)
% plot(ACT(ref_min:ref_max))



x=[];

%%%%%%making plots
theta=[80 60 40 20 -20 -40 -60 -80 0];
%theta=0;m=1;
for m=1:length(theta)
    %%%considering unit sphere 
    r=1;
    
    x_sc=cosd(theta(m)).*cosd(phi(ref_min:ref_max));
  y_sc=cosd(theta(m)).*sind(phi(ref_min:ref_max));
  
  z_sc=sind(theta(m)).*ones(length(x_sc),1);
  %%%%% Transformation matrix form spacecraft to J2000 co-ordinate
 A=my_matrix(D.SC_TO_J2000);
ref_A=A(:,:,ref_min:ref_max);


%%%%%conversion from J2000 to RTP co-ordinates
B=my_matrix(D.J2000_TO_RTP);
ref_B=B(:,:,ref_min:ref_max);
%%%%%% Transformation from spacecraft frame to J2000 frame
for i=1:length(x_sc);
    
X_J2000(i,:)=ref_A(:,:,i)*[x_sc(i),y_sc(i),z_sc(i)]';

end

%%%%%% Transform co-ordinate  from Spacecraft frame
%%%%%% to J2000 frame 

x_J2000=X_J2000(:,1);y_J2000=X_J2000(:,2);z_J2000=X_J2000(:,3);
for i=1:length(x_sc);
    
X_sat(i,:)=B(:,:,i)*[x_J2000(i),y_J2000(i),z_J2000(i)]';
end
%%%%%%%%%%Co-ordinates in saturn frame of reference
R_sat=X_sat(:,1);theta_sat=X_sat(:,2);phi_sat=X_sat(:,3);
%%%%%my_phi and my_theta  is value define by Rob 
my_phi=(2.5*pi-atan2(phi_sat,-theta_sat));
for i=1:length(x_sc);
     if R_sat(i)>0
         my_theta(i)=(pi-acos(R_sat(i)));
     else
        my_theta(i)=acos(-R_sat(i));
    end
end
x=[x my_theta];



%%%%%%%%%making of the plots 

% ref_theta=linspace(0,2*pi,100);
% rho=ones(size(ref_theta));
% 
% p=polar(ref_theta,pi*rho,'--');
% delete(findall(ancestor(p,'figure'),'HandleVisibility','off','type','line','-or','type','text'));
% daspect([1 1 1])
% hold on 
% p=polar(ref_theta,pi./2*rho,'-');
% %delete(findall(ancestor(p,'figure'),'HandleVisibility','off','type','line','-or','type','text'));
% daspect([1 1 1])
% hold on
% plot(0,0,'+k','MarkerSize',10,'LineWidth',4)
% %%%%%making polar plot using my_phi as azimuth and my_theta as the the
% %%%%%radial 
% h{m}=polar(my_phi,my_theta','.');
% hold on
% polar(ref_theta,1.*rho*pi./9);
% hold on
% polar(ref_theta,5.*rho.*pi./6)
end
if min(x)<pi./9 & max(x)>5*pi./6;
    both_direction=1;
else
    both_direction=0;
end
end