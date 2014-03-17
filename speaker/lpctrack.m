function ret=lpctrack(x, fs)
%[filename,filepath]=uigetfile('*.wav');
%filename = '../helloworld.wav';
%[x fs]=wavread([filename]);
%x=VAD(x);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ȡ�����
 %�������ź�Ԥ����-Ԥ����(��ֹ��Ƶ,���Ƶ�Ƶ��Դ����50HZ)
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
%�������źżӴ�
wy = enframe(xx,hamming(240),80); %�ź� �� ֡��
D=size(wy);
H=D(1);%֡��
F=zeros(H,3);
P=zeros(H,3);
B=zeros(H,3);
k=0;%�������ȱʧ��ĸ���
M=[];
%��LPCϵ�� 12��
for j=1:H
    c=arburg(wy(j,:),10);
    %�����ź�Ƶ�װ���
    h=freqz(1,c);
    h=20*log(abs(h));
    %�ҹ����Ƶ�ʴ���
    z=find(diff(sign(diff(abs(h))))<0)+1;%��þֲ���ֵƵ��
    if size(z,1)>2%��֡�������3�����Ϲ����
        e=3;
    else
        e=size(z,1);
        for t=3:e+1
              k=k+1;
            M(k,1)=j;%��¼ȱʧ�ķ�ֵ����֡
            M(k,2)=t;%��¼��֡ȱʧ�ĵ�t��ֵ
        end
    end
        %�ö��η���ʽax^2+bx+c�����ƣ����������Ƶ��Fi�ʹ���Bi
    for i=1:e
        P=abs(h);
        f=fs/1024;
        m=z(i);
        c=P(m);
        a=(P(m+1)+P(m-1))/2-P(m);
        b=(P(m+1)-P(m-1))/2;
        F(j,i)=(-b/2/a+m)*f;%����Ƶ��
        P(j,i)=(b^2/4/a+c);%��ֵ�Ĺ�����
        B(j,i)=abs(sqrt(b^2-4*a*(c-0.5*P(1)))/a*f);%����
    end
end
%���������֡ȱʧ�ķ�ֵ
[r,s]=size(M);
if r~=0%r��Ϊ0��˵���з�ֵȱʧ
for i=1:r
    R=M(i,1);
    S=M(i,2);
    if R==1%����ǵ�һ֡ȱʧ����壬��ֵȡ2��3֡�ľ�ֵ
        F(R,S)=0.5*(F(R+1,S)+F(R+2,S));
    else if R==H%��������һ֡ȱʧ����壬��ֵȡǰ��֡�ľ�ֵ
             F(R,S)=0.5*(F(R-1,S)+F(R-2,S));
        else
    F(R,S)=0.5*(F(R-1,S)+F(R+1,S));%����֡ȡǰ����֡�ľ�ֵ
        end
    end
end
end



F1=F;
th=240;%�˴��ο����ס����������ת��Ϊ���������Ĺ����ṹ�о���P42
D=zeros(H+5);
 for j=1:3
     aver=mean(F1(:,j)');
     D=[aver,aver,F1(:,j)',aver,aver,aver];
     for n=3:(H+2)
         Dab=abs(D(n)-D(n-1));
         if Dab>th%��ƽ��
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


 %�Թ����켣������ֵƽ������5����3�㣩
F2=F1;%�������5����ֵƽ����Ĺ����
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

%title(['ʹ��lpc����ȡ�Ĺ������:' '     ' num2str(ff(1)) 'hz' '     ' num2str(ff(2)) 'hz'  '     ' num2str(ff(3))  'hz']);
%figure;
%subplot(2,1,1);
%plot(x);
%title('�����ź�');
%subplot(2,1,2);
%plot(1:H,F2(:,1));
%hold on;
%plot(1:H,F2(:,2),'r');
%hold on;
%plot(1:H,F2(:,3),'k');
%title('ǰ���������켣(����ط�)');
end
