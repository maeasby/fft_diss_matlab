%% This software can be used to import data from spreadsheet, fft and 1-3oct analysis
% For  piezoelectric pads used in and around engine room
% for vibrational information and potential use for renewable energy.

%% Set up the Import Options and import the data
% Use excel format to import data
 clc,clear,close all;
% Import the data
[filename, directory] = uigetfile({'*.xlsx';'*.xls';'*.mat';'*.*'},'Select a file to analyse');
% [filename] = uigetfile({'*.txt';'*.xls';'*.mat';'*.*'},'Select a file to analyse');

if filename == 0
    errordlg('Error!')
    return
end
opts = spreadsheetImportOptions("NumVariables", 4);

% Specify sheet and range
opts.Sheet = "Prop_2000_4";
opts.DataRange = "A24:D10263";

% Specify column names and types
opts.VariableNames = ["Time","VoltageAtPlate", "VoltageAtload", "Acceleration"];
opts.VariableTypes = ["double", "double", "double", "double"];
T = readtable(filename,'Sheet',opts.Sheet,'Range',opts.DataRange,'ReadVariableNames',false);
                       
%% Convert to output type 
X = table2array(T);
Fs=1/X(2,1);
%% fft

L=length(X(:,1));
Fs=1/X(2,1);
% L=length(X(:,1));    % Length of signal
T = 1/Fs;             % Sampling period       
t = (0:L-1)*T; 
% fft
for iii=2:1:4; % change the number according to the raw data coloums
    
Y(:,iii) = fft(X(:,iii));
P2(:,iii)= abs(Y(:,iii)/L);
P1(:,iii)= P2(1:L/2+1,iii);
P1(2:end-1,iii) = 2*P1(2:end-1,iii);
df=Fs/L; % df= The FFT resolution 
f = df*(0:(L/2));

P1_dB(:,iii)=20*log10(P1(:,iii)/1e-6);
end

figure(1);
% title(['Narrow band spectrum ',name]);


p1=semilogx(f, P1(:,2), 'color', [0 0 0],         'linewidth', 2,                    'marker', 's', 'MarkerSize', 1);
% hold on;
%  set(gca, 'color', 0.7*[1 1 1]);
legend({'VoltageAtPlate'}, 'location', 'NorthEast');
xlabel('Frequency Hz', 'Fontsize', 10);
set(gca, 'Fontsize', 10);
xlabel('Frequency band [Hz]'); ylabel('Volt');
xlim([10 1000]);

%%%%%%%%%%%%%%%%%%%%

figure(2);
p2=semilogx(f, P1(:,3), 'color', [0 0 1],         'linewidth', 2,                    'marker', '*', 'MarkerSize',1);
legend({'VoltageAtLoad'}, 'location', 'NorthEast');
xlabel('Frequency band [Hz]'); ylabel('Volt');
xlim([10 1000]);
figure(3);
p3=semilogx(f, P1(:,4), 'color', [0 1 1],         'linewidth', 2,                    'marker', '+', 'MarkerSize', 1);
legend({'Acceleration (g)'}, 'location', 'NorthEast');
xlabel('Frequency band [Hz]'); ylabel('g');
xlim([10 1000]);


