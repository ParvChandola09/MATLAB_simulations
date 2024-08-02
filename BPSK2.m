clc;
clear all;
close all;

SNR_dB = 1:10;
SNR = 10.^(SNR_dB/10);
BER = [];

N = 10^5;

%bit generation
x = randi([0,1],1,N);

for snrIndx = 1:length(SNR)
    total_error = 0;
    for i=1:N
        
        %mapping
        if(x(i) == 0)
            X = 1;
        else
            X = -1;
        end
        
        %gaussian nosie generation
        
        noise = (1/sqrt(SNR(snrIndx)))*randn(1,1);
        
        %channel
        
        Y = X + noise;
        
        %Demodulation
        
        if(Y > 0)
            y = 0;
        else
            y = 1;
        end
        
        %error detection
        if(y ~= x(i))
            error = 1;
        else
            error = 0;
        end
        
        total_error = total_error + error;
    end
    
    BER = [BER total_error/N];
end

%plotting
semilogy(SNR_dB,BER, '-*');
grid on;
    
            
            
        