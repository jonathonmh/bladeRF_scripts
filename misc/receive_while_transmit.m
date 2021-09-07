% From https://nuand.com/forums/viewtopic.php?t=3757
%  by fdavies
% based on a file from https://github.com/Nuand/bladeRF/wiki/bladeRF-CLI-Tips-and-Tricks
%  modified
%

GUARD_BAND= 0.5e6;  % separate the frequency sweep zone from the DC spikes
SAMPLE_RATE = 24e6;
NUM_SAMPLES = 131072;  % 
NUM_SECONDS = NUM_SAMPLES/SAMPLE_RATE;

SCAN_WIDTH = (SAMPLE_RATE/4-GUARD_BAND*2);

SCAN_START = 2600e6;
SCAN_STOP = 3600e6;

freq_list = SCAN_START:SCAN_WIDTH:SCAN_STOP;

START_FREQ_RAD = (GUARD_BAND/2) * 2 * pi;  % it will be a complex frequency
STOP_FREQ_RAD = (SAMPLE_RATE/4-(GUARD_BAND/2)) * 2 * pi;

RX_TX_DELTA = SAMPLE_RATE/4;  % to prevent rx PLA and tx PLA mutual interference (pos for rx>tx)

DELTA= (1/2)*(STOP_FREQ_RAD - START_FREQ_RAD)/NUM_SECONDS;
t = [ 0 : (1/SAMPLE_RATE) : ((NUM_SECONDS) - 1/SAMPLE_RATE) ];
tx_signal = (0.8+(0.075/NUM_SECONDS)*t) .* exp(1j .* (START_FREQ_RAD+DELTA.*t) .* t);

save_sc16q11('/media/ramdisk/tx_waveform.sc16q11', tx_signal);

%  set up the bladeRF with a bunch of system command line calls
  %system(["cal lms"]);
  system(["bladeRF-cli -e 'set samplerate rx ",num2str(SAMPLE_RATE),"'"]);
  system(["bladeRF-cli -e 'set bandwidth rx ",num2str(SAMPLE_RATE),"'"]);
  system(["bladeRF-cli -e 'set bandwidth tx ",num2str(SAMPLE_RATE),"'"]);
  system(["bladeRF-cli -e 'set samplerate tx ",num2str(SAMPLE_RATE),"'"]);
  system(["bladeRF-cli -e 'set lnagain 0'"]); % 0 3 6
  system(["bladeRF-cli -e 'set rxvga1 5'"]); % [5, 30]
  system(["bladeRF-cli -e 'set rxvga2 0'"]); % [0, 30]
  system(["bladeRF-cli -e 'set txvga1 -4'"]); %  [-35, -4]
  system(["bladeRF-cli -e 'set txvga2 25'"]); % [0, 25]
  system(["bladeRF-cli -e 'tx config delay=0'"]); %

result=[]; % for when I do many in a row
freq_result=[];
rx_signal=[];

% so, it works by transmitting the sweep signal 3 times while activating 
% the receive.  This is necessary because I do not know how to synchonize
% the transmit and receive well

% so, transmit a frequency sweep from tx_freq+START_FREQ_RAD to tx_freq+STOP_FREQ_RAD
% note that this includes guard bands so it is wider than SCAN_WIDTH
% the part of the frequency sweep that will actually end up in the result is
%    tx_freq+GUARD_BAND to tx_freq+GUARD_BAND+SCAN_WIDTH
% receive it with a rx base frequency that is offset from the tx base frequency

%%%   now for the loop
for fr=freq_list
  % set the transmit and receive frequencies
  tx_freq = fr - GUARD_BAND;
  rx_freq = tx_freq+RX_TX_DELTA;
  system(["bladeRF-cli -e 'set frequency rx ",num2str(rx_freq),"'"]);
  system(["bladeRF-cli -e 'set frequency tx ",num2str(tx_freq),"'"]);
  system("bladeRF-cli -s script_H_1.txt"); % see below for contents of script_D_1.txt
  f = fopen("/media/ramdisk/rx_sample", "r", "ieee-le");
  samples = fread(f, Inf, "int16");
  fclose(f);
  samples_i = samples(1:2:end, :)';
  samples_q = samples(2:2:end, :)';
  rx_signal = (samples_i + j * samples_q);
  % the spectrum will go from -1/SAMPLE_RATE to 1/SAMPLE_RATE in frequency
  spectrum=20*log10(abs(fftshift(fft(rx_signal)))/NUM_SAMPLES);
  trim_start = floor(NUM_SAMPLES/4+NUM_SAMPLES*(GUARD_BAND/SAMPLE_RATE));
  trim_stop = floor(NUM_SAMPLES/2-NUM_SAMPLES*(GUARD_BAND/SAMPLE_RATE));
  trim_width = trim_stop-trim_start+1;
  trimmed_spectrum=spectrum(trim_start:trim_stop);
  result=[result trimmed_spectrum]; % add a chunk to the result
  freq_result = [freq_result fr:SCAN_WIDTH/trim_width:fr+SCAN_WIDTH-(SCAN_WIDTH/trim_width)];
endfor

clf;
rx1=real(rx_signal);
h4=plot(freq_result,result);  %  here is where we see the result
axis([freq_result(1) freq_result(end) -50 30]);
h6=title('Spectrum assembled from pieces');grid on
h7=xlabel('Frequency');
h8=ylabel('dB');
grid on;
%set(gca(),'xtick',min(freq_list):1e6:max);
%set(gca(),'ytick',-30:5:30);
%saveas(h1,"t.png",'png');

% ***************************************
%  this is the script file used by the above
%
% tx config delay=0
% tx config file=/media/ramdisk/tx_waveform.sc16q11 format=bin
% rx config file=/media/ramdisk/rx_sample n=131072
% tx config repeat=3
% tx start 
% rx start
% tx wait
% rx wait
%

