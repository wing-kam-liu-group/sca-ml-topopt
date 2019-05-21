%     This program is for training the CNN network for predicting macroscopic stress state 
%     Part of the code was adapted from Ole Sigmund et.al: 
%     http://www.topopt.mek.dtu.dk/Apps-and-software/A-99-line-topology-optimization-code-written-in-MATLAB
%     Sigmund, O. Struct Multidisc Optim (2001) 21: 120. https://doi.org/10.1007/s001580050176


% DEFINE PART SIZE: nelx,nely. VOLUME FRACTION: Volfrac. PENALTY:penal. MINIMAL
% SIZE:rmin
nelx=60;
nely=30;
volfrac=0.35;
penal=3;
rmin=1.5;
% INITIALIZE
x(1:nely,1:nelx) = volfrac; 
loop = 0; 
change = 1.;
load('net.mat');
global net;
% START ITERATION
while change > 0.07  
  loop = loop + 1;
  xold = x;
  B=[-1/2,0,1/2,0,1/2,0,-1/2,0;0,-1/2,0,-1/2,0,1/2,0,1/2;-1/2,-1/2,-1/2,1/2,1/2,1/2,1/2,-1/2];
% FE-ANALYSIS
  [U]=FE(nelx,nely,x,penal); 
% OBJECTIVE FUNCTION AND SENSITIVITY ANALYSIS
  [KE] = lk;
  c = 0.;
  for ely = 1:nely
    for elx = 1:nelx
      n1 = (nely+1)*(elx-1)+ely; 
      n2 = (nely+1)* elx   +ely;
      Ue = U([2*n1-1;2*n1; 2*n2-1;2*n2; 2*n2+1;2*n2+2; 2*n1+1;2*n1+2],1);
      c = c + x(ely,elx)^penal*Ue'*KE*Ue;
      dc(ely,elx) = -penal*x(ely,elx)^(penal-1)*Ue'*KE*Ue;
      yib(:,ely,elx)=B*Ue;
%       yibbar(ely,elx)=sqrt(2*(yib(1)^2+yib(2)^2-yib(1)*yib(2)+3*yib(3)^2)/9);
    end
  end
% FILTERING OF SENSITIVITIES
  [dc]   = check(nelx,nely,rmin,x,dc); 
% CNN constrain
  [x]    = CNN(nelx,nely,x,yib); 
% DESIGN UPDATE BY THE OPTIMALITY CRITERIA METHOD
  [x]    = OC(nelx,nely,x,volfrac,dc); 

% PRINT RESULTS
  change = max(max(abs(x-xold)));
  disp([' It.: ' sprintf('%4i',loop) ' Obj.: ' sprintf('%10.4f',c) ...
       ' Vol.: ' sprintf('%6.3f',sum(sum(x))/(nelx*nely)) ...
        ' ch.: ' sprintf('%6.3f',change )])
% PLOT DENSITIES  
  colormap(gray); imagesc(-x); axis equal; axis tight; axis off;pause(1e-6);
end
