clear all

%% Load the model parameter
uiopen('D:\Radicalism_Change_of_Mind\github\TemporalWeighting.csv',1)
uiopen('D:\Radicalism_Change_of_Mind\github\ChoiceBias.csv',1)
uiopen('D:\Radicalism_Change_of_Mind\github\Choice_Weighting.csv',1)


%% Create variables 
Temporal_Weighting_ScalingPre=TemporalWeighting.ParameterScalingPre;
Temporal_Weighting_ScalingPost=TemporalWeighting.ParameterScalingPost;
Temporal_Weighting_Wpre=TemporalWeighting.ParameterWpre;
Temporal_Weighting_Wpost=TemporalWeighting.ParameterWpost;

Choice_bias_ScalingPre=ChoiceBias.ParameterScalingPre;
Choice_bias_ScalingPost=ChoiceBias.ParameterScalingPost;
Choice_bias_WBias=ChoiceBias.ParameterW;

Choice_Weighting_ScalingPre=ChoiceWeighting.ParameterScalingPre;
Choice_Weighting_ScalingPost=ChoiceWeighting.ParameterScalingPost;
Choice_Weighting_Confirmatory=ChoiceWeighting.ParameterConfirmatory;
Choice_Weighting_Disconfirmatory=ChoiceWeighting.ParameterDisconfirmatory;

Radicalism=ChoiceBias.Radicalism;


%% Evaluate models

% Predicting Radicalism with Parameters of the Temporal Weighting model
Temporal_weighting_tbl = table(zscore(Temporal_Weighting_ScalingPre(1:381)),  zscore(Temporal_Weighting_ScalingPost(1:381)),zscore(Temporal_Weighting_Wpre(1:381)),zscore(Temporal_Weighting_Wpost(1:381)), zscore(Radicalism(1:381)),'VariableNames',{'InternalLow','InternalHigh','Wpre','Wpost', 'Radicalism'});
Temporal_weighting_tbl2 = table(zscore(Temporal_Weighting_ScalingPre(382:798)),  zscore(Temporal_Weighting_ScalingPost(382:798)), zscore(Temporal_Weighting_Wpre(382:798)), zscore(Temporal_Weighting_Wpost(382:798)), zscore(Radicalism(382:798)),'VariableNames',{'InternalLow','InternalHigh','Wpre','Wpost', 'Radicalism'});

fit_Temporal_weighting_1_1=fitlm(Temporal_weighting_tbl, 'Radicalism ~ 1+InternalLow+InternalHigh+ Wpre +Wpost', 'RobustOpts','on')
fit_Temporal_weighting_1_2=fitlm(Temporal_weighting_tbl2, 'Radicalism ~ 1+InternalLow+InternalHigh+ Wpre +Wpost', 'RobustOpts','on')

fit_Temporal_weighting_2_1=fitlm(Temporal_weighting_tbl, 'Radicalism ~ 1+InternalLow+InternalHigh+Wpost ', 'RobustOpts','on')
fit_Temporal_weighting_2_2=fitlm(Temporal_weighting_tbl2, 'Radicalism ~ 1+InternalLow+InternalHigh+ Wpost ', 'RobustOpts','on')

fit_Temporal_weighting_3_1=fitlm(Temporal_weighting_tbl, 'Radicalism ~ 1+InternalLow+InternalHigh+ Wpre ', 'RobustOpts','on')
fit_Temporal_weighting_3_2=fitlm(Temporal_weighting_tbl2, 'Radicalism ~ 1+InternalLow+InternalHigh+ Wpre ', 'RobustOpts','on')

% Predicting Radicalism with Parameters of the Choice Weighting model
Choice_weighting_tbl = table(zscore(Choice_Weighting_ScalingPre(1:381)),  zscore(Choice_Weighting_ScalingPost(1:381)),zscore(Choice_Weighting_Confirmatory(1:381)),zscore(Choice_Weighting_Disconfirmatory(1:381)), zscore(Radicalism(1:381)),'VariableNames',{'InternalLow','InternalHigh','Confirmatory','Disconfirmatory', 'Radicalism'});
Choice_weighting_tbl2 = table(zscore(Choice_Weighting_ScalingPre(382:798)),  zscore(Choice_Weighting_ScalingPost(382:798)), zscore(Choice_Weighting_Confirmatory(382:798)), zscore(Choice_Weighting_Disconfirmatory(382:798)), zscore(Radicalism(382:798)),'VariableNames',{'InternalLow','InternalHigh','Confirmatory','Disconfirmatory', 'Radicalism'});

fit_Choice_weighting_1_1=fitlm(Choice_weighting_tbl, 'Radicalism ~ 1+InternalLow+InternalHigh+ Disconfirmatory +Confirmatory', 'RobustOpts','on')
fit_Choice_weighting_1_2=fitlm(Choice_weighting_tbl2, 'Radicalism ~ 1+InternalLow+InternalHigh+ Disconfirmatory +Confirmatory', 'RobustOpts','on')

fit_Choice_weighting_2_1=fitlm(Choice_weighting_tbl, 'Radicalism ~ 1+InternalLow+InternalHigh+Disconfirmatory ', 'RobustOpts','on')
fit_Choice_weighting_2_2=fitlm(Choice_weighting_tbl2, 'Radicalism ~ 1+InternalLow+InternalHigh+ Disconfirmatory ', 'RobustOpts','on')

fit_Choice_weighting_3_1=fitlm(Choice_weighting_tbl, 'Radicalism ~ 1+InternalLow+InternalHigh+ Confirmatory ', 'RobustOpts','on')
fit_Choice_weighting_3_2=fitlm(Choice_weighting_tbl2, 'Radicalism ~ 1+InternalLow+InternalHigh+ Confirmatory ', 'RobustOpts','on')


% Predicting Radicalism with Parameters of the Choice Bias model
Choice_bias_tbl = table(zscore(Choice_bias_ScalingPre(1:381)),  zscore(Choice_bias_ScalingPost(1:381)),zscore(Choice_bias_WBias(1:381)), zscore(Radicalism(1:381)),'VariableNames',{'InternalLow','InternalHigh','ParameterW', 'Radicalism'});
Choice_bias_tbl2 = table(zscore(Choice_bias_ScalingPre(382:798)),  zscore(Choice_bias_ScalingPost(382:798)), zscore(Choice_bias_WBias(382:798)), zscore(Radicalism(382:798)),'VariableNames',{'InternalLow','InternalHigh','ParameterW', 'Radicalism'});

fit_Choice_bias_1=fitlm(Choice_bias_tbl, 'Radicalism ~ 1+InternalLow+InternalHigh+ParameterW', 'RobustOpts','on')
fit_Choice_bias_2=fitlm(Choice_bias_tbl2, 'Radicalism ~ 1+InternalLow+InternalHigh+ParameterW', 'RobustOpts','on')


%% Find the best parameter combination for each model

% Choice weighting model
[BIC_Choice_Weighting_1 Combination_Choice_Weighting1]=min([fit_Choice_weighting_1_1.ModelCriterion.BIC fit_Choice_weighting_2_1.ModelCriterion.BIC fit_Choice_weighting_3_1.ModelCriterion.BIC])
[BIC_Choice_Weighting_2 Combination_Choice_Weighting2]=min([fit_Choice_weighting_1_2.ModelCriterion.BIC fit_Choice_weighting_2_2.ModelCriterion.BIC fit_Choice_weighting_3_2.ModelCriterion.BIC])

% Temporal Weighting
[BIC_Temporal_Weighting_1 Combination_Temporal_Weighting1]=min([fit_Temporal_weighting_1_1.ModelCriterion.BIC fit_Temporal_weighting_2_1.ModelCriterion.BIC fit_Temporal_weighting_3_1.ModelCriterion.BIC])
[BIC_Temporal_Weighting_2 Combination_Temporal_Weighting2]=min([fit_Temporal_weighting_1_2.ModelCriterion.BIC fit_Temporal_weighting_2_2.ModelCriterion.BIC fit_Temporal_weighting_3_2.ModelCriterion.BIC])

% Choice Bias
BIC_Choice_Bias_1 =fit_Choice_bias_1.ModelCriterion.BIC 
BIC_Choice_Bias_2 =fit_Choice_bias_2.ModelCriterion.BIC


% Find the best model
Best_model_Study1=min([BIC_Temporal_Weighting_1 BIC_Choice_Bias_1 BIC_Choice_Weighting_1]);
Best_model_Study2=min([BIC_Temporal_Weighting_2 BIC_Choice_Bias_2 BIC_Choice_Weighting_2]);


%% Figure Model Comparison

offset=2;
BIC_Study1=[BIC_Temporal_Weighting_1, BIC_Choice_Bias_1, BIC_Choice_Weighting_1,  ]+offset-Best_model_Study1;
BIC_Study2=[BIC_Temporal_Weighting_2, BIC_Choice_Bias_2, BIC_Choice_Weighting_2,  ]+offset-Best_model_Study2;

hold on
figure(1)
b1=bar([1:3:9], [BIC_Study1],'FaceColor',[255/255 255/255 102/255],'EdgeColor',[255/255 255/255 102/255], 'BarWidth', .3)
b2=bar([2:3:10], [BIC_Study2],'FaceColor', [51/255 153/255 255/255],'EdgeColor', [51/255 153/255 255/255], 'BarWidth', .3)
g=legend([b1 b2], {'Study 2', 'Study 3'},'Location','NorthWest')
set(g,'Box','off')
ylim([0 11])
xlim([0 10])

set(gca, 'FontSize', 14,'FontName','Arial','FontWeight','bold','box','off', 'XTick',[1:3:9]+.5, 'XTickLabel',{'Temporal Weighting','Choice bias','Choice Weighting'},  'YTick',[2 4 6 8 10 12], 'YTickLabel',{'0','2','4','6','8','10'})
fix_xticklabels(gca,2,{'FontSize', 14,'FontName','Arial','FontWeight','bold',});
export_fig('Figure_3B',  '-pdf','-nocrop', '-painters', '-transparent', [gca])
