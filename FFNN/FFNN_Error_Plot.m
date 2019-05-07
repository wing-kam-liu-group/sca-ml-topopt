%     This program is for validation trained FFNN 
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
%
%      Last Modifyed: May 1, 2019

%% erorr plot
load('SCA_NN_validation.mat')
load('loading_samples_150_test.mat')
load('SCA_NN_net.mat');
sigma_sup_FFNN_M=net(epsilon_sup_M')';

l1=sum(abs(sigma_sup_FFNN_M-sigma_sup_SCA_M),2);
l2=sum((sigma_sup_FFNN_M-sigma_sup_SCA_M).^2,2);
hist(l2,60);
set(gca,'FontSize',16);
xlabel(['Difference in',char(8467),'^{2} norm'],'fontsize',16); ylabel('Number of Samples','fontsize',16);
ax = gca;
ax.FontSize = 16;
% 
% 
fs=16;
figure; 
subplot(1,3,1);
plot(sigma_sup_SCA_M(:,1),sigma_sup_FFNN_M(:,1),'r*');hold on
plot(sigma_sup_SCA_M(:,1),sigma_sup_SCA_M(:,1),'k')
cor=corrcoef(sigma_sup_SCA_M(:,3),sigma_sup_FFNN_M(:,3));
str=sprintf('r= %1.4f',cor(1,2));
T = text(max(get(gca, 'xlim'))*0.2, max(get(gca, 'ylim'))*0.8, str); 
set(T, 'fontsize', 16, 'verticalalignment', 'top', 'horizontalalignment', 'left');
legend([char(963),'_{xx,SCA}^{M} vs. ',char(963),'_{xx, FFNN}^{M}'],...
    [char(963),'_{xx,SCA}^{M} vs. ',char(963),'_{xx, SCA}^{M}'],'Location','southeast')
xlim([0 12]);ylim([0 12])
set(gca,'FontSize',14);
xlabel([char(963),'_{xx}^{M}, MPa'],'fontsize',fs); ylabel([char(963),'_{xx}^{M}, MPa'],'fontsize',fs);ax = gca;ax.FontSize = 16;
subplot(1,3,2);
plot(sigma_sup_SCA_M(:,2),sigma_sup_FFNN_M(:,2),'blue*');hold on
plot(sigma_sup_SCA_M(:,2),sigma_sup_SCA_M(:,2),'k')
xlim([0 12]);ylim([0 12])
cor=corrcoef(sigma_sup_SCA_M(:,3),sigma_sup_FFNN_M(:,3));
str=sprintf('r= %1.4f',cor(1,2));
T = text(max(get(gca, 'xlim'))*0.2, max(get(gca, 'ylim'))*0.8, str); 
set(T, 'fontsize', 16, 'verticalalignment', 'top', 'horizontalalignment', 'left');
legend([char(963),'_{yy,SCA}^{M} vs. ',char(963),'_{yy, FFNN}^{M}'],...
    [char(963),'_{yy,SCA}^{M} vs. ',char(963),'_{yy, SCA}^{M}'],'Location','southeast')
set(gca,'FontSize',14);
xlabel([char(963),'_{yy}^{M}, MPa'],'fontsize',fs); ylabel([char(963),'_{yy}^{M}, MPa'],'fontsize',fs);ax = gca;ax.FontSize = 16;

subplot(1,3,3);
plot(sigma_sup_SCA_M(:,3),sigma_sup_FFNN_M(:,3),'g*');hold on
plot(sigma_sup_FFNN_M(:,3),sigma_sup_FFNN_M(:,3),'k')
xlim([0 2.5]);ylim([0 2.5])
cor=corrcoef(sigma_sup_SCA_M(:,3),sigma_sup_FFNN_M(:,3));
str=sprintf('r= %1.4f',cor(1,2));
T = text(max(get(gca, 'xlim'))*0.2, max(get(gca, 'ylim'))*0.8, str); 
set(T, 'fontsize', 16, 'verticalalignment', 'top', 'horizontalalignment', 'left');
legend([char(964),'_{xy,SCA}^{M} vs. ',char(964),'_{xy, FFNN}^{M}'],...
    [char(964),'_{xy,SCA}^{M} vs. ',char(964),'_{xy, SCA}^{M}'],'Location','southeast')
set(gca,'FontSize',fs);
xlabel([char(964),'_{xy}^{M}, MPa'],'fontsize',fs); ylabel([char(964),'_{xy}^{M}, MPa'],'fontsize',fs);ax = gca;ax.FontSize = 16;

figure; 
subplot(1,3,1);
set(gca,'FontSize',fs);

%% random seed j contorls which loading history to plot. In the paper, 16 is used. Users can also uncomment line 79 and comment line 80 to examine if the NN capable of capturing all loading cases
%j=ceil(rand*30)-1;
j=16;
strain=zeros(1,6);stress_sca=strain;stress_nn=strain;
for i =1:5
    strain(i+1)=epsilon_sup_M((i-1)*30+j,1); stress_sca(i+1)=sigma_sup_SCA_M((i-1)*30+j,1);stress_nn(i+1)=sigma_sup_FFNN_M((i-1)*30+j,1);
end

plot(strain,stress_sca,'r','linewidth',2);hold on
plot(strain,stress_nn,'x','linewidth',2,'markersize',10)
legend([char(963),'_{xx,SCA}^{M}'],[char(963),'_{xx,FFNN}^{M}'],'Location','Best')
xlabel([char(949),'_{xx}^{M}'],'fontsize',fs); ylabel([char(963),'_{xx}^{M}, MPa'],'fontsize',fs);
xlim([0 max(strain)*1.05]);ylim([0 max(stress_sca)*1.05])
set(gca,'XTick',strain)
set(gca,'XTickLabel', cellstr(num2str(strain(:), '%.3f')))
set(gca,'YTick',stress_sca)
set(gca,'YTickLabel', cellstr(num2str(stress_sca(:), '%.3f')) )
ax = gca;ax.FontSize = 16;

subplot(1,3,2);
set(gca,'FontSize',fs);
for i =1:5
    strain(i+1)=epsilon_sup_M((i-1)*30+j,2); stress_sca(i+1)=sigma_sup_SCA_M((i-1)*30+j,2);stress_nn(i+1)=sigma_sup_FFNN_M((i-1)*30+j,2);
end
plot(strain,stress_sca,'r','linewidth',2);hold on
plot(strain,stress_nn,'x','linewidth',2,'markersize',10)
legend([char(963),'_{yy,SCA}^{M}'],[char(963),'_{yy,FFNN}^{M}'],'Location','Best')
xlabel([char(949),'_{yy}^{M}'],'fontsize',fs); ylabel([char(963),'_{yy}^{M}, MPa'],'fontsize',fs);
xlim([0 max(strain)*1.05]);ylim([0 max(stress_sca)*1.05])
set(gca,'XTick',strain)
set(gca,'XTickLabel', cellstr(num2str(strain(:), '%.3f')))
set(gca,'YTick',stress_sca)
set(gca,'YTickLabel', cellstr(num2str(stress_sca(:), '%.3f')) )
ax = gca;ax.FontSize = 16;

subplot(1,3,3);
set(gca,'FontSize',fs);
for i =1:5
    strain(i+1)=epsilon_sup_M((i-1)*30+j,3); stress_sca(i+1)=sigma_sup_SCA_M((i-1)*30+j,3);stress_nn(i+1)=sigma_sup_FFNN_M((i-1)*30+j,3);
end
plot(strain,stress_sca,'r','linewidth',2);hold on
plot(strain,stress_nn,'x','linewidth',2,'markersize',10)
legend([char(964),'_{xy,SCA}^{M}'],[char(964),'_{xy,FFNN}^{M}'],'Location','Best')
xlabel([char(947),'_{xy}^{M}'],'fontsize',fs); ylabel([char(964),'_{xy}^{M}, MPa'],'fontsize',fs);
xlim([0 max(strain)*1.05]);ylim([0 max(stress_sca)*1.05])
set(gca,'XTick',strain)
set(gca,'XTickLabel', cellstr(num2str(strain(:), '%.3f')))
set(gca,'YTick',stress_sca)
set(gca,'YTickLabel', cellstr(num2str(stress_sca(:), '%.3f')) )
ax = gca;ax.FontSize = 16;
