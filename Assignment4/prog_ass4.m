A=input('1.ODE\n2.BVP');
if A==1
    
    choice=input('1.Euler forward\n2.Euler backward\n3.Trapezoidal\n4.4th-order adams-bashforth\n5.4th order adams-moulten\n6.4th order BDF\n7.4th order runge kutta');
    if choice ==1
        Eufor;
    elseif choice ==2
        Eubac;
    elseif choice ==3
        Trap;
    elseif choice ==4
        AB;
    elseif choice ==5
        adamM;
    elseif choice ==6
        BDF;
    elseif choice ==7
        RK4;
    else fprintf('Wrong Input choice');
    end
elseif(A==2)
    
  clc
h=input('Enter grid size:\n');
n=2/h+1;
x(1)=0;
%p1=0;
choice = input('Which method to use?\n1.using Ghost node\n2.using backward difference');
if choice==1
    l=zeros(n-1);
    d=zeros(n-1);
    u=zeros(n-1);
    b=zeros(n-1);
    for i=2:n
        x(i)=x(i-1)+h;
    end
    
    for i=2:n-2
        l(i)=(1/h^2) +(x(i+1)+3)/(2*h*(x(i+1)+1));
    end
    l(n-1)=2/(h^2);
    
    for i=1:n-1
        d(i)=-2/(h^2)+(x(i+1)+3)/(x(i+1)+1)^2;
    end
    
    for i=1:n-2
        u(i)=1/(h^2)-((x(i+1)+3)/(2*h*(x(i+1)+1)));
    end
    
    i=1;
    b(1)=2*(x(i+1)+1)+3*(x(i+1)+3)/(x(i+1)+1)^2-5*(1/(h^2)+(x(i+1)+3)/(2*h*(x(i+1)+1)));
    for i=2:n-1
        b(i)=2*(x(i+1)+1)+3*(x(i+1)+3)/(x(i+1)+1)^2;
    end
    
    a=length(l);
    alpha=zeros(a,1);
    beta=zeros(a,1);
    X=zeros(a,1);
    alpha(1,1)=d(1,1);
    beta(1,1)=b(1,1);
    
    for i=2:a
        alpha(i,1)=d(i,1)-(l(i,1)/alpha(i-1,1))*u(i-1,1);
        beta(i,1)=b(i,1)-(l(i,1)/alpha(i-1,1))*beta(i-1,1);
    end
    
    X(a,1)=beta(a,1)/alpha(a,1);
    for i=a-1:-1:1
        X(i,1)=(beta(i,1)-u(i,1)*X(i+1,1))/alpha(i,1);
    end
    X = [5;X];
    file = fopen('ghostNode.txt','w');
    for i=1:n
        fprintf(file,'The temperature at node %f is %f\n',x(i),X(i));
    end
    title('Plot of Temperature vs node points');
    p1 = plot(x(1:n),X);
    legend(p1,'ghost node');
    hold on;
    scatter(x(1:n),X);
else
    n=2/h;
    x=zeros(n+1,1);
    x(1)=0;
    for i=2:n+1
        x(i)=x(i-1)+h;
    end
    
    l=zeros(n-1);
    d=zeros(n-1);
    u=zeros(n-1);
    b=zeros(n-1);
    
    for i=2:n-2
        l(i)=(1/h^2) +(x(i+1)+3)/(2*h*(x(i+1)+1));
    end
    l(n-1)=(2/3)*(1/h^2) + (2/3)*(x(n)+3)/(h*(x(n)+1));
%     (4*(x(i+1)+3))/(2*h*(x(i+1)+1)));     
    for i=1:n-1
        d(i)=-2/(h^2)+(x(i+1)+3)/(x(i+1)+1)^2;
    end
    d(n-1)= d(n-1)+(4/3)*(1/(h^2)-(x(n)+3)/(2*h*(x(n)+1)));
    for i=1:n-2
        u(i)=1/(h^2)-((x(i+1)+3)/(2*h*(x(i+1)+1)));
        
    end
    
    mat=zeros(n-1,n-1);
    
    for i=1:n
        mat(i,i)=d(i);
        if i>1
            mat(i,i-1)=l(i);
        end
        if i<n-1
            mat(i,i+1)=u(i);
        end
    end
    
    
    i=1;
    b(1)=2*(x(i+1)+1)+3*(x(i+1)+3)/(x(i+1)+1)^2-5*(1/(h^2)+(x(i+1)+3)/(2*h*(x(i+1)+1)));
    for i=2:n-1
        b(i)=2*(x(i+1)+1)+3*(x(i+1)+3)/(x(i+1)+1)^2;
    end
    
    %fprintf('Matrix \n');
    %disp(mat);
    
    a=length(l);
    alpha=zeros(a,1);
    beta=zeros(a,1);
    X=zeros(a,1);
    alpha(1,1)=d(1,1);
    beta(1,1)=b(1,1);
    
    for i=2:a
        alpha(i,1)=d(i,1)-(l(i,1)/alpha(i-1,1))*u(i-1,1);
        beta(i,1)=b(i,1)-(l(i,1)/alpha(i-1,1))*beta(i-1,1);
    end
    
    X(a,1)=beta(a,1)/alpha(a,1);
    for i=a-1:-1:1
        X(i,1)=(beta(i,1)-u(i,1)*X(i+1,1))/alpha(i,1);
    end
    Y(1) = 5;
    Y(2:n) = X;
    Y(n+1) = 1/3*(4*Y(n) - Y(n-1));
    file = fopen('backward.txt','w');
    
    fprintf(file,'Temperature Profile\n ');
    for i=1:n+1
        fprintf(file,'%f    %f \n',x(i),Y(i));
    end
    fclose(file);
    title('Plot of Temperature vs node points');
    p2 = plot(x(1:n+1),Y(1:n+1));
    hold on;
    scatter(x(1:n+1),Y(1:n+1));
    legend([p1,p2],{'ghost node','backward'});
end
    %a=input('Enter a(x): ','s');
%A=str2func(a);
%b=input('Enter b(x): ','s');
%B=str2func(b);
%f=input('Enter f(x): ','s');
%F=str2func(f);

%add2=input('Name of file to take input from: ','s');
%add3=input('Name of the output file','s');
%po=fopen(add2,'r');
%a=fgets(po);
%a=strcat('@(x) ',a);
%A=str2func(a);

%b=fgets(po);
%b=strcat('@(x) ',b);
%B=str2func(b);

%a=strcat('@(x) ',a);
%A=str2func(F);
%f=fgets(po);
%f=strcat('@(x) ',f);
%F=str2func(f);
%h=input('Enter step size: ');
%L=input('Enter total length: ');
%n=(L/h)+1;
%X=zeros(1,n);
%T=zeros(1,n);
%P=input('Press M for 2nd order backward difference at last node.\nPress N for 2nd order central difference with ghost node at last node.\n','s');
%T(1)=input('Enter temperature at 1st point: ');
%X(1)=input('Enter 1st point: ');
%K(1)=T(1);

%j=2;
%G=0;
%G(1,1)=1;
%while(j<n+1)
%    X(j)=X(j-1)+h;
%    j=j+1;
%end

%i=2;
%while(i<n)
%    G(i,i-1)=1/(h^2)-(A(X(i))/(2*h));
%    G(i,i)=-(2/(h^2))+B(X(i));
%    G(i,i+1)=1/(h^2)+(A(X(i))/(2*h));
%    K(i)=F(X(i));
%    i=i+1;
%end

%if(P=='M')
%    G(i,i-2)=1/(h^2);
%    G(i,i-1)=-2/(h^2);
%    G(i,i)=1/(h^2)+B(X(i));
%    K(i)=F(X(i));
%end

%if(P=='N')
 %   w=input('Enter temperature at ghost node: ');
 %   G(i,i-1)=1/(h^2)-(A(X(i))/(2*h));
 %   G(i,i)=-2/(h^2)+B(X(i));
 %   K(i)=F(X(i))-w*(1/(h^2)+A(X(i))/(2*h));
%end

%i=1;
%while(i<n)
%    j=i+1;
 %   while(j<n+1)
 %       K(j)=K(j)-(G(j,i)/G(i,i))*K(i);
 %       G(j,:)=G(j,:)-(G(j,i)/G(i,i))*G(i,:);
 %       j=j+1;
 %   end
 %   i=i+1;
%end

%i=n;

%while(i>0)
 %   s=0;
 %   t=n;
 %   while(t>i)
 %       s=s+T(t)*G(i,t);
 %       t=t-1;
 %   end
 %   T(i)=(K(i)-s)/G(i,i);
 % i=i-1;
%end

%X
%T
%plot(X,T);
%p2=fopen(add3,'a');
%fprintf(p2,"\nBVP\n\nX value Y value\n");
%j=1;
%while(j<n+1)
%    fprintf(p2,"%f\t%f\n",X(j),T(j));
%    j=j+1;
%end

   
end