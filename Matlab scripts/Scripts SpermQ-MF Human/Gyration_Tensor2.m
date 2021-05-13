function [b,p,e,vb,vp,ve,lamda]=Gyration_Tensor2(x,y,z)
% b, p, and e are the coordinates of x,y, and z in the coordinate system
% given by the eigenvectors of the gyration tensor.
% lambda ARE NOT the eigenvalues, but the sqr of them. In other words, they
% are the s.d. and NOT the variance.
index=((x==0)&(y==0));
x(index)=NaN;
y(index)=NaN;
z(index)=NaN;
%plot3(x,y,z);
%hold on;
[m,n]=size(x);
b=zeros(m,n);
p=zeros(m,n);
e=zeros(m,n);
cn_x=zeros(m);
cn_y=zeros(m);
cn_z=zeros(m);
lamda=zeros(m,3);
vp=zeros(m,3);
vb=zeros(m,3);
ve=zeros(m,3);

for j=1:m
sumx=0;
sumy=0;
sumz=0;
points=0;

for i=1:n
    if not(isnan(x(j,i)))
        points=points+1;
        sumx=sumx+x(j,i);
        sumy=sumy+y(j,i);
        sumz=sumz+z(j,i);
    end
end
cn_x(j)=sumx/points;
cn_y(j)=sumy/points;
cn_z(j)=sumz/points;

x(j,:)=x(j,:)-cn_x(j);
y(j,:)=y(j,:)-cn_y(j);
z(j,:)=z(j,:)-cn_z(j);

for i=1:n
    if isnan(x(j,i))
        x(j,i)=0;
        y(j,i)=0;
        z(j,i)=0;
    end
end

mx=[x(j,:);y(j,:);z(j,:)];

tensor=mx*mx'/points;

[v,lamda_temp]=eig(tensor);

lamda_temp=lamda_temp^(1/2);
lamda(j,1)=lamda_temp(1,1);
lamda(j,2)=lamda_temp(2,2);
lamda(j,3)=lamda_temp(3,3);

vb(j,:)=v(:,1)';
vp(j,:)=v(:,2)';
ve(j,:)=v(:,3)';

if (j>2)&&(vb(j,:)*vb(j-1,:)'<0)
vb(j,:)=-vb(j,:);
end
if (j>2)&&(vp(j,:)*vp(j-1,:)'<0)
vp(j,:)=-vp(j,:);
end
if (j>2)&&(ve(j,:)*ve(j-1,:)'<0)
ve(j,:)=-ve(j,:);
end



new_cor=[vb(j,:);vp(j,:);ve(j,:)]*mx;
b(j,:)=new_cor(1,:);
p(j,:)=new_cor(2,:);
e(j,:)=new_cor(3,:);


  

%quiver3(cn_x,cn_y,cn_z,v(1,1),v(2,1),v(3,1),lamda(1,1));
%quiver3(cn_x,cn_y,cn_z,v(1,2),v(2,2),v(3,2),lamda(2,2));
%quiver3(cn_x,cn_y,cn_z,v(1,3),v(2,3),v(3,3),lamda(3,3));
%hold off;

% plot(p,e);
% axis equal;
% hold on;
%graphics_toolkit("gnuplot")
%plot3(e,p,b)

end
b(b==0)=NaN;
p(p==0)=NaN;
e(e==0)=NaN;

b(j,:)=b(j,:)-b(j,1);
p(j,:)=p(j,:)-p(j,1);
e(j,:)=e(j,:)-e(j,1);

pl=lamda(:,1)./lamda(:,2);
% plot(pl);

%for j=1:50

%quiver3(0,0,0,vb(j,1),vb(j,2),vb(j,3),lamda(j,1),'g')
%hold on
%quiver3(0,0,0,vp(j,1),vp(j,2),vp(j,3),lamda(j,2),'r')

%quiver3(0,0,0,ve(j,1),ve(j,2),ve(j,3),lamda(j,3),'b')
%axis equal  
%end    
%hold off;
%pause


end



    