%%%%%%%%%% OPTIMALITY CRITERIA UPDATE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Part of the code was adapted from Ole Sigmund et.al: 
%     http://www.topopt.mek.dtu.dk/Apps-and-software/A-99-line-topology-optimization-code-written-in-MATLAB
%     Sigmund, O. Struct Multidisc Optim (2001) 21: 120. https://doi.org/10.1007/s001580050176


function [xnew]=OC(nelx,nely,x,volfrac,dc)  
l1 = 0; l2 = 100000; move = 0.2;
while (l2-l1 > 1e-4)
  lmid = 0.5*(l2+l1);
  xnew = max(0.001,max(x-move,min(1.,min(x+move,x.*sqrt(-dc./lmid)))));
  if sum(sum(xnew)) - volfrac*nelx*nely > 0;
    l1 = lmid;
  else
    l2 = lmid;
  end
end

