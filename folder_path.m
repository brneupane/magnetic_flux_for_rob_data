function [path_name]=folder_path(yr,day,hr)
%yr=2005;day=113;hr='00';


initial_path='/Users/brneupane/Documents/untitled folder/CO-E_J_S_SW-CAPS-3-CALIBRATED-V1.0/DATA/CALIBRATED';
%%%Here i represnets the particular day in year 


    if day<10
        s1=strcat('/',num2str(yr),'/00',num2str(day));
        s2=strcat('/SNG_',num2str(yr),'00',num2str(day),hr,'_V01.DAT');
        s3=strcat(s1,s2);
        path_name=strcat(initial_path,s3);
    elseif day<100
      s1=strcat('/',num2str(yr),'/0',num2str(day));
        s2=strcat('/SNG_',num2str(yr),'0',num2str(day),hr,'_V01.DAT');
        s3=strcat(s1,s2);
        path_name=strcat(initial_path,s3);  
        
    else
      s1=strcat('/',num2str(yr),'/',num2str(day));
        s2=strcat('/SNG_',num2str(yr),num2str(day),hr,'_V01.DAT');
        s3=strcat(s1,s2);
        path_name=strcat(initial_path,s3);    
    end

end
