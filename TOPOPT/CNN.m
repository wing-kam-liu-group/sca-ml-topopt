%%%%%%%%%% FFNN+CNN constraint %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%This part provides the density update based on mincrostructure damage constraints from FFNN+CNN%%%
%%%The input is nelx, nely: position of this mesh, x: density of each mesh, yib: three strain components of each mesh.%%%
%%%The net function is a well trained neural network combing FFNN+CNN.%%%
%%%The input of net function is three strain components
function [xnew]=CNN(nelx,nely,x,yib)  
xnew=x;
penalty=1.3;
global net;
for ely = 1:nely
    for elx = 1:nelx
        index=net(yib(:,ely,elx));
        if index>0.5
            xnew(ely,elx)=penalty*x(ely,elx);
        end
    end
end
end