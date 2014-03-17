function ret=lpctrack(x, fs)
%[filename,filepath]=uigetfile('*.wav');
%filename = '../helloworld.wav';
%[x fs]=wavread([filename]);
%x=VAD(x);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%取共振峰
 %对语音信号预处理-预加重(截止高频,抑制低频电源干扰50HZ)
B = [1,-0.9375];
A = [1];
xx=filter(B,A,x);
wp1 =540;
ws1 =480;
rp1 = 0.11;
rs1 = 40;
[N1,wn1] = cheb1ord(wp1/(fs/2),ws1/(fs/2),rp1,rs1,'z');
[B,A] = cheby1(N1,rp1,wn1,'high');
xx = filter(B,A,xx);
%对语音信号加窗
wy = enframe(xx,hamming(240),80); %信号 窗 帧移
D=size(wy);
H=D(1);%帧数
F=zeros(H,3);
P=zeros(H,3);
B=zeros(H,3);
k=0;%用来标记缺失峰的个数
M=[];
%求LPC系数 12阶
for j=1:H
    c=arburg(wy(j,:),10);
    %语音信号频谱包络
    h=freqz(1,c);
    h=20*log(abs(h));
    %找共振峰频率带宽
    z=find(diff(sign(diff(abs(h))))<0)+1;%求得局部峰值频率
    if size(z,1)>2%此帧可以提出3个以上共振峰
        e=3;
    else
        e=size(z,1);
        for t=3:e+1
              k=k+1;
            M(k,1)=j;%记录缺失的峰值所在帧
            M(k,2)=t;%记录此帧缺失的第t峰值
        end
    end
        %用二次方程式ax^2+bx+c来近似，并求出中心频率Fi和带宽Bi
    for i=1:e
        P=abs(h);
        f=fs/1024;
        m=z(i);
        c=P(m);
        a=(P(m+1)+P(m-1))/2-P(m);
        b=(P(m+1)-P(m-1))/2;
        F(j,i)=(-b/2/a+m)*f;%中心频率
        P(j,i)=(b^2/4/a+c);%峰值的功率谱
        B(j,i)=abs(sqrt(b^2-4*a*(c-0.5*P(1)))/a*f);%带宽
    end
end
%处理非连续帧缺失的峰值
[r,s]=size(M);
if r~=0%r不为0，说明有峰值缺失
for i=1:r
    R=M(i,1);
    S=M(i,2);
    if R==1%如果是第一帧缺失共振峰，其值取2、3帧的均值
        F(R,S)=0.5*(F(R+1,S)+F(R+2,S));
    else if R==H%如果是最后一帧缺失共振峰，其值取前两帧的均值
             F(R,S)=0.5*(F(R-1,S)+F(R-2,S));
        else
    F(R,S)=0.5*(F(R-1,S)+F(R+1,S));%其他帧取前后两帧的均值
        end
    end
end
end



F1=F;
th=240;%此处参考文献《汉语耳语音转换为正常语音的共振峰结构研究》P42
D=zeros(H+5);
 for j=1:3
     aver=mean(F1(:,j)');
     D=[aver,aver,F1(:,j)',aver,aver,aver];
     for n=3:(H+2)
         Dab=abs(D(n)-D(n-1));
         if Dab>th%需平滑
            d0=abs(D(n-1)-D(n-2));
            d1=abs(D(n+1)-D(n-1));
            d2=abs(D(n+2)-D(n+1));
            if (d0<th)&(d1<th)&(d2<th)
                D(n)=0.5*(D(n-1)+D(n+1));
            else if (d0<th)&(abs(D(n+2)-D(n-1))<th)&(abs(D(n+2)-D(n+3))<th)
                    D(n)=0.5*(D(n-1)+D(n+2));
                else
                    D(n)=0.5*(D(n-1)+D(n+3));
                end
            end
         end
     end
     F1(:,j)=D(3:(H+2))';
 end


 %对共振峰轨迹进行中值平均（先5点再3点）
F2=F1;%用来存放5点中值平均后的共振峰
f=zeros(H+4);
for j=1:3
    aver=mean(F2(:,j)');
    f=[aver,aver,F2(:,j)',aver,aver];
    for i=3:(H+2)
      f(i)=median(f((i-1):(i+1)));
    end
    F2(:,j)=f(3:(H+2))';
end

ret = F2(:,1);

%title(['使用lpc法提取的共振峰是:' '     ' num2str(ff(1)) 'hz' '     ' num2str(ff(2)) 'hz'  '     ' num2str(ff(3))  'hz']);
%figure;
%subplot(2,1,1);
%plot(x);
%title('语音信号');
%subplot(2,1,2);
%plot(1:H,F2(:,1));
%hold on;
%plot(1:H,F2(:,2),'r');
%hold on;
%plot(1:H,F2(:,3),'k');
%title('前三个共振峰轨迹(自相关法)');
end
