clear all
%% Load the model parameters of the Choice Bias model
uiopen('D:\Radicalism_Change_of_Mind\github\ChoiceBias.csv',1)
uiopen('D:\Radicalism_Change_of_Mind\github\ReportNoise_ChoiceBias.csv',1)

%% Define variables

ParameterScalingPre=ChoiceBias.ParameterScalingPre;
ParameterScalingPost=ChoiceBias.ParameterScalingPost;
ParameterW=ChoiceBias.ParameterW;
ParameterM=ChoiceBias.ParameterM;

STDScalingPre=ChoiceBias.STDScalingPre;
STDScalingPost=ChoiceBias.STDScalingPost;
STDM=ChoiceBias.STDM;
STDW=ChoiceBias.STDW;

Radicalism=ChoiceBias.Radicalism;

MEAN_confidence_correct=ChoiceBias.MEAN_confidence_correct;
MEAN_confidence_incorrect=ChoiceBias.MEAN_confidence_incorrect;
MEAN_confidence_correct_low=ChoiceBias.MEAN_confidence_correct_low;
MEAN_confidence_incorrect_low=ChoiceBias.MEAN_confidence_incorrect_low;
MEAN_confidence_correct_high=ChoiceBias.MEAN_confidence_correct_high;
MEAN_confidence_incorrect_high=ChoiceBias.MEAN_confidence_incorrect_high;

ReportNoise1=ReportNoiseChoiceBias.ReportNoise1;
ReportNoise2=ReportNoiseChoiceBias.ReportNoise2;

%% simulate posterior predictives

for subject=1:length(ParameterScalingPre) %% loop over all subjects 
    
    
    for sample=1:100 % draw 100 samples of each parameter for each subject
        
        % draw the parameters from the posterior distribution
        Scaling_pre=normrnd(ParameterScalingPre(subject),STDScalingPre(subject));
        Scaling_post=normrnd(ParameterScalingPost(subject),STDScalingPost(subject));
        M=normrnd(ParameterM(subject),STDM(subject));
        W=normrnd(ParameterW(subject),STDW(subject));

        %check that W is not 1 or 0 (which cause computational problems) 
        if W>.99
            W=.99;
        elseif W<0.01
            W=.01;
        end
        
        % draw Xpre and and Xpost values for 4000 trials 
        world_state=[repmat(1,1,2000), repmat(-1,1,2000)];
        Xpre_right=normrnd(1.*Scaling_pre,1, 1, 2000);
        Xpre_left=normrnd(-1.*Scaling_pre,1, 1, 2000);
        Xpre_all=[Xpre_right Xpre_left];
        Accuracy_right=zeros(1,length(Xpre_right));
        Accuracy_right(Xpre_right>M)=1;
        Accuracy_left=zeros(1,length(Xpre_left));
        Accuracy_left(Xpre_left<M)=1;
        Accuracy_all=[Accuracy_right Accuracy_left];
        Xpost_low_right=normrnd(1.*Scaling_pre,1, 1, 2000);
        Xpost_low_left=normrnd(-1.*Scaling_pre,1, 1, 2000);
        Xpost_low_all=[Xpost_low_right Xpost_low_left];
        Xpost_high_right=normrnd(1.*Scaling_post,1, 1, 2000);
        Xpost_high_left=normrnd(-1.*Scaling_post,1, 1, 2000);
        Xpost_high_all=[Xpost_high_right Xpost_high_left];
        
        
        % calculate the mean and variance for pre and post value and 
        coh = [Scaling_pre Scaling_post];
        muPre=Scaling_pre;
        muT = sum(coh)/2;
        VarPre=1;
        VarPost = (sum((coh - muT).^2)./2) + 1;
        
        % calculate the log-oddds correct for the direction based on Xpre and
        % Xpost
        loglikdir_pre=(2 * muPre * Xpre_all)/1;
        loglikdir_pre2=(2 * muT * Xpre_all)/VarPost;
        loglikdir_post_low=(2 * muT * Xpost_low_all)/VarPost;
        loglikdir_post_high=(2 * muT * Xpost_high_all)/VarPost;
        
        % change sign for left decision
        loglikdir_pre(Xpre_all<M)=-loglikdir_pre(Xpre_all<M);
        loglikdir_pre2(Xpre_all<M)=-loglikdir_pre2(Xpre_all<M);
        loglikdir_post_low(Xpre_all<M)=-loglikdir_post_low(Xpre_all<M);
        loglikdir_post_high(Xpre_all<M)=-loglikdir_post_high(Xpre_all<M);
        
        % calculate the choice dependent bias term
        loglikdir_bias=zeros(1,length(Xpre_all));
        loglikdir_bias(Xpre_all>M)=log(W/(1-W));
        loglikdir_bias(Xpre_all<M)=log((1-W)/W);      
        loglikdir_bias(Xpre_all<M)=-loglikdir_bias(Xpre_all<M);

        
        % calculate the final log-odds correct
        loglikC_pre=loglikdir_pre+loglikdir_bias;
        loglikC_post_low=loglikdir_pre2+loglikdir_post_low+loglikdir_bias;
        loglikC_post_high=loglikdir_pre2+loglikdir_post_high+loglikdir_bias;
        
        %transform log-odds correct into confidence report
        confidence_pre=(1./(1+exp(-loglikC_pre)));
        confidence_post_low=(1./(1+exp(-loglikC_post_low)));
        confidence_post_high=(1./(1+exp(-loglikC_post_high)));
        
        % add report noise to the calculated confidence (which was fitted as group-level parameter separately for both studies) 
        
        if subject<=381
            confidence_pre_report=normrnd(confidence_pre, ReportNoise1);
            confidence_post_low_report=normrnd(confidence_post_low, ReportNoise1);
            confidence_post_high_report=normrnd(confidence_post_high, ReportNoise1);
        else
            confidence_pre_report=normrnd(confidence_pre, ReportNoise2);
            confidence_post_low_report=normrnd(confidence_post_low, ReportNoise2);
            confidence_post_high_report=normrnd(confidence_post_high, ReportNoise2);
        end
        
      
        % make sure that confidence is bounded by 0 and 1
        confidence_pre_report(confidence_pre_report>1)=1;
        confidence_pre_report(confidence_pre_report<0)=0;
        confidence_post_low_report(confidence_post_low_report>1)=1;
        confidence_post_low_report(confidence_post_low_report<0)=0;
        confidence_post_high_report(confidence_post_high_report>1)=1;
        confidence_post_high_report(confidence_post_high_report<0)=0;

        % calculate mean confidence for correct and incorrect trials and
        % the different post-decision evidence strengths
        Average_correct(sample)=mean(confidence_pre_report(Accuracy_all==1));
        Average_incorrect(sample)=mean(confidence_pre_report(Accuracy_all==0));
        Average_Low_correct(sample)=mean(confidence_post_low_report(Accuracy_all==1));
        Average_Low_incorrect(sample)=mean(confidence_post_low_report(Accuracy_all==0));
        Average_high_correct(sample)=mean(confidence_post_high_report(Accuracy_all==1));
        Average_high_incorrect(sample)=mean(confidence_post_high_report(Accuracy_all==0));
        
    end
    
    
    % average the mean confidence for each participant over the 100 parameter draws
    pred_Average_correct(subject)=mean(Average_correct);
    pred_Average_incorrect(subject)=mean(Average_incorrect);
    pred_Average_Low_correct(subject)=mean(Average_Low_correct);
    pred_Average_Low_incorrect(subject)=mean(Average_Low_incorrect);
    pred_Average_high_correct(subject)=mean(Average_high_correct);
    pred_Average_high_incorrect(subject)=mean(Average_high_incorrect);
end

%% Visualize posterior predicitves

x2=[1 2 3]
x=[0 .125 .25 .375 .5 .625 .75 .875 1]

% sort participants in 10% most radicals against rest of sample
percent_extreme=.1
cuttoff=round(length(Radicalism)*percent_extreme)
[A I]=sort(Radicalism)
Index_extreme=I((end-cuttoff):end)
Index_moderate=I(1:(end-cuttoff-1))


% calculate the (empirical) group mean and 95% confidence interval for mean confidence of
% correct and incorrect trials for different post-decision evidence
% strengths
y_correct2_extreme=[mean(MEAN_confidence_correct(Index_extreme)) mean(MEAN_confidence_correct_low(Index_extreme)) mean(MEAN_confidence_correct_high(Index_extreme))];
std_y_correct2_extreme=1.97*[ std(MEAN_confidence_correct(Index_extreme)) std(MEAN_confidence_correct_low(Index_extreme)) std(MEAN_confidence_correct_high(Index_extreme))]./sqrt(length(MEAN_confidence_correct(Index_extreme)));
y_incorrect2_extreme=[mean(MEAN_confidence_incorrect(Index_extreme)) mean(MEAN_confidence_incorrect_low(Index_extreme)) mean(MEAN_confidence_incorrect_high(Index_extreme))];
std_y_incorrect2_extreme=1.97*[std(MEAN_confidence_incorrect(Index_extreme)) std(MEAN_confidence_incorrect_low(Index_extreme)) std(MEAN_confidence_incorrect_high(Index_extreme))]./sqrt(length(MEAN_confidence_incorrect(Index_extreme)));

y_correct2_moderate=[mean(MEAN_confidence_correct(Index_moderate)) mean(MEAN_confidence_correct_low(Index_moderate)) mean(MEAN_confidence_correct_high(Index_moderate))];
std_y_correct2_moderate=1.96*[ std(MEAN_confidence_correct(Index_moderate)) std(MEAN_confidence_correct_low(Index_moderate)) std(MEAN_confidence_correct_high(Index_moderate))]./sqrt(length(MEAN_confidence_correct(Index_moderate)));
y_incorrect2_moderate=[mean(MEAN_confidence_incorrect(Index_moderate)) mean(MEAN_confidence_incorrect_low(Index_moderate)) mean(MEAN_confidence_incorrect_high(Index_moderate))];
std_y_incorrect2_moderate=1.96*[std(MEAN_confidence_incorrect(Index_moderate)) std(MEAN_confidence_incorrect_low(Index_moderate)) std(MEAN_confidence_incorrect_high(Index_moderate))]./sqrt(length(MEAN_confidence_incorrect(Index_moderate)));


% calculate the model predicitons of group mean and 95% confidence interval for mean confidence of
% correct and incorrect trials for different post-decision evidence
% strengths
Simulation_Average_Conf_Correct_extreme=mean(pred_Average_correct(Index_extreme))
Simulation_Std_Conf_Correct_extreme=1.97*(std(pred_Average_correct(Index_extreme))/sqrt(length(Index_extreme)))
Simulation_Average_Conf_Incorrect_extreme=mean(pred_Average_incorrect(Index_extreme))
Simulation_Std_Conf_Incorrect_extreme=1.97*(std(pred_Average_incorrect(Index_extreme))/sqrt(length(Index_extreme)))


Simulation_Average_Low_Correct_extreme=mean(pred_Average_Low_correct(Index_extreme))
Simulation_Std_Low_Correct_extreme=1.97*(std(pred_Average_Low_correct(Index_extreme))/sqrt(length(Index_extreme)))
Simulation_Average_Low_Incorrect_extreme=mean(pred_Average_Low_incorrect(Index_extreme))
Simulation_Std_Low_Incorrect_extreme=1.97*(std(pred_Average_Low_incorrect(Index_extreme))/sqrt(length(Index_extreme)))


Simulation_Average_High_Correct_extreme=mean(pred_Average_high_correct(Index_extreme))
Simulation_Std_High_Correct_extreme=1.97*(std(pred_Average_high_correct(Index_extreme))/sqrt(length(Index_extreme)))
Simulation_Average_High_Incorrect_extreme=mean(pred_Average_high_incorrect(Index_extreme))
Simulation_Std_High_Incorrect_extreme=1.97*(std(pred_Average_high_incorrect(Index_extreme))/sqrt(length(Index_extreme)))

Simulation_Average_Conf_Correct_moderates=mean(pred_Average_correct(Index_moderate))
Simulation_Std_Conf_Correct_moderates=1.96*(std(pred_Average_correct(Index_moderate))/sqrt(length(Index_moderate)))
Simulation_Average_Conf_Incorrect_moderates=mean(pred_Average_incorrect(Index_moderate))
Simulation_Std_Conf_Incorrect_moderates=1.96*(std(pred_Average_incorrect(Index_moderate))/sqrt(length(Index_moderate)))

Simulation_Average_Low_Correct_moderates=mean(pred_Average_Low_correct(Index_moderate))
Simulation_Std_Low_Correct_moderates=1.96*(std(pred_Average_Low_correct(Index_moderate))/sqrt(length(Index_moderate)))
Simulation_Average_Low_Incorrect_moderates=mean(pred_Average_Low_incorrect(Index_moderate))
Simulation_Std_Low_Incorrect_moderates=1.96*(std(pred_Average_Low_incorrect(Index_moderate))/sqrt(length(Index_moderate)))

Simulation_Average_High_Correct_moderates=mean(pred_Average_high_correct(Index_moderate))
Simulation_Std_High_Correct_moderates=1.96*(std(pred_Average_high_correct(Index_moderate))/sqrt(length(Index_moderate)))
Simulation_Average_High_Incorrect_moderates=mean(pred_Average_high_incorrect(Index_moderate))
Simulation_Std_High_Incorrect_moderates=1.96*(std(pred_Average_high_incorrect(Index_moderate))/sqrt(length(Index_moderate)))

correct_model_moderates=[Simulation_Average_Conf_Correct_moderates Simulation_Average_Low_Correct_moderates Simulation_Average_High_Correct_moderates];
std_correct_model_moderates=[Simulation_Std_Low_Correct_moderates Simulation_Std_Low_Correct_moderates Simulation_Std_High_Correct_moderates];
correct_model_radicals=  [Simulation_Average_Conf_Correct_extreme Simulation_Average_Low_Correct_extreme Simulation_Average_High_Correct_extreme];
std_correct_model_radicals=[Simulation_Std_Conf_Correct_extreme Simulation_Std_Low_Correct_extreme Simulation_Std_High_Correct_extreme];

incorrect_model_moderates=[Simulation_Average_Conf_Incorrect_moderates Simulation_Average_Low_Incorrect_moderates Simulation_Average_High_Incorrect_moderates];
std_incorrect_model_moderates=[Simulation_Std_Conf_Correct_moderates Simulation_Std_Low_Correct_moderates Simulation_Std_High_Correct_moderates];
incorrect_model_radicals= [Simulation_Average_Conf_Incorrect_extreme Simulation_Average_Low_Incorrect_extreme Simulation_Average_High_Incorrect_extreme];
std_incorrect_model_radicals=[Simulation_Std_Conf_Incorrect_moderates Simulation_Std_Low_Incorrect_moderates Simulation_Std_High_Incorrect_moderates];


%% Plot Figure 4B

figure(1)
hold on
shadedErrorBar(x2,correct_model_radicals,std_correct_model_radicals,'--g')
shadedErrorBar(x2,correct_model_moderates,std_correct_model_moderates,'-g')
shadedErrorBar(x2,incorrect_model_radicals,std_incorrect_model_radicals,'--r')
shadedErrorBar(x2,incorrect_model_moderates,std_incorrect_model_moderates,'-r')
errorbar(x2+.05, y_correct2_extreme, std_y_correct2_extreme, 'sg', 'MarkerSize',12, 'LineWidth', 1.5)
h1=plot(x2+.05, y_correct2_extreme, 'sg', 'MarkerSize',12)
errorbar(x2-.05,  y_correct2_moderate,std_y_correct2_moderate, 'og', 'MarkerSize',12, 'LineWidth', 1.5)
h2=plot(x2-.05, y_correct2_moderate, 'og', 'MarkerSize',12)
errorbar(x2+.05, y_incorrect2_extreme,std_y_incorrect2_extreme, 'sr', 'MarkerSize',12, 'LineWidth',  1.5)
h3=plot(x2+.05, y_incorrect2_extreme, 'sr', 'MarkerSize',12)
errorbar(x2-.05, y_incorrect2_moderate,std_y_incorrect2_moderate, 'or', 'MarkerSize',12, 'LineWidth', 1.5)
h4=plot(x2-.05, y_incorrect2_moderate, 'or', 'MarkerSize',12)
xlim([0.5 3.5])
ylim([.3 .9])
set(gca, 'FontSize', 15,'FontName','Arial','FontWeight','bold','box','off', 'XTick',[1 2 3], 'XTickLabel',{'Confidence task','Low Post-decision Evidence','High Post-decision Evidence'},  'YTick',[.3 .4 .5 .6 .7 .8 .9], 'YTickLabel',{'30%','','50%','','70%','','90%'})
ylabel('Confidence rating')
g=legend([h1 h2 h3 h4], {'Radicals Correct', 'Moderates Correct', 'Radicals Incorrect', 'Moderates Incorrect'},'Location','SouthWest')
set(g,'Box','off')
fix_xticklabels(gca,2,{'FontSize', 15,'FontName','Arial','FontWeight','bold',});
set(findall(gca, 'Type', 'Line'),'LineWidth',2)
hold off
