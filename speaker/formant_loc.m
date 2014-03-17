function F = formant_loc(A,L)
% F = FORMANT_LOC(A,L)
%   Takes input row vectors A and L with area (cm^2) and length (cm)
%   parameters.  Row vector length equals number of tubes in desired model.  
%   Returns plot to find formant locations and numerical values for formant 
%   locations (in Hz) in F.  NOTE: If zero-length tube(s) is desired, enter "0" as first 
%   element(s) of L.
%
%   EXAMPLE:
%   >> formant_loc([0.9 0.25 0.5],[9.5 2 5])
%   Formant locations (F1 through FN) for input tube model: 
%
%   formant_locations_in_Hz =
%
%         393        1767        2269        3615
%

% Define constants
c = 34000; % Speed of sound in air
f = 1:4000; % Frequency range, speech bandwidth
k = length(A); % Number of tubes

% Admittance functions for tube model
f1 = A(1)*tan(f*2*pi*L(1)/c); % Admittance for closed tube, glottis direction

sm = 0;
for i = 2:k
    sm = sm + 1./A(i)*tan(f*2*pi*L(i)/c); % Impedance for open tube(s), lip direction
end
f2 = 1./sm; % Make admittance (serial connection)

% Find equalities
epsilon = 0.1; % Set threshold
eq_vec = (abs(f1-f2) < epsilon);
a = find(eq_vec == 1); % Pick out frequencies
cnt = 1;
fl = 0;
for i = 1:length(a)-1
    if abs(a(i+1)-a(i)) < 2
        fl(i,cnt) = a(i);
    else
        fl(i,cnt) = a(i);
        cnt = cnt+1;
    end
end
s = size(fl);
formant_locations_in_Hz(1:s(2)) = 0;
for j = 1:s(2);
    fl_min = min(find(fl(:,j) ~= 0));
    fl_max = max(find(fl(:,j) ~= 0));
    formant_locations_in_Hz(j) = round(mean(fl(fl_min:fl_max,j)));
end
disp('Formant locations (F1 through FN) for input tube model: ');
formant_locations_in_Hz
        
% Generate plots
plot(f,f1)
hold on
grid on
plot(f,f2,'r')
axis([0 4000 -8 8])
title('Graphical solution for input tube model formant frequencies')
eval(['title(''Graphical solution for input ', num2str(k),' tube model formant frequencies'')'])
xlabel('Hz')
ylabel('Amplitude')

% Mark formant frequencies on plot
for i = 1:length(formant_locations_in_Hz)
    f3 = f1(formant_locations_in_Hz(i));
    plot(formant_locations_in_Hz(i),f3,'gx')
    plot(formant_locations_in_Hz(i),f3,'go')
end
