%%%%%THis look at the diffrent M_dot value for the diffrent quadrent
clear all
clc
path_name='/Users/brneupane/Desktop/Physics_project/rob_wilson_data/';
 file_name='CAS_CAPS_FITTED_PARAMETERS_WILSON_V01.CSV';
  format_spec='%s %d %f %f %f %f %f %f %f %f  %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f';
 full_file_name = horzcat(path_name,file_name);
fid=fopen(full_file_name);
 
 rob_Data=textscan(fid,format_spec,'HeaderLines',1,'Delimiter',',');
fid(close)
Dates=rob_Data{1};
for i=1:length(Dates)
    rob_yr(i,:)=str2num(Dates{i}(1:4));rob_day(i,:)=str2num(Dates{i}(6:8));rob_hr(i,:)=str2num(Dates{i}(10:11));
    rob_min(i,:)=str2num(Dates{i}(13:14));rob_sec(i,:)=str2num(Dates{i}(16:end));
end
%%%%%%%%%%%%%%%%%%%%%%%%%Here booth look direction is from 2004 to 2007
%%%%%%%%%%%%%%%%%%%%%%%%%313day

load both_direction.mat
 I=find(both_direction==1);
 
 %%%%%This is diffrent moments conforming both look direction of space-craft 
 R=rob_Data{3}(I); vr=rob_Data{29}(I);vt=rob_Data{30}(I);vp=rob_Data{31}(I);
 nw=rob_Data{32}(I); fit_ref=rob_Data{56}(I); Tpara=rob_Data{34}(I);LT=rob_Data{4}(I);
 %%%%%For selected local time
 II=find(( LT>19 & LT<24));
 R1=R(II); vr1=vr(II); vt1=vt(II); vp1=vp(II); nw1=nw(II); Tpara1=Tpara(II); LT1=LT(II);
 mw=17*1.67*10^(-27); % mass of water group in kg
Rs=58232;% Radius of saturn in Km
cof=10^(15)*(2*pi^1.5).*Rs.*Rs*mw;
 min_R=5; max_R=28;k1=3;
 m=0;
 %R1_pos=R1(vr1>0);Tpara1_pos=Tpara1(vr1>0); nw1_pos=nw1(vr1>0);vr1_pos=vr1(vr1>0);
 for i=min_R:k1:max_R
     m=m+1;
    
     map_T_pos=Tpara1(R1>=i & R1<i+k1);
      h=scaleheight(map_T_pos);
     map_mass=nw1(R1>=i & R1<i+k1).*h.*(i);
     map_vr=vr1(R1>=i & R1<i+k1);
     map_flow=map_mass.*map_vr;
     map_flow1=map_flow(~isnan(map_flow));
     x1=map_flow1(map_flow1>0);x2=map_flow1(map_flow1<0);
     n1=length(x1);n2=length(x2);
     my_val(m)=(geomean(x1)-geomean(abs(x2)));
     flow_mass(m)=nanmean(map_flow).*cof;
 end 
 plot(min_R:k1:max_R,my_val)
 xlim([5 27])
%  m=0;
%  R1_pos=R1(vr1<0);Tpara1_pos=Tpara1(vr1<0); nw1_pos=nw1(vr1<0);vr1_pos=abs(vr1(vr1<0));
%  for i=min_R:k1:max_R
%      m=m+1;
%     
%      map_T_pos=Tpara1_pos(R1_pos>=i & R1_pos<i+k1);
%       h=scaleheight(map_T_pos);
%      map_mass_pos=nw1_pos(R1_pos>=i & R1_pos<i+k1).*h.*(i);
%      map_vr_pos=vr1_pos(R1_pos>=i & R1_pos<i+k1);
%      map_flow_pos1=map_mass_pos.*map_vr_pos;
%      map_flow_pos=map_flow_pos1(~isnan(map_flow_pos1));
%      flow_mass_in(m)=geomean(map_flow_pos).*cof;
%  end 
%  
% 
% 
% for i=1:length(min_R:k1:max_R)
%     net(i)=flow_mass(i)-flow_mass_in(i);
%     if (isnan(flow_mass_in(i)))
%         net(i)=flow_mass(i);
%     end
%     if (isnan(flow_mass(i)))
%         
%         net(i)=flow_mass_in(i);
%     end
% end
% plot(min_R:k1:max_R,net)
% xlim([5 27])