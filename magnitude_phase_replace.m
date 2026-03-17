%% ========================================================================
%  MAGNITUDE vs PHASE REPLACEMENT IN THE FOURIER DOMAIN
%  ========================================================================
%  PURPOSE:
%    This script demonstrates that the PHASE component of the Fourier
%    transform carries MORE perceptual/structural information about an
%    image than the MAGNITUDE component.
%
%  HOW IT WORKS:
%    1. Load two different grayscale images (Image A and Image B).
%    2. Compute the 2D FFT of each image.
%    3. Separate each FFT into its magnitude |X(f)| and phase angle(X(f)).
%    4. Create hybrid images by swapping magnitude and phase between
%       the two images.
%    5. Display all results side-by-side so you can visually compare.
%
%  KEY CONCLUSION:
%    - When we keep Image A's PHASE but replace its magnitude with
%      Image B's magnitude, the result STILL looks like Image A.
%    - When we keep Image A's MAGNITUDE but replace its phase with
%      Image B's phase, the result looks like Image B.
%    => Therefore, PHASE dominates the perceptual content of an image.
%
%  HOW TO TEST:
%    1. Make sure 'cameraman.tif' and 'circuit.tif' are available.
%       These ship with MATLAB's Image Processing Toolbox. If you don't
%       have them, replace with any two grayscale images of the same size.
%    2. Simply press F5 (Run) in MATLAB.
%    3. Look at Figure 1 (original images), Figure 2 (magnitude spectra),
%       Figure 3 (phase spectra), and Figure 4 (the key reconstruction
%       results). The titles on Figure 4 tell you exactly what was
%       combined. You should clearly see that the image whose PHASE was
%       used dominates the visual appearance.
%    4. Try swapping in your own images to confirm the result holds
%       generally — it always does!
%  ========================================================================

clc;            % Clear the command window
clear all;      % Remove all variables from the workspace
close all;      % Close all open figure windows

%% ========================================================================
%  STEP 1: LOAD AND PREPARE THE TWO IMAGES
%  ========================================================================

% --- Load Image A (cameraman) ---
% imread reads the image file into a matrix of pixel values.
imageA = imread('cameraman.tif');

% --- Load Image B (circuit) ---
imageB = imread('circuit.tif');

% --- Convert to double precision ---
% FFT requires double-precision floating point numbers, not uint8.
% uint8 ranges from 0-255; double gives us full numerical precision.
imageA = double(imageA);
imageB = double(imageB);

% --- Make sure both images are the SAME size ---
% The FFT outputs must have matching dimensions for us to swap components.
% cameraman.tif is 256x256, circuit.tif may be larger, so we crop.
[rowsA, colsA] = size(imageA);
imageB = imageB(1:rowsA, 1:colsA);  % Crop Image B to match Image A

% --- Display info about the images ---
fprintf('=== Image Information ===\n');
fprintf('Image A (cameraman): %d x %d pixels\n', rowsA, colsA);
[rowsB, colsB] = size(imageB);
fprintf('Image B (circuit):   %d x %d pixels (after cropping)\n', rowsB, colsB);
fprintf('\n');

%% ========================================================================
%  STEP 2: COMPUTE THE 2D FOURIER TRANSFORM OF EACH IMAGE
%  ========================================================================
%  The 2D FFT decomposes an image into a sum of 2D sinusoidal patterns.
%  Each frequency component has:
%    - A MAGNITUDE: how strong that frequency is (contrast/energy)
%    - A PHASE:     where that frequency pattern is positioned (structure)
%
%  Mathematically:  X(u,v) = |X(u,v)| * exp(j * angle(X(u,v)))
%                             --------         ----------------
%                             magnitude              phase

% --- Compute 2D FFT ---
fftA = fft2(imageA);   % FFT of Image A: complex matrix of same size
fftB = fft2(imageB);   % FFT of Image B: complex matrix of same size

%% ========================================================================
%  STEP 3: EXTRACT MAGNITUDE AND PHASE FROM EACH FFT
%  ========================================================================

% --- Magnitude: |X(u,v)| = sqrt(real^2 + imag^2) ---
% This tells us the AMPLITUDE (strength) of each frequency component.
magA = abs(fftA);      % Magnitude of Image A's spectrum
magB = abs(fftB);      % Magnitude of Image B's spectrum

% --- Phase: angle(X(u,v)) = atan2(imag, real) ---
% This tells us the POSITION/ALIGNMENT of each frequency component.
% Phase encodes edges, textures, and spatial structure.
phaseA = angle(fftA);  % Phase of Image A's spectrum (radians)
phaseB = angle(fftB);  % Phase of Image B's spectrum (radians)

% --- Print magnitude and phase statistics ---
fprintf('=== Magnitude Statistics ===\n');
fprintf('Image A magnitude: min=%.2f, max=%.2f, mean=%.2f\n', ...
    min(magA(:)), max(magA(:)), mean(magA(:)));
fprintf('Image B magnitude: min=%.2f, max=%.2f, mean=%.2f\n', ...
    min(magB(:)), max(magB(:)), mean(magB(:)));
fprintf('\n');
fprintf('=== Phase Statistics ===\n');
fprintf('Image A phase: min=%.4f rad, max=%.4f rad\n', ...
    min(phaseA(:)), max(phaseA(:)));
fprintf('Image B phase: min=%.4f rad, max=%.4f rad\n', ...
    min(phaseB(:)), max(phaseB(:)));
fprintf('\n');

%% ========================================================================
%  STEP 4: RECONSTRUCT IMAGES WITH SWAPPED MAGNITUDE AND PHASE
%  ========================================================================
%  We build 4 hybrid spectra and inverse-FFT each one back to an image.
%
%  RECALL: a complex spectrum can be reconstructed from mag and phase as:
%     X(u,v) = magnitude .* exp(j * phase)
%
%  The 4 combinations are:
%    1. magA + phaseA  -->  Original Image A (sanity check)
%    2. magB + phaseB  -->  Original Image B (sanity check)
%    3. magB + phaseA  -->  WHO WINS? magnitude(B) or phase(A)?
%    4. magA + phaseB  -->  WHO WINS? magnitude(A) or phase(B)?

% --- Combination 1: Magnitude A + Phase A (should recover Image A) ---
% This is a sanity check: recombining the SAME mag and phase should
% give back the original image.
spectrum_magA_phaseA = magA .* exp(1i * phaseA);
recon_magA_phaseA    = real(ifft2(spectrum_magA_phaseA));
%   ^ real() removes tiny imaginary rounding errors from ifft2

% --- Combination 2: Magnitude B + Phase B (should recover Image B) ---
% Another sanity check.
spectrum_magB_phaseB = magB .* exp(1i * phaseB);
recon_magB_phaseB    = real(ifft2(spectrum_magB_phaseB));

% --- Combination 3: Magnitude B + Phase A  (THE KEY EXPERIMENT) ---
% We throw away Image A's magnitude and replace it with Image B's.
% If magnitude dominates perception, this should look like Image B.
% If phase dominates perception, this should look like Image A.
spectrum_magB_phaseA = magB .* exp(1i * phaseA);
recon_magB_phaseA    = real(ifft2(spectrum_magB_phaseA));

% --- Combination 4: Magnitude A + Phase B  (THE OTHER KEY EXPERIMENT) ---
% We throw away Image B's magnitude and replace it with Image A's.
% If magnitude dominates perception, this should look like Image A.
% If phase dominates perception, this should look like Image B.
spectrum_magA_phaseB = magA .* exp(1i * phaseB);
recon_magA_phaseB    = real(ifft2(spectrum_magA_phaseB));

%% ========================================================================
%  STEP 5: DISPLAY THE ORIGINAL IMAGES
%  ========================================================================

figure(1);
sgtitle('Step 1: Original Images', 'FontSize', 14, 'FontWeight', 'bold');

subplot(1, 2, 1);
imagesc(imageA);            % Display Image A
colormap gray;              % Use grayscale colormap
axis image;                 % Maintain aspect ratio
title('Image A: Cameraman', 'FontSize', 12);
colorbar;

subplot(1, 2, 2);
imagesc(imageB);            % Display Image B
colormap gray;
axis image;
title('Image B: Circuit', 'FontSize', 12);
colorbar;

%% ========================================================================
%  STEP 6: DISPLAY THE MAGNITUDE SPECTRA (log scale for visibility)
%  ========================================================================
%  We use log(1 + |X|) because the DC component (center) is huge
%  compared to high-frequency components. Without log, you'd see
%  just a bright dot and nothing else.

figure(2);
sgtitle('Step 2: Magnitude Spectra (log scale)', 'FontSize', 14, 'FontWeight', 'bold');

subplot(1, 2, 1);
imagesc(log(1 + fftshift(magA)));   % fftshift centers the DC component
colormap gray;
axis image;
title('|FFT(Image A)|', 'FontSize', 12);
colorbar;

subplot(1, 2, 2);
imagesc(log(1 + fftshift(magB)));
colormap gray;
axis image;
title('|FFT(Image B)|', 'FontSize', 12);
colorbar;

%% ========================================================================
%  STEP 7: DISPLAY THE PHASE SPECTRA
%  ========================================================================
%  Phase images look like noise to the human eye, but they contain
%  all the structural information (edges, shapes, positions).

figure(3);
sgtitle('Step 3: Phase Spectra', 'FontSize', 14, 'FontWeight', 'bold');

subplot(1, 2, 1);
imagesc(fftshift(phaseA));          % Phase values in radians [-pi, pi]
colormap gray;
axis image;
title('Phase of FFT(Image A)', 'FontSize', 12);
colorbar;

subplot(1, 2, 2);
imagesc(fftshift(phaseB));
colormap gray;
axis image;
title('Phase of FFT(Image B)', 'FontSize', 12);
colorbar;

%% ========================================================================
%  STEP 8: DISPLAY THE KEY RESULTS — THIS IS THE MAIN CONCLUSION
%  ========================================================================
%  This figure answers the question: "Which matters more, magnitude or
%  phase?" Look at the bottom row carefully!

figure(4);
sgtitle({'Step 4: THE KEY RESULT — Which Dominates, Magnitude or Phase?', ...
         '(Look at the bottom row!)'}, ...
         'FontSize', 14, 'FontWeight', 'bold');

% --- Top left: sanity check — original Image A reconstructed ---
subplot(2, 2, 1);
imagesc(recon_magA_phaseA);
colormap gray;
axis image;
title({'Sanity Check:', 'Mag(A) + Phase(A) = Image A'}, 'FontSize', 11);

% --- Top right: sanity check — original Image B reconstructed ---
subplot(2, 2, 2);
imagesc(recon_magB_phaseB);
colormap gray;
axis image;
title({'Sanity Check:', 'Mag(B) + Phase(B) = Image B'}, 'FontSize', 11);

% --- Bottom left: THE EXPERIMENT — Magnitude from B, Phase from A ---
subplot(2, 2, 3);
imagesc(recon_magB_phaseA);
colormap gray;
axis image;
title({'Mag(B) + Phase(A)', ...
       'Looks like A! => PHASE WINS'}, ...
       'FontSize', 11, 'Color', 'r');

% --- Bottom right: THE EXPERIMENT — Magnitude from A, Phase from B ---
subplot(2, 2, 4);
imagesc(recon_magA_phaseB);
colormap gray;
axis image;
title({'Mag(A) + Phase(B)', ...
       'Looks like B! => PHASE WINS'}, ...
       'FontSize', 11, 'Color', 'r');

%% ========================================================================
%  STEP 9: QUANTITATIVE COMPARISON (OPTIONAL BUT USEFUL)
%  ========================================================================
%  We compute correlation coefficients to numerically confirm what
%  we see visually. Higher correlation = more similar.

% Normalize images to [0, 1] for fair comparison
normA = imageA / max(imageA(:));
normB = imageB / max(imageB(:));
norm_magB_phaseA = recon_magB_phaseA / max(recon_magB_phaseA(:));
norm_magA_phaseB = recon_magA_phaseB / max(recon_magA_phaseB(:));

% Correlation of "MagB + PhaseA" with original A and original B
corrWithA_case1 = corr2(norm_magB_phaseA, normA);
corrWithB_case1 = corr2(norm_magB_phaseA, normB);

% Correlation of "MagA + PhaseB" with original A and original B
corrWithA_case2 = corr2(norm_magA_phaseB, normA);
corrWithB_case2 = corr2(norm_magA_phaseB, normB);

fprintf('=== QUANTITATIVE RESULTS ===\n');
fprintf('-------------------------------------------------------\n');
fprintf('Reconstruction: Mag(B) + Phase(A)\n');
fprintf('  Correlation with Image A (phase source): %.4f\n', corrWithA_case1);
fprintf('  Correlation with Image B (mag source):   %.4f\n', corrWithB_case1);
fprintf('  => More similar to Image A? %s\n', ...
    iif(corrWithA_case1 > corrWithB_case1, 'YES — Phase wins!', 'NO'));
fprintf('-------------------------------------------------------\n');
fprintf('Reconstruction: Mag(A) + Phase(B)\n');
fprintf('  Correlation with Image A (mag source):   %.4f\n', corrWithA_case2);
fprintf('  Correlation with Image B (phase source): %.4f\n', corrWithB_case2);
fprintf('  => More similar to Image B? %s\n', ...
    iif(corrWithB_case2 > corrWithA_case2, 'YES — Phase wins!', 'NO'));
fprintf('-------------------------------------------------------\n');
fprintf('\n');
fprintf('=== CONCLUSION ===\n');
fprintf('In BOTH cases, the reconstructed image resembles the image\n');
fprintf('whose PHASE was used, NOT the image whose MAGNITUDE was used.\n');
fprintf('Therefore: PHASE carries more perceptual information than MAGNITUDE.\n');
fprintf('This is because phase encodes the spatial structure (edges, shapes,\n');
fprintf('positions) while magnitude only encodes energy/contrast.\n');

%% ========================================================================
%  HELPER FUNCTION
%  ========================================================================
%  Simple inline if-else (MATLAB does not have a ternary operator)
function result = iif(condition, trueVal, falseVal)
    if condition
        result = trueVal;
    else
        result = falseVal;
    end
end
