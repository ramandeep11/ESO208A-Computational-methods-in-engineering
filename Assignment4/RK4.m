function RK4
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
fclose(po);
i=1;
yo=zeros((xf-x0)/h+1,1);
yo(1)=y0;
x=zeros((xf-x0)/h+1,1);
x(1)=x0;

while(x(i)<xf)
    x(i+1)=x(i)+h;
    q0=fun(x(i),yo(i));
    q1=fun(x(i)+h/2,yo(i)+h*q0/2);
    q2=fun(x(i)+h/2,yo(i)+h*q1/2);
    q3=fun(x(i)+h,yo(i)+h*q2);
    yo(i+1)=yo(i)+h/6*(q0+2*q1+2*q2+q3);
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
fprintf(p2,"\nRK-4\n\nX value Y value\n");
j=1;
while(j<(xf-x0)/h+2)
    fprintf(p2,"%f\t%f\n",x(j),yo(j));
    j=j+1;
end
end