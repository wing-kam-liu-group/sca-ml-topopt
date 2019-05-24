%%%%%%%%%% FFNN+CNN constraint %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%This part provides the density update based on microstructure damage constraints from FFNN+CNN%%%
%%%This is a simple showcase of applying the constraint. 
%%%The input is nelx, nely: the position of this mesh, x: density of each mesh, yib: three strain components of each mesh.%%%
%%%The net function is a well trained neural network combing FFNN+CNN.%%%
%%%The input of the net function is three strain components. The output is
%%%damage index. If the index>0.5, this mesh is damaged. A penalty factor
%%%will be applied to this mesh's density. However, this will cause some of the
%%%density value higher than 1. The higher density value will be corrected
%%%in the OC function. 
function [xnew]=FFNN_CNN(nelx,nely,x,yib)  
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