clear all

%% Load the data set
cwd = pwd;
cd('~/Dropbox/InPrep/Politics/Data') %change this path to the directory of the data
load(['Data_Behavioral_Questionnaire_combined.mat'])
cd(cwd)

%% Define exclusion criteria 
index_complete=find(Performance_total<.85 & Performance_total>.6 &variability_confidenceratings<.9 & Type2_RT>850);

%% Exclude people based on behavioral criteria
ParticipantID=ParticipantID(index_complete);
Meta_dprime=Meta_dprime(index_complete);
D_prime=D_prime(index_complete);
D_prime_full=D_prime_full(index_complete);
MEAN_confidence=MEAN_confidence(index_complete);
earnings_final=earnings_final(index_complete);
Performance_confidence_task=Performance_confidence_task(index_complete);
Performance_staircase_high_evidence=Performance_staircase_high_evidence(index_complete);
Performance_change_task=Performance_change_task(index_complete);
post_decision_sensitivty=post_decision_sensitivty(index_complete);
integration_disconfirmatory_evidence=integration_disconfirmatory_evidence(index_complete);
integration_confirmatory_evidence=integration_confirmatory_evidence(index_complete);
Type1_RT=Type1_RT(index_complete);
Type2_RT=Type2_RT(index_complete);
Evidence_strength=Evidence_strength(index_complete);

%% combine data from behavioral and questionnaire data and exclude participants that missed the catch questions
[C, index_questionnaire, index_behavior] = intersect(ID,ParticipantID()');

ParticipantID=ParticipantID(index_behavior);
Meta_dprime=Meta_dprime(index_behavior);
D_prime=D_prime(index_behavior);
D_prime_full=D_prime_full(index_behavior);
MEAN_confidence=MEAN_confidence(index_behavior);
earnings_final=earnings_final(index_behavior);
Performance_confidence_task=Performance_confidence_task(index_behavior);
Performance_staircase_high_evidence=Performance_staircase_high_evidence(index_behavior);
Performance_change_task=Performance_change_task(index_behavior);
post_decision_sensitivty=post_decision_sensitivty(index_behavior);
integration_disconfirmatory_evidence=integration_disconfirmatory_evidence(index_behavior);
integration_confirmatory_evidence=integration_confirmatory_evidence(index_behavior);
Type1_RT=Type1_RT(index_behavior);
Type2_RT=Type2_RT(index_behavior);
Evidence_strength=Evidence_strength(index_behavior);

ID=ID(index_questionnaire);
PoliticalBelief=PoliticalBelief(index_questionnaire);
Dogmatism=Dogmatism(index_questionnaire);
Authoritarianism=Authoritarianism(index_questionnaire);

%combined data from questionnaires and demographic variables
[C, ia, index_demographic] = intersect(ID',ID_demographics);
Gender=Gender(index_demographic);
Education=Education(index_demographic);
Age=Age(index_demographic);
Experiment=Experiment(index_demographic);

% create composite measure of radicalism
Radicalism=Dogmatism+Authoritarianism;


%% Conduct the multiple regressions predicting factor scores based on task vairbales (Figure 3)

% Regression for dogmatic intolerance (Figure 3A)
% Predictors: [1)Gender 2)Education 3)Age 4)Evidence_strength 5)Perf_high 6)Mean_conf
% 7)Perf 8)CEI 9)DEI 10)meta-d']
fit_lm=fitlm([zscore(Gender(Experiment==1)) zscore(Education(Experiment==1)) zscore(Age(Experiment==1)) zscore(Evidence_strength(Experiment==1))' zscore(Performance_staircase_high_evidence(Experiment==1))' zscore(MEAN_confidence(Experiment==1))'  zscore(D_prime_full(Experiment==1))'  zscore(integration_confirmatory_evidence(Experiment==1))' zscore(integration_disconfirmatory_evidence(Experiment==1))' zscore(Meta_dprime(Experiment==1))'], zscore(Dogmatism(Experiment==1)),'linear','RobustOpts','on')
beta_all=fit_lm.Coefficients.Estimate
stderr_all=fit_lm.Coefficients.SE
fit_lm=fitlm([zscore(Gender(Experiment==2)) zscore(Education(Experiment==2)) zscore(Age(Experiment==2)) zscore(Evidence_strength(Experiment==2))' zscore(Performance_staircase_high_evidence(Experiment==2))' zscore(MEAN_confidence(Experiment==2))'  zscore(D_prime_full(Experiment==2))'  zscore(integration_confirmatory_evidence(Experiment==2))' zscore(integration_disconfirmatory_evidence(Experiment==2))' zscore(Meta_dprime(Experiment==2))'], zscore(Dogmatism(Experiment==2)),'linear','RobustOpts','on')
beta_all_rep=fit_lm.Coefficients.Estimate
stderr_all_rep=fit_lm.Coefficients.SE

figure(1)
x=1:4:32
hold on 
errorbar(x(1:3),[beta_all(2:4)'],[stderr_all(2:4)'],'d','Color', [.3 .3 .3], 'MarkerSize',16, 'MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[1 1 1], 'LineWidth', 3)
errorbar(x(4),beta_all(8),stderr_all(8),'o','Color', [.3 .3 .3], 'MarkerSize',16, 'MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[.7 .7 .7], 'LineWidth', 3)
errorbar(x(5),beta_all(7),stderr_all(7),'s','Color', [.3 .3 .3], 'MarkerSize',16, 'MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[0 0 0], 'LineWidth', 3)
errorbar(x(6:end),[beta_all(end-2:end)],[stderr_all(end-2:end)],'s','Color', [.3 .3 .3], 'MarkerSize',16, 'MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[0 0 0], 'LineWidth', 3)
plot(x,zeros(1, length(x)),'k-')
errorbar(x(1:3)+1,[beta_all_rep(2:4)'],[stderr_all_rep(2:4)'],'d','Color', [.3 .3 .3], 'MarkerSize',16, 'MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[1 1 1], 'LineWidth', 3)
errorbar(x(4)+1,beta_all_rep(8),stderr_all_rep(8),'o','Color', [.3 .3 .3], 'MarkerSize',16, 'MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[.7 .7 .7], 'LineWidth', 3)
errorbar(x(5)+1,beta_all_rep(7),stderr_all_rep(7),'s','Color', [.3 .3 .3], 'MarkerSize',16, 'MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[0 0 0], 'LineWidth', 3)
errorbar(x(6:end)+1,[beta_all_rep(end-2:end)],[stderr_all_rep(end-2:end)],'s','Color', [.3 .3 .3], 'MarkerSize',16, 'MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[0 0 0], 'LineWidth', 3)
plot([x-1 32],zeros(1, length(x)+1),'k-')
q=char(39);
str_meta_d=['meta-d' q]
set(gca, 'FontSize', 16,'FontName','Arial','FontWeight','bold','box','off', 'XTick',[x+.5], 'XTickLabel',{'Gender','Ed.','Age','Perf.','Conf. bias','CEI','DEI',str_meta_d})
set(findall(gca, 'Type', 'Line'),'LineWidth',2)
ylabel('Effect Size (standardized beta)')
ylhand = get(gca,'ylabel')
set(ylhand,'fontsize',16)
title('Predictors of dogmatic intolerance')
ylim([-.35 .35])
xlim([0 32])
fix_xticklabels(gca,2,{'FontSize',16,'FontName','Arial','FontWeight','bold'});
hold off


% Regression for authoritarianism (Figure 3B)
fit_lm=fitlm([zscore(Gender(Experiment==1)) zscore(Education(Experiment==1)) zscore(Age(Experiment==1)) zscore(Evidence_strength(Experiment==1))' zscore(Performance_staircase_high_evidence(Experiment==1))' zscore(MEAN_confidence(Experiment==1))'  zscore(D_prime_full(Experiment==1))'  zscore(integration_confirmatory_evidence(Experiment==1))' zscore(integration_disconfirmatory_evidence(Experiment==1))' zscore(Meta_dprime(Experiment==1))'], zscore(Authoritarianism(Experiment==1)),'linear','RobustOpts','on')
beta_all=fit_lm.Coefficients.Estimate
stderr_all=fit_lm.Coefficients.SE
fit_lm=fitlm([zscore(Gender(Experiment==2)) zscore(Education(Experiment==2)) zscore(Age(Experiment==2)) zscore(Evidence_strength(Experiment==2))' zscore(Performance_staircase_high_evidence(Experiment==2))' zscore(MEAN_confidence(Experiment==2))'  zscore(D_prime_full(Experiment==2))'  zscore(integration_confirmatory_evidence(Experiment==2))' zscore(integration_disconfirmatory_evidence(Experiment==2))' zscore(Meta_dprime(Experiment==2))'], zscore(Authoritarianism(Experiment==2)),'linear','RobustOpts','on')
beta_all_rep=fit_lm.Coefficients.Estimate
stderr_all_rep=fit_lm.Coefficients.SE

figure(2)
x=1:4:32
hold on 
errorbar(x(1:3),[beta_all(2:4)'],[stderr_all(2:4)'],'d','Color', [.3 .3 .3], 'MarkerSize',16, 'MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[1 1 1], 'LineWidth', 3)
errorbar(x(4),beta_all(8),stderr_all(8),'o','Color', [.3 .3 .3], 'MarkerSize',16, 'MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[.7 .7 .7], 'LineWidth', 3)
errorbar(x(5),beta_all(7),stderr_all(7),'s','Color', [.3 .3 .3], 'MarkerSize',16, 'MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[0 0 0], 'LineWidth', 3)
errorbar(x(6:end),[beta_all(end-2:end)],[stderr_all(end-2:end)],'s','Color', [.3 .3 .3], 'MarkerSize',16, 'MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[0 0 0], 'LineWidth', 3)
plot(x,zeros(1, length(x)),'k-')
errorbar(x(1:3)+1,[beta_all_rep(2:4)'],[stderr_all_rep(2:4)'],'d','Color', [.3 .3 .3], 'MarkerSize',16, 'MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[1 1 1], 'LineWidth', 3)
errorbar(x(4)+1,beta_all_rep(8),stderr_all_rep(8),'o','Color', [.3 .3 .3], 'MarkerSize',16, 'MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[.7 .7 .7], 'LineWidth', 3)
errorbar(x(5)+1,beta_all_rep(7),stderr_all_rep(7),'s','Color', [.3 .3 .3], 'MarkerSize',16, 'MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[0 0 0], 'LineWidth', 3)
errorbar(x(6:end)+1,[beta_all_rep(end-2:end)],[stderr_all_rep(end-2:end)],'s','Color', [.3 .3 .3], 'MarkerSize',16, 'MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[0 0 0], 'LineWidth', 3)
plot([x-1 32],zeros(1, length(x)+1),'k-')
q=char(39);
str_meta_d=['meta-d' q]
set(gca, 'FontSize', 16,'FontName','Arial','FontWeight','bold','box','off', 'XTick',[x+.5], 'XTickLabel',{'Gender','Ed.','Age','Perf.','Conf. bias','CEI','DEI',str_meta_d})
set(findall(gca, 'Type', 'Line'),'LineWidth',2)
ylabel('Effect Size (standardized beta)')
ylhand = get(gca,'ylabel')
set(ylhand,'fontsize',16)
title('Predictors of authoritarianism')
ylim([-.35 .35])
xlim([0 32])
fix_xticklabels(gca,2,{'FontSize',16,'FontName','Arial','FontWeight','bold'});
hold off


%Regression for political orientation (Figure 3C)

fit_lm=fitlm([zscore(Gender(Experiment==1)) zscore(Education(Experiment==1)) zscore(Age(Experiment==1)) zscore(Evidence_strength(Experiment==1))' zscore(Performance_staircase_high_evidence(Experiment==1))' zscore(MEAN_confidence(Experiment==1))'  zscore(D_prime_full(Experiment==1))'  zscore(integration_confirmatory_evidence(Experiment==1))' zscore(integration_disconfirmatory_evidence(Experiment==1))' zscore(Meta_dprime(Experiment==1))'], zscore(PoliticalBelief(Experiment==1)),'linear','RobustOpts','on')
beta_all=fit_lm.Coefficients.Estimate
stderr_all=fit_lm.Coefficients.SE
fit_lm=fitlm([zscore(Gender(Experiment==2)) zscore(Education(Experiment==2)) zscore(Age(Experiment==2)) zscore(Evidence_strength(Experiment==2))' zscore(Performance_staircase_high_evidence(Experiment==2))' zscore(MEAN_confidence(Experiment==2))'  zscore(D_prime_full(Experiment==2))'  zscore(integration_confirmatory_evidence(Experiment==2))' zscore(integration_disconfirmatory_evidence(Experiment==2))' zscore(Meta_dprime(Experiment==2))'], zscore(PoliticalBelief(Experiment==2)),'linear','RobustOpts','on')
beta_all_rep=fit_lm.Coefficients.Estimate
stderr_all_rep=fit_lm.Coefficients.SE

figure(3)
x=1:4:32
hold on 
errorbar(x(1:3),[beta_all(2:4)'],[stderr_all(2:4)'],'d','Color', [.3 .3 .3], 'MarkerSize',16, 'MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[1 1 1], 'LineWidth', 3)
errorbar(x(4),beta_all(8),stderr_all(8),'o','Color', [.3 .3 .3], 'MarkerSize',16, 'MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[.7 .7 .7], 'LineWidth', 3)
errorbar(x(5),beta_all(7),stderr_all(7),'s','Color', [.3 .3 .3], 'MarkerSize',16, 'MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[0 0 0], 'LineWidth', 3)
errorbar(x(6:end),[beta_all(end-2:end)],[stderr_all(end-2:end)],'s','Color', [.3 .3 .3], 'MarkerSize',16, 'MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[0 0 0], 'LineWidth', 3)
plot(x,zeros(1, length(x)),'k-')
errorbar(x(1:3)+1,[beta_all_rep(2:4)'],[stderr_all_rep(2:4)'],'d','Color', [.3 .3 .3], 'MarkerSize',16, 'MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[1 1 1], 'LineWidth', 3)
errorbar(x(4)+1,beta_all_rep(8),stderr_all_rep(8),'o','Color', [.3 .3 .3], 'MarkerSize',16, 'MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[.7 .7 .7], 'LineWidth', 3)
errorbar(x(5)+1,beta_all_rep(7),stderr_all_rep(7),'s','Color', [.3 .3 .3], 'MarkerSize',16, 'MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[0 0 0], 'LineWidth', 3)
errorbar(x(6:end)+1,[beta_all_rep(end-2:end)],[stderr_all_rep(end-2:end)],'s','Color', [.3 .3 .3], 'MarkerSize',16, 'MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[0 0 0], 'LineWidth', 3)
plot([x-1 32],zeros(1, length(x)+1),'k-')
q=char(39);
str_meta_d=['meta-d' q]
set(gca, 'FontSize', 16,'FontName','Arial','FontWeight','bold','box','off', 'XTick',[x+.5], 'XTickLabel',{'Gender','Ed.','Age','Perf.','Conf. bias','CEI','DEI',str_meta_d})
set(findall(gca, 'Type', 'Line'),'LineWidth',2)
ylabel('Effect Size (standardized beta)')
ylhand = get(gca,'ylabel')
set(ylhand,'fontsize',16)
title('Predictors of political orientation')
ylim([-.35 .35])
xlim([0 32])
fix_xticklabels(gca,2,{'FontSize',16,'FontName','Arial','FontWeight','bold'});
hold off


% Regression for composite measure of radicalism (Figure S3)
fit_lm=fitlm([zscore(Gender(Experiment==1)) zscore(Education(Experiment==1)) zscore(Age(Experiment==1)) zscore(Evidence_strength(Experiment==1))' zscore(Performance_staircase_high_evidence(Experiment==1))' zscore(MEAN_confidence(Experiment==1))'  zscore(D_prime_full(Experiment==1))'  zscore(integration_confirmatory_evidence(Experiment==1))' zscore(integration_disconfirmatory_evidence(Experiment==1))' zscore(Meta_dprime(Experiment==1))'], zscore(Radicalism(Experiment==1)),'linear','RobustOpts','on')
beta_all=fit_lm.Coefficients.Estimate
stderr_all=fit_lm.Coefficients.SE
fit_lm=fitlm([zscore(Gender(Experiment==2)) zscore(Education(Experiment==2)) zscore(Age(Experiment==2)) zscore(Evidence_strength(Experiment==2))' zscore(Performance_staircase_high_evidence(Experiment==2))' zscore(MEAN_confidence(Experiment==2))'  zscore(D_prime_full(Experiment==2))'  zscore(integration_confirmatory_evidence(Experiment==2))' zscore(integration_disconfirmatory_evidence(Experiment==2))' zscore(Meta_dprime(Experiment==2))'], zscore(Radicalism(Experiment==2)),'linear','RobustOpts','on')
beta_all_rep=fit_lm.Coefficients.Estimate
stderr_all_rep=fit_lm.Coefficients.SE

figure(4)
x=1:4:32
hold on 
errorbar(x(1:3),[beta_all(2:4)'],[stderr_all(2:4)'],'d','Color', [.3 .3 .3], 'MarkerSize',16, 'MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[1 1 1], 'LineWidth', 3)
errorbar(x(4),beta_all(8),stderr_all(8),'o','Color', [.3 .3 .3], 'MarkerSize',16, 'MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[.7 .7 .7], 'LineWidth', 3)
errorbar(x(5),beta_all(7),stderr_all(7),'s','Color', [.3 .3 .3], 'MarkerSize',16, 'MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[0 0 0], 'LineWidth', 3)
errorbar(x(6:end),[beta_all(end-2:end)],[stderr_all(end-2:end)],'s','Color', [.3 .3 .3], 'MarkerSize',16, 'MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[0 0 0], 'LineWidth', 3)
plot(x,zeros(1, length(x)),'k-')
errorbar(x(1:3)+1,[beta_all_rep(2:4)'],[stderr_all_rep(2:4)'],'d','Color', [.3 .3 .3], 'MarkerSize',16, 'MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[1 1 1], 'LineWidth', 3)
errorbar(x(4)+1,beta_all_rep(8),stderr_all_rep(8),'o','Color', [.3 .3 .3], 'MarkerSize',16, 'MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[.7 .7 .7], 'LineWidth', 3)
errorbar(x(5)+1,beta_all_rep(7),stderr_all_rep(7),'s','Color', [.3 .3 .3], 'MarkerSize',16, 'MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[0 0 0], 'LineWidth', 3)
errorbar(x(6:end)+1,[beta_all_rep(end-2:end)],[stderr_all_rep(end-2:end)],'s','Color', [.3 .3 .3], 'MarkerSize',16, 'MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[0 0 0], 'LineWidth', 3)
plot([x-1 32],zeros(1, length(x)+1),'k-')
q=char(39);
str_meta_d=['meta-d' q]
set(gca, 'FontSize', 16,'FontName','Arial','FontWeight','bold','box','off', 'XTick',[x+.5], 'XTickLabel',{'Gender','Ed.','Age','Perf.','Conf. bias','CEI','DEI',str_meta_d})
set(findall(gca, 'Type', 'Line'),'LineWidth',2)
ylabel('Effect Size (standardized beta)')
ylhand = get(gca,'ylabel')
set(ylhand,'fontsize',16)
title('Predictors of radicalism')
ylim([-.35 .35])
xlim([0 32])
fix_xticklabels(gca,2,{'FontSize',16,'FontName','Arial','FontWeight','bold'});
hold off


%% Predicting post-decision evidence sensitivty with meta-d' (controlling for other task variables)
fit_lm=fitlm([zscore(Evidence_strength(Experiment==1))' zscore(MEAN_confidence(Experiment==1))' zscore(D_prime_full(Experiment==1))' zscore(Meta_dprime(Experiment==1))'], zscore(post_decision_sensitivty(Experiment==1)),'linear','RobustOpts','on')
fit_lm=fitlm([zscore(Evidence_strength(Experiment==2))' zscore(MEAN_confidence(Experiment==2))' zscore(D_prime_full(Experiment==2))' zscore(Meta_dprime(Experiment==2))'], zscore(post_decision_sensitivty(Experiment==2)),'linear','RobustOpts','on')


