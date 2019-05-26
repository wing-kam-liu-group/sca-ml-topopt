%     This program is for Training the FFNN 
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
% 
%     Last Modifyed: May 1, 2019

%% Load training data
load(fullfile('..','Database','SCA_NN_database.mat'));
net = fitnet(25);
net = train(net,input.epsilon_sup_M',input.sigma_sup_M');

%% save trained network 
save SCA_NN_net net
