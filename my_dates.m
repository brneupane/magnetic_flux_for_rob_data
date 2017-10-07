
function Dates=my_dates(yr,day,hr)
[path_name]=folder_path(yr,day,hr);

%%%acess to the given file of data
[D,Dinfo]=readheaderL3_test(path_name);

yr=str2num(D.UTC(:,1:4));day=str2num(D.UTC(:,6:8));hr=str2num(D.UTC(:,10:11));min=str2num(D.UTC(:,13:14));
sec=str2num(D.UTC(:,16:end));
Dates=[yr';day';hr';min';sec'];
end