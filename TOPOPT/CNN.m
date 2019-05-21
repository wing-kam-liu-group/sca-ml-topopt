%%%%%%%%%% CNN+FFNN constraint %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     This program is for Training the FFNN 
%     Copyright (C) May 20 2019,  Hengyang Li, Northwestern University
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
%     Last Modifyed: May 20, 2019

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
