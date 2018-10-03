addpath('utilities');

%% testing dataset
imageSet = 'Set5'; %% ['Set5', 'Set14', 'BSD100']
%%% JPEG Quality Factor
QF = 10;
%%% upscaling factor
upscaling = 1.01;

%%% degradation attributes
kGD = 0;
kSR = 0;
kDB = (100.0-QF)/100.0;

%%% to use DnCNN3 model, set to 1;
useDnCNN = 0;
%%% to use BM3D, set to 1;
useBM3D = 0;

%%-------------------------------------------------%%

%%% model name
if useDnCNN
  modelName = 'DnCNN3';
else
  modelName = 'trained_non_blind_restoration_net';
end

folderModel = '../model';
folderTest  = '../testsets';

load(fullfile(folderModel,[modelName, '.mat']));

if useBM3D
  addpath('../bm3d');
end

folderTestCur = fullfile(folderTest,imageSet);
ext                 =  {'*.jpg','*.png','*.bmp'};
filepaths           =  [];
for i = 1 : length(ext)
    filepaths = cat(1,filepaths,dir(fullfile(folderTestCur, ext{i})));
end

eval(['PSNR',' = zeros(length(filepaths),1);']);
eval(['SSIM',' = zeros(length(filepaths),1);']);

for i = 1 : length(filepaths)
    label  = imread(fullfile(folderTestCur,filepaths(i).name));
    %disp(fullfile(folderTestCur,filepaths(i).name))
    [~,imageName,ext] = fileparts(filepaths(i).name);
    channel = size(label,3);
    if channel == 3
        %%% label (uint8)
        label = rgb2gray(label);
    end

    randn('seed',0);
    imwrite(label,'tmp.jpg','jpg','quality', QF);
    compressed = im2single(imread('tmp.jpg'));  
    label = imresize(label, upscaling,'bicubic');
    degraded = imresize(compressed, upscaling,'bicubic');
    
    if useBM3D
      [NA, output] = BM3D(1, degraded, sigma);
    else
      if useDnCNN
        input = degraded;
      else
        input = cat(3, degraded, kGD * ones(size(label)), kSR * ones(size(label)), kDB * ones(size(label)));
      end
      res = vl_simplenn(net, input,[],[],'conserveMemory',true,'mode','test');
      im = res(end).x(:,:,1);
      %%% output image
      output = gather(degraded - im);
    end

    [PSNR_Cur,SSIM_Cur] = Cal_PSNRSSIM(label,im2uint8(output),0,0);
    disp(['Restoration     ',num2str(PSNR_Cur,'%2.2f'),'dB','    ',filepaths(i).name]);
    eval(['PSNR','(',num2str(i),') = PSNR_Cur;']);
    eval(['SSIM','(',num2str(i),') = SSIM_Cur;']);

    if 1
        imshow(cat(1,cat(2,im2uint8(degraded),im2uint8(output)),cat(2,im2uint8(abs(degraded-output)*10),label)));
        title(['Restoration     ',filepaths(i).name,'    ',num2str(PSNR_Cur,'%2.2f'),'dB'],'FontSize',12)
        drawnow;
        pause(1)
    end
    
end

disp(['Average PSNR is ',num2str(mean(eval(['PSNR'])),'%2.2f'),'dB']);
disp(['Average SSIM is ',num2str(mean(eval(['SSIM'])),'%2.4f')]);
