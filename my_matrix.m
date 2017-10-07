function [A]=my_matrix(X);
%X=[1 3 4 7 9 0 1 10 3; 12 11 10 -9 -8 5 9 5 4];
%%Here X is [a b c d e f g h i];
[n,m]=size(X);
A=zeros(3,3,n);
for i=1:n
    A(1,:,i)=X(i,1:3);
    A(2,:,i)=X(i,4:6);
    A(3,:,i)=X(i,7:9);
end
end