clear all;
close all;
clc;

BER = [];
N = 5*
10^5;    %number of iterations
SNR_dB = 1:10;  %SNR in dB

for SNR = SNR_dB
    
    noise_var = 10^(SNR/10);
    
    error_total = 0;
    
    for i=1:N
        
        %random bit generation
        m = randi([0,1]);
        
        %mapping to BPSK symbols
        if(m == 0)
            M = 1;
        else
            M = -1;
        end
        
        %geberation of gaussian noise
        gnNoise = (1/sqrt(noise_var))*randn(1,1);
        
        %addition of gaussian noise
        Y = M + gnNoise;
        
        %demodulation
        if(Y > 0)
            y = 0;
        else
            y = 1;
        end
        
        %checking bit error
        if(y ~= m)
            error = 1;
        else
            error = 0;
        end
        
        error_total = error_total + error;
        
    end
    
    BER = [BER error_total/N];
end

%plotting
semilogy(SNR_dB, BER,'-*');
grid on;
xlabel('Eb/N0');
ylabel('BER');
            
            
            
            
        

