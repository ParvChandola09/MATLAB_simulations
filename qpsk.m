clc;
clear all;
close all;

numberBits = 10^5;
snrDB = -20:20;
snr = 10.^(snrDB/10);

y_demodulated = [];
errorTotal = 0;

BER = zeros(1,length(snr));

bits = randi([0,1], 1, numberBits);

bitPairs = reshape(bits, 2, []);

symbols = (1 - 2*bitPairs(1,:))+ 1i*(1 - 2*bitPairs(2,:));
symb_norm = (1/sqrt(2)).*symbols;

for snrIndex = 1:length(snr)
    errorTotal = 0;

    received_bits = [];

    %noise generation
    noise = (1/sqrt(snr(snrIndex)))*(randn(1,length(symbols))+1i*(randn(1,1*length(symbols))));

    %adding noise to the symbols
    Y = symb_norm + noise;
    % 
    % %demodulation
    % for i=1:length(Y)
    %     if(real(Y(i))>0 && imag(Y(i))>0)
    %         y = 1 + 1i;
    %     elseif(real(Y(i))<=0 && imag(Y(i))>0)
    %         y = -1 + 1i;
    %     elseif(real(Y(i))<=0 && imag(Y(i))<=0)
    %         y = -1 - 1i;
    %     else
    %         y = 1 - 1i;
    %     end
    %     y_demodulated = [y_demodulated y];
    % end


    %demodulation

    %initialising symbol points
    s0 = (1/sqrt(2))*(1 + 1i);
    s1 = (1/sqrt(2))*(1 - 1i);
    s2 = (1/sqrt(2))*(-1 + 1i);
    s3 = (1/sqrt(2))*(-1 - 1i);
    
    y_demodulated = [];

    for i = 1:length(Y)
        d0 = abs(s0 - Y(i));
        d1 = abs(s1 - Y(i));
        d2 = abs(s2 - Y(i));
        d3 = abs(s3 - Y(i));

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

        y_demodulated = [y_demodulated y];

    end

    y_decoded = [];
    for i = 1:length(y_demodulated)
        y_decoded(1,i) = real(y_demodulated(i));
        y_decoded(2,i) = imag(y_demodulated(i));
    end

    received_bits = reshape(y_decoded , 1, numberBits);

    for i= 1:length(received_bits)
        if(received_bits(i) == 1)
            received_bits(i) = 0;
        else
            received_bits(i) = 1;
        end
    end

    for i=1:length(received_bits)
        if(bits(i) ~= received_bits(i))
            error = 1;
        else
            error = 0;
        end

        errorTotal = errorTotal + error;
    end
    
%     errorTotal = sum(bits~=received_bits);
    
    BER(snrIndex) = errorTotal/numberBits;
end

semilogy(snrDB, BER, '-*');
xlabel('SNR')
grid on;
    




