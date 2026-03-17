
% This function takes FFT of input image, gets the magnitude and phase 
% of the spectrum and replaces the magnitude with that of anaother image 

% function [x1_out,x2_out,x3_out] = magnitude_phase_replace(x1_in,x2_in)

 x1_in = imread('cameraman.tif'); % load image 1 and 2 with same dimensions   
 x2_in = imread('circuit.tif');
 x1_in = double(x1_in); % convert the data to double precision 
 x2_in = double(x2_in); 
 x2_in = x2_in(1:256,1:256); % based on the dimension of x1_in
 
 
% x1 = imread('peppers.png'); 
% x2 = imread('cameraman.tif'); %  peppers.png 
% x1 = rgb2gray(x1); 
% x1 = double(x1);
% x2 = double(x2);
% [n,m] = size(x2);
% x2_in = rand(n,m); 
% [x1_out,x2_out,x3_out] = magnitude_phase_replace(x2,x2_in); 

 % Get fourier transform first
 x1_fft = fft2(x1_in); % X() = A1 +jB1 
 x2_fft = fft2(x2_in); % X() = A2 +jB2 
 
 % Gets magnitude and phase of FFT output
 x1_mag = abs(x1_fft); % |X()|
 x2_mag = abs(x2_fft); 
 x1_max = max(max(x1_mag)); % max(|X()
 x2_max = max(max(x2_mag)); 
 x1_phase = angle(x1_fft); % angle{X()}
 x2_phase = angle(x2_fft); 
  
 % Generates the modified spectrum
 x1same_mag = x1_mag.*exp(1i*x1_phase);
 x1new_mag = x2_mag.*exp(1i*x1_phase);
 x1new_pha = x1_mag.*exp(1i*x2_phase);
 
 x1_out = ifft2(x1same_mag);
 x2_out = ifft2(x1new_mag); 
 x3_out = ifft2(x1new_pha);
 
 x1_out = abs(x1_out);
 x2_out = abs(x2_out); 
 x3_out = abs(x3_out);
 
%  figure(2);
%  imagesc(abs(ima_out));
%  axis image;
%  title('Random magnitude version');

% end

 
