%     This program is for a simple showcase to illustrate applying FFNN_CNN
%     constraint to topology optimization 
%     Copyright (C) May 1 2019,  Hengyang Li, Northwestern University
%     Part of the code is from Ole Sigmund group's code: 
%     http://www.topopt.mek.dtu.dk/Apps-and-software/A-99-line-topology-optimization-code-written-in-MATLAB
%     Sigmund, O. Struct Multidisc Optim (2001) 21: 120. https://doi.org/10.1007/s001580050176
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
%%%------------------------------------------------------------------------------------------------------------%%%


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
% START ITERATION % 
%This part is mainly from Sigmund's 99%
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
    end
  end
% FILTERING OF SENSITIVITIES
  [dc]   = check(nelx,nely,rmin,x,dc); 
% CNN constrain
  [x]    = FFNN_CNN(nelx,nely,x,yib); 
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