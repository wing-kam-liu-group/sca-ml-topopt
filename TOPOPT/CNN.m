%%%%%%%%%% CNN+FFNN constraint %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Part of the code was adapted from Ole Sigmund et.al: 
%     http://www.topopt.mek.dtu.dk/Apps-and-software/A-99-line-topology-optimization-code-written-in-MATLAB
%     Sigmund, O. Struct Multidisc Optim (2001) 21: 120. https://doi.org/10.1007/s001580050176


function [xnew]=CNN(nelx,nely,x,yib)  
xnew=x;
global net;
for ely = 1:nely
    for elx = 1:nelx
        index=net(yib(:,ely,elx));
        if index>0.5
            xnew(ely,elx)=1.3*x(ely,elx);
        end
    end
end
end
