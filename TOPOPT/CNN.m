%%%%%%%%%% CNN+FFNN constraint %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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