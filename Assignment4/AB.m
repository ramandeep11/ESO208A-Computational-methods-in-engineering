function AB

add=input('Name of file to take input from: ','s');
add3=input('Name of the output file','s');
po=fopen(add,'r');
F=fgets(po);
F=strcat('@(x,y) ',F);
fun=str2func(F);
X=fscanf(po,'%f');
x0=X(1);
y0=X(2);
xf=X(3);
h=X(4);
tol=X(5);
i=1;
fclose(po);
yo=zeros((xf-x0)/h+1,1);
yo(1)=y0;
x=zeros((xf-x0)/h+1,1);
x(1)=x0;
yo(2)=yo(1)+h*fun(x(1),yo(1));
x(2)=x(1)+h;
yo(3)=yo(2)+h*fun(x(2),yo(2));
x(3)=x(2)+h;
yo(4)=yo(3)+h*fun(x(3),yo(3));
x(4)=x(3)+h;
while (x(i+3)<xf)
    %i1=yo(i+4);
    %error=10;
     x(i+4)=x(i+3)+h;
    
    yo(i+4)=yo(i+3)+h*(55/24*fun(x(i+3),yo(i+3))-59/24*fun(x(i+2),yo(i+2))+37/24*fun(x(i+1),yo(i+1))-3/8*fun(x(i),yo(i)));
   
    i=i+1;
end
x=linspace(x0,xf,((xf-x0)/h)+1);
y=yo(1:(xf-x0)/h+1);
y((xf-x0)/h+1)
plot(x,y);
hold on;
xlabel('X value');
ylabel('Y value');
p2=fopen(add3,'a');
fprintf(p2,"\nAB-4\n\nX value Y value\n");
j=1;
while(j<(xf-x0)/h+2)
    fprintf(p2,"%f\t%f\n",x(j),yo(j));
    j=j+1;
end
end