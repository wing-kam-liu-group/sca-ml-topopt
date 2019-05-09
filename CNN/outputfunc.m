%     This program checks CNN training accuracy and stops the training
%     process if the result stops improving
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
function stop = outputfunc(info,N)
global CNN_hist
stop = false;

% Keep track of the best validation accuracy and the number of validations for which
% there has not been an improvement of the accuracy.
persistent bestRMSE
persistent valLag


% Clear the variables when training starts.
if info.State == "start"
    bestRMSE = 0;
    valLag = 0;

    
elseif ~isempty(info.ValidationRMSE)
    
    % Compare the current validation accuracy to the best accuracy so far,
    % and either set the best accuracy to the current accuracy, or increase
    % the number of validations for which there has not been an improvement.
    if info.ValidationRMSE > bestRMSE
        valLag = 0;
        bestRMSE = info.ValidationRMSE;
    else
        valLag = valLag + 1;
    end
    CNN_hist{end+1}={info.Iteration,info.TrainingLoss, info.TrainingRMSE,...
                     info.ValidationLoss, info.ValidationRMSE,...
                     info.State}
    % If the validation lag is at least N, that is, the validation accuracy
    % has not improved for at least N validations, then return true and
    % stop training.
    %save CNN_hist CNN_hist
    if info.ValidationLoss <=1e-8
        stop = true;
    end
    if info.ValidationRMSE <=1e-5
        stop = true;
    end
    if valLag >= N
        stop = true;
    end
end

end