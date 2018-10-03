addpath('utilities');

%% testing image
image = 'BSD100/33039.jpg';

%%% gaussian noise Level
sigma = 30;

%%-------------------------------------------------%%

%%% model name
modelName = 'trained_non_blind_restoration_net';

folderModel = '../model';
folderTest  = '../testsets';

load(fullfile(folderModel,[modelName, '.mat']));

filename = fullfile(folderTest,image);

label  = imread(filename);
channel = size(label,3);
if channel == 3
    label = rgb2gray(label);
end

degraded = single(im2double(label) + sigma/255*randn(size(label)));

s = size(label);
gradation = repmat(0:1/(s(2)-1):1, s(1),1);

input = cat(3, degraded, gradation, zeros(size(label)), zeros(size(label)));
res = vl_simplenn(net, input,[],[],'conserveMemory',true,'mode','test');
im = res(end).x(:,:,1);
output = gather(degraded - im);

imshow(cat(1,cat(2,im2uint8(degraded),im2uint8(output)),cat(2,im2uint8(abs(degraded-output)*10),im2uint8(gradation))));
drawnow;
pause(1)

    

