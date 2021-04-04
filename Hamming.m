Eb_N0_dB = [0:1:10]; % multiple Eb/N0 values
Ec_N0_dB = -Eb_N0_dB + 10*log10(7/4);
EbNo = 10^(4/7);
R = 4/7;
sigma = sqrt(1/(2*R*EbNo));
K = 4;
N = 7;
%all possible code words from generation matrix to compare min distance
cwords = [0 0 0 0 0 0 0;
0 0 0 1 0 1 1;
0 0 1 0 1 1 0;
0 1 0 1 1 0 0;
1 0 1 1 0 0 0;
0 1 1 0 0 0 1;
1 1 0 0 0 1 0;
1 0 0 0 1 0 1;
0 1 0 0 1 1 1;
1 0 0 1 1 1 0;
0 0 1 1 1 0 1;
0 1 1 1 0 1 0;
1 1 1 0 1 0 0;
1 1 0 1 0 0 1;
1 0 1 0 0 1 1;
1 1 1 1 1 1 1;
]
Nbiterrs = 0;
Nblocks = 1000;
Nerrs=[];
y = 0;
on = 0;
for l = 1:length(Eb_N0_dB)
Nbiterrs = 0;
for i = 1:(Nblocks)
y = 0;
msg = randi([0,1],1,K); %generation of random msgs
cword = [msg mod(msg(1)+msg(2)+msg(3),2)...
mod(msg(2)+msg(3)+msg(4),2)...
mod(msg(1)+msg(2)+msg(4),2)]; %code word generation
s = 1-2*cword; %BPSK bit to symbol
EbNo = 10.^(-Ec_N0_dB(l)/10);
sigma = sqrt(1/(2*R*EbNo));
r = s+sigma*(randn(1,N));% adding AWGN noise
%hard decision decoding
 b = (real(r)<0);
 dist = mod(repmat(b,16,1)+cwords,2)*ones(7,1);
 [mind,pos] = min(dist);
 msg_cap1 = cwords(pos,1:4);
 %soft-decision decoding
 corr = (1-2*cwords)*r';
 [mind2,pos1] = max(corr);
 msg_cap2 = cwords(pos1,1:4);
 %use msg_cap1 for hard-decoding and msg_cap2 for soft decoding

 y = sum(msg ~= msg_cap1);
 if(y>0)
 Nbiterrs = Nbiterrs+y;
 end
 on = max(on,y);
 end

 Nerrs(l) = Nbiterrs/on;

end
BER_th = 0.5*erfc(sqrt(10.^(Eb_N0_dB/10)));
BER_sim = Nerrs/7000;
close all
figure
semilogy(Eb_N0_dB,BER_th,'bd-','LineWidth',2);
hold on
semilogy(Eb_N0_dB,BER_sim,'ms-','LineWidth',2);
axis([0 10 10^-5 0.5])
grid on
legend('theory - uncoded', 'simulation - Hamming 7,4 (hard)');
xlabel('Eb/No, dB');
ylabel('Bit Error Rate');
title('BER for BPSK in AWGN with Hamming (7,4) code');