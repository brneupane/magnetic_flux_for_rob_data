function [X_J2000_SC]=inverse_transformation2(X,Y,Z,A);
%A=inv(A);B=inv(B); 
n=length(X);

for i=1:n
   T1=inv(A(:,:,i));
   n=[X(i),Y(i),Z(i)];
   X_J2000_SC(i,:)=T1*(n)';
   
end
end
