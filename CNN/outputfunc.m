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
    if info.ValidationLoss <=1e-10
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