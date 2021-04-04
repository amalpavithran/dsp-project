clear;
close all;
N = 7;
K = 4;
Eb_N0_db = [0:1:10];
Ec_N0_db = -Eb_N0_db + 10*log10(N/K);
R = K/N;
Eb_N0 = 10^(R);
sigma = sqrt(1/2*R*Eb_N0);
cwords = [
    0 0 0 0 0 0 0;
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
N_bit_errors = 0;
N_blocks = 1000;
N_errors=[];
on = 0;
for n = 1:length(Eb_N0_db)
    N_bit_errors = 0;
    for i = 1:(N_blocks)
        msg = randi([0,1],1,K);
        cword = [
            msg mod(msg(1)+msg(2)+msg(3),2)...
            mod(msg(2)+msg(3)+msg(4),2)...
            mod(msg(1)+msg(2)+msg(4),2)
            ];
        s = 1-2*cword;
        Eb_N0 = 10.^(-Ec_N0_db(n)/10);
        sigma = sqrt(1/(2*R*Eb_N0));
        r = s+sigma*(randn(1,N));
        b = (real(r)<0);
        l = [1:1:7];
        err=zeros(1,4);
        for bit = 1:length(b)
            if(b(bit))
                err = mod(err+de2bi(bit,4),2)
            end
        end
        corrected_msg = b;
        if(sum(err~=zeros(1,4)))
            corrected_msg(bi2de(err)) = ~corrected_msg(bi2de(err));
        end
        dist = mod(repmat(b,16,1)+cwords,2)*ones(7,1);
        [mind,pos] = min(dist);
        msg_cap1 = cwords(pos,1:4);
        corr = (1-2*cwords)*r';
        [mind2,pos1] = max(corr);
        msg_cap2 = cwords(pos1,1:4);
        y = sum(msg ~= corrected_msg(1:4));
        if(y>0)
        N_bit_errors = N_bit_errors+y;
        end
        on = max(on,y);
    end
    N_errors(n) = N_bit_errors/on;
end
BER_th = 0.5*erfc(sqrt(10.^(Eb_N0_db/10)));
BER_sim = N_errors/7000;
figure
semilogy(Eb_N0_db,BER_sim,'ms-','LineWidth',2);
hold on
semilogy(Eb_N0_db,BER_th,'bd-','LineWidth',2);
axis([0 10 10^-5 0.5])
grid on
legend('Simulated', 'Theoretical');
xlabel('Eb/No, dB');
ylabel('Bit Error Rate');
title('BER for BPSK in AWGN with Hamming (7,4) code');
