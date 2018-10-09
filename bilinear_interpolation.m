clear all;
addpath('functions');

% Get image
RGB = imread('img/games/bf1.png');

% Convert 16-bit RGB to 8-bit
if isa(RGB,'uint16')
    fprintf('Converting uint16 to uint8\n');
    RGB = uint8(RGB/256);
end

% Create YCbCr 4:2:2 image
YCbCr_422 = rgb2ycbcr422(RGB);

% Scale down
scale_factor = 0.25;
pre_scale_rgb = imresize(RGB, (1/scale_factor), 'bicubic');
pre_scale_ycbcr = imresize(YCbCr_422, (1/scale_factor), 'bicubic');

% Bilinear upscaling RGB
matlab_bilinear_rgb = imresize(pre_scale_rgb, scale_factor, 'bilinear');
self_bilinear_rgb = bilinear(pre_scale_rgb, scale_factor);
self_bilinear2_rgb = bilinear2(pre_scale_rgb, scale_factor);


% Bilinear upscaling YCbCr
matlab_bilinear_ycbcr = imresize(pre_scale_ycbcr, scale_factor, 'bilinear');
self_bilinear_ycbcr = bilinear(pre_scale_ycbcr, scale_factor);
self_bilinear2_ycbcr = bilinear2(pre_scale_ycbcr, scale_factor);


% Calculate Peak Sgnal-to-Noise Ratio
[PSNR_matlab_rgb, SNR_matlab_rgb] = psnr(matlab_bilinear_rgb, RGB);
[PSNR_matlab_ycbcr, SNR_matlab_ycbcr] = psnr(matlab_bilinear_ycbcr, YCbCr_422);
[PSNR_self_rgb, SNR_self_rgb] = psnr(self_bilinear_rgb, RGB);
[PSNR_self_ycbcr, SNR_self_ycbcr] = psnr(self_bilinear_ycbcr, YCbCr_422);
[PSNR_self2_rgb, SNR_self2_rgb] = psnr(self_bilinear2_rgb, RGB);
[PSNR_self2_ycbcr, SNR_self2_ycbcr] = psnr(self_bilinear2_ycbcr, YCbCr_422);
fprintf("-----------------------------------------\n");
fprintf("PSNR Matlab RGB: %0.4f\nPSNR Bilinear RGB: %0.4f\nPSNR Bilinear2 RGB: %0.4f\n", PSNR_matlab_rgb, PSNR_self_rgb, PSNR_self2_rgb);
fprintf("PSNR Matlab YCbCr: %0.4f\nPSNR Bilinear YCbCr: %0.4f\nPSNR Bilinear2 YCbCr: %0.4f\n", PSNR_matlab_ycbcr, PSNR_self_ycbcr, PSNR_self2_ycbcr);

% Calculate Mean-Squared Error
MSE_matlab_rgb = immse(matlab_bilinear_rgb, RGB);
MSE_matlab_ycbcr = immse(matlab_bilinear_ycbcr, YCbCr_422);
MSE_self_rgb = immse(self_bilinear_rgb, RGB);
MSE_self_ycbcr = immse(self_bilinear_ycbcr, YCbCr_422);
MSE_self2_rgb = immse(self_bilinear2_rgb, RGB);
MSE_self2_ycbcr = immse(self_bilinear2_ycbcr, YCbCr_422);
fprintf("-----------------------------------------\n");
fprintf("MSE Matlab RGB: %0.4f\nMSE Bilinear RGB: %0.4f\nMSE Bilinear2 RGB: %0.4f\n", MSE_matlab_rgb, MSE_self_rgb, MSE_self2_rgb);
fprintf("MSE Matlab YCbCr: %0.4f\nMSE Bilinear YCbCr: %0.4f\nMSE Bilinear2 YCbCr: %0.4f\n", MSE_matlab_ycbcr, MSE_self_ycbcr, MSE_self2_ycbcr);

% Calculate Structural Similarity SSIM
[mssim_matlab_rgb, ssim_map_matlab_rgb] = ssim(matlab_bilinear_rgb, RGB);
[mssim_matlab_ycbcr, ssim_map_matlab_ycbcr] = ssim(matlab_bilinear_ycbcr, YCbCr_422);
[mssim_self_rgb, ssim_map_self_rgb] = ssim(self_bilinear_rgb, RGB);
[mssim_self_ycbcr, ssim_map_self_ycbcr] = ssim(self_bilinear_ycbcr, YCbCr_422);
[mssim_self2_rgb, ssim_map_self2_rgb] = ssim(self_bilinear2_rgb, RGB);
[mssim_self2_ycbcr, ssim_map_self2_ycbcr] = ssim(self_bilinear2_ycbcr, YCbCr_422);
fprintf("-----------------------------------------\n");
fprintf("SSIM Matlab RGB: %0.4f\nSSIM Bilinear RGB: %0.4f\nSSIM Bilinear2 RGB: %0.4f\n", mssim_matlab_rgb, mssim_self_rgb, mssim_self2_rgb);
fprintf("SSIM Matlab YCbCr: %0.4f\nSSIM Bilinear YCbCr: %0.4f\nSSIM Bilinear2 YCbCr: %0.4f\n", mssim_matlab_ycbcr, mssim_self_ycbcr, mssim_self2_ycbcr);

% Plot figures
figure();

subplot(4,3,1);imshow(matlab_bilinear_rgb);title(sprintf('Matlab bilinear RGB\nPSNR = %0.4f\nMSE = %0.4f',PSNR_matlab_rgb, MSE_matlab_rgb));
subplot(4,3,2);imshow(self_bilinear_rgb);title(sprintf('Self bilinear RGB\nPSNR = %0.4f\nMSE = %0.4f',PSNR_self_rgb, MSE_self_rgb));
subplot(4,3,3);imshow(self_bilinear2_rgb);title(sprintf('Self bilinear2 RGB\nPSNR = %0.4f\nMSE = %0.4f',PSNR_self2_rgb, MSE_self2_rgb));

subplot(4,3,4);imshow(ssim_map_matlab_rgb,[]);title(sprintf('SSIM map Matlab bilinear RGB\nMean SSIM = %0.4f',mssim_matlab_rgb));
subplot(4,3,5);imshow(ssim_map_self_rgb,[]);title(sprintf('SSIM map Self bilinear RGB\nMean SSIM = %0.4f',mssim_self_rgb));
subplot(4,3,6);imshow(ssim_map_self2_rgb,[]);title(sprintf('SSIM map Self bilinear2 RGB\nMean SSIM = %0.4f',mssim_self2_rgb));

subplot(4,3,7);imshow(ycbcr2rgb(matlab_bilinear_ycbcr));title(sprintf('Matlab bilinear YCbCr 4:2:2\nPSNR = %0.4f\nMSE = %0.4f',PSNR_matlab_ycbcr, MSE_matlab_ycbcr));
subplot(4,3,8);imshow(ycbcr2rgb(self_bilinear_ycbcr));title(sprintf('Self bilinear YCbCr 4:2:2\nPSNR = %0.4f\nMSE = %0.4f',PSNR_self_ycbcr, MSE_self_ycbcr));
subplot(4,3,9);imshow(ycbcr2rgb(self_bilinear2_ycbcr));title(sprintf('Self bilinear2 YCbCr 4:2:2\nPSNR = %0.4f\nMSE = %0.4f',PSNR_self2_ycbcr, MSE_self2_ycbcr));

subplot(4,3,10);imshow(ssim_map_matlab_ycbcr,[]);title(sprintf('SSIM map Matlab bilinear YCbCr\nMean SSIM = %0.4f',mssim_matlab_ycbcr));
subplot(4,3,11);imshow(ssim_map_self_ycbcr,[]);title(sprintf('SSIM map Self bilinear YCbCr\nMean SSIM = %0.4f',mssim_self_ycbcr));
subplot(4,3,12);imshow(ssim_map_self2_ycbcr,[]);title(sprintf('SSIM map Self bilinear2 YCbCr\nMean SSIM = %0.4f',mssim_self2_ycbcr));


