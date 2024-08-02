clc;
clear all;
close all;

modulation_order = 4; %choose 2 or 4

numBits = 10^5; %number of bits

bits = randi([0,1], 1, numBits); %

SNR_dB = -25:1:25;
SNR = 10.^(SNR_dB/10);

BER_bpsk = zeros(1,length(SNR));
BER_qpsk = zeros(1,length(SNR));

%BPSK modulation
for snrIndx = 1:length(SNR)
    total_error_bpsk = 0;
    for i=1:numBits
        
        %mapping
        if(bits(i) == 0)
            X_bpsk = 1;
        else
            X_bpsk = -1;
        end
        
        %gaussian nosie generation
        
        noise_bpsk = (1/sqrt(SNR(snrIndx)))*randn(1,1);
        
        %channel
        
        Y_bpsk = X_bpsk + noise_bpsk;
        
        %Demodulation
        
        if(Y_bpsk > 0)
            y_bpsk = 0;
        else
            y_bpsk = 1;
        end
        
        %error detection
        if(y_bpsk ~= bits(i))
            error_bpsk = 1;
        else
            error_bpsk = 0;
        end
        
        total_error_bpsk = total_error_bpsk + error_bpsk;
    end
    
    BER_bpsk(snrIndx) = total_error_bpsk/numBits;
end

%QPSK modulation
y_demodulated_qpsk = [];
errorTotal_qpsk = 0;

bitPairs = reshape(bits, 2, []);

symbols_qpsk = (1 - 2*bitPairs(1,:))+ 1i*(1 - 2*bitPairs(2,:));
symb_norm_qpsk = (1/sqrt(2)).*symbols_qpsk;

for snrIndex = 1:length(SNR)
    errorTotal_qpsk = 0;

    received_bits_qpsk = [];

    %noise generation
    noise_qpsk = (1/sqrt(SNR(snrIndex)))*(randn(1,length(symbols_qpsk))+1i*(randn(1,1*length(symbols_qpsk))));

    %adding noise to the symbols
    Y_qpsk = symb_norm_qpsk + noise_qpsk;


    %demodulation

    %initialising symbol points
    s0 = (1/sqrt(2))*(1 + 1i);
    s1 = (1/sqrt(2))*(1 - 1i);
    s2 = (1/sqrt(2))*(-1 + 1i);
    s3 = (1/sqrt(2))*(-1 - 1i);
    
    y_demodulated_qpsk = [];

    for i = 1:length(Y_qpsk)
        d0 = abs(s0 - Y_qpsk(i));
        d1 = abs(s1 - Y_qpsk(i));
        d2 = abs(s2 - Y_qpsk(i));
        d3 = abs(s3 - Y_qpsk(i));

        d = [d0,d1,d2,d3];

        if(min(d) == d0)
            y = 1 + 1i;
        elseif(min(d) == d1)
            y = 1 - 1i;
        elseif(min(d) == d2)
            y = -1 + 1i;
        else
            y = -1 - 1i;
        end

        y_demodulated_qpsk = [y_demodulated_qpsk y];

    end

    y_decoded_qpsk = [];
    for i = 1:length(y_demodulated_qpsk)
        y_decoded_qpsk(1,i) = real(y_demodulated_qpsk(i));
        y_decoded_qpsk(2,i) = imag(y_demodulated_qpsk(i));
    end

    received_bits_qpsk = reshape(y_decoded_qpsk , 1, numBits);

    for i= 1:length(received_bits_qpsk)
        if(received_bits_qpsk(i) == 1)
            received_bits_qpsk(i) = 0;
        else
            received_bits_qpsk(i) = 1;
        end
    end

    for i=1:length(received_bits_qpsk)
        if(bits(i) ~= received_bits_qpsk(i))
            error = 1;
        else
            error = 0;
        end

        errorTotal_qpsk = errorTotal_qpsk + error;
    end
    
%     errorTotal = sum(bits~=received_bits);
    
    BER_qpsk(snrIndex) = errorTotal_qpsk/numBits;
end

semilogy(SNR_dB, BER_bpsk, '-*');
hold on;
semilogy(SNR_dB,BER_qpsk, '-*');
legend('BPSK','QPSK');
grid on;
xlabel('SNR');
ylabel('BER');
title('BER vs SNR')
hold off;

        
        
        
        
        
        
        
        
        

        