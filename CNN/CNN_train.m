%     This program is for training the CNN network for predicting macroscopic strain state 
%     given a mesh and microscopic stress contour
%     Copyright (C) May 1 2019,  Jiaying Gao, Northwestern University
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <https://www.gnu.org/licenses/>.

function main
global CNN_hist
%%load inputs
load('CNN_train_in_git.mat');
load('CNN_validation_in_git.mat');
sample_size=size(sig_local_train,4);
rand_seq=randperm(sample_size);
XTrain=sig_local_train(:,:,:,rand_seq);
YTrain=eps_macro_train(rand_seq,:);

sample_size=size(sig_local_validation,4);
rand_seq=randperm(sample_size);
XValidation=sig_local_validation(:,:,:,rand_seq);
YValidation=eps_macro_validation(rand_seq,:);

CNN_hist={['Iteration','TrainingLoss', 'TrainingRMSE',...
                     'ValidationLoss','ValidationRMSE',...
                     'State']};

%% define CNN layers

layers = [
    imageInputLayer([600 600 3],'Normalization','none') % input is a 600 by 600 image

    convolution2dLayer(6,8,'Padding','same') 
    reluLayer
    averagePooling2dLayer(3,'Stride',2)

    convolution2dLayer(6,16,'Padding','same') 
    reluLayer
    averagePooling2dLayer(3,'Stride',2) 
  
    convolution2dLayer(6,32,'Padding','same') 
    reluLayer
    averagePooling2dLayer(3,'Stride',2)
        
    convolution2dLayer(6,64,'Padding','same') 
    reluLayer
    
    dropoutLayer(0.05)
    fullyConnectedLayer(3)
    regressionLayer];

layer{2}.Weights = randn([6 6 3 8]) * 0.1+0.3;
layer{5}.Weights = randn([6 6 3 16]) * 0.1+0.1;
layer{8}.Weights = randn([6 6 3 32]) * 0.1+0.3;
layer{11}.Weights = randn([6 6 3 64]) * 0.1+0.2;
%% define batch size
miniBatchSize  = 8;
validationFrequency = 100;
%% define training options
options = trainingOptions('sgdm', ...
    'ExecutionEnvironment','auto',...
    'MiniBatchSize',miniBatchSize, ...
    'MaxEpochs',60, ...
    'InitialLearnRate',2e-2, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropFactor',0.2, ...
    'LearnRateDropPeriod',10, ...
    'Shuffle','every-epoch', ...
    'ValidationData',{XValidation,YValidation}, ...
    'ValidationFrequency',validationFrequency, ...
    'Plots','training-progress', ...
    'Verbose',false,...
     'OutputFcn',@(info)outputfunc(info,10));

%% Train
net = trainNetwork(XTrain,YTrain,layers,options);

save CNN_results net sig_local_validation eps_macro_validation CNN_hist

end