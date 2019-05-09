%     This program is for training the CNN network for predicting macroscopic stress state 
%     given a mesh and macroscopic strain state
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
load('CNN_inputs.mat');
sigma_sup_SCA_M=XTrain;
eps_sup_SCA_M=YTrain;
sample_size=size(eps_sup_SCA_M,1);
rand_seq=randperm(sample_size);
validation_sample=rand_seq(1:150);
train_sample=rand_seq(151:end);
sigma_sup_SCA_M_validation=sigma_sup_SCA_M(:,:,:,validation_sample);
eps_sup_SCA_M_validation=eps_sup_SCA_M(validation_sample,:);
sigma_sup_SCA_M_train=sigma_sup_SCA_M(:,:,:,train_sample);
eps_sup_SCA_M_train=eps_sup_SCA_M(train_sample,:);
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
    
    dropoutLayer(0.15)
    fullyConnectedLayer(3)
    regressionLayer];

%% define batch size
miniBatchSize  = 8;
validationFrequency = 100;
%% define training options
options = trainingOptions('sgdm', ...
    'ExecutionEnvironment','auto',...
    'MiniBatchSize',miniBatchSize, ...
    'MaxEpochs',20, ...
    'InitialLearnRate',1e-2, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropFactor',0.01, ...
    'LearnRateDropPeriod',30, ...
    'Shuffle','every-epoch', ...
    'ValidationData',{sigma_sup_SCA_M_validation,eps_sup_SCA_M_validation}, ...
    'ValidationFrequency',validationFrequency, ...
    'ValidationPatience',Inf,...
    'Plots','training-progress', ...
    'Verbose',false,...
     'OutputFcn',@(info)outputfunc(info,30));

%% Train it
net = trainNetwork(sigma_sup_SCA_M_train,eps_sup_SCA_M_train,layers,options);

eps_sup_CNN_M=predict(net,sigma_sup_SCA_M_validation,'ExecutionEnvironment','auto');

save CNN_results net sigma_sup_SCA_M_validation eps_sup_SCA_M_validation eps_sup_CNN_M CNN_hist

end