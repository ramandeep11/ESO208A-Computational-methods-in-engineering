clc
h=input('Enter grid size:\n');
n=2/h+1;
x(1)=0;
%p1=0;
choice = menu('Which method to use?','using Ghost node','using backward difference');
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