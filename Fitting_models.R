

# clear all
rm(list=ls())

# loading toolboxes
library(ggplot2) 
library(R.matlab)
library(reshape)
library(rstan) 
options(scipen = 999)

rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

# set directory 
setwd("D:/Radicalism_Change_of_Mind/github/data")
#loading data
mdata = readMat("data_input_Modelling.mat")
# specify data
Radicalism=mdata$Radicalism
Dogmatism=mdata$Dogmatism
Perormance=mdata$Performance.total
MetaD=mdata$Meta.dprime
Interaction=mdata$interaction
Confirmatory=mdata$integration.confirmatory.evidence
Disconfirmatory=mdata$integration.disconfirmatory.evidence
Conf_correct=mdata$MEAN.confidence.correct
Conf_incorrect=mdata$MEAN.confidence.incorrect
Conf_correct_low=mdata$MEAN.confidence.change.low.correct
Conf_incorrect_low=mdata$MEAN.confidence.change.low.incorrect
Conf_correct_high=mdata$MEAN.confidence.change.high.correct
Conf_incorrect_high=mdata$MEAN.confidence.change.high.incorrect



NumberSubjects=381
NumberSubjects2=798-NumberSubjects


#specify trial-by-trial data Study2
dataInputStduy1 <- list(N=180,
                        J=NumberSubjects,
                        confidence_report=mdata$confidence.report[,1:NumberSubjects],
                        choice=mdata$choice[,1:NumberSubjects],
                        worldstate=mdata$worldstate[,1:NumberSubjects],
                        coherencePre=mdata$coherencePre[1:NumberSubjects],
                        sigma=mdata$sigma[1,1],
                        coherencePost1=mdata$coherencePost1[1:NumberSubjects],
                        coherencePost2=mdata$coherencePost2[1:NumberSubjects],
                        coherencePost=mdata$coherencePost[,1:NumberSubjects],
                        RT=mdata$RT[,1:NumberSubjects]
)

#specify trial-by-trial data Study3

dataInputStduy2 <- list(N=180,
                        J=NumberSubjects2,
                        confidence_report=mdata$confidence.report[,(NumberSubjects+1):798],
                        choice=mdata$choice[,(NumberSubjects+1):798],
                        worldstate=mdata$worldstate[,(NumberSubjects+1):798],
                        coherencePre=mdata$coherencePre[(NumberSubjects+1):798],
                        sigma=mdata$sigma[1,1],
                        coherencePost1=mdata$coherencePost1[(NumberSubjects+1):798],
                        coherencePost2=mdata$coherencePost2[(NumberSubjects+1):798],
                        coherencePost=mdata$coherencePost[,(NumberSubjects+1):798],
                        RT=mdata$RT[,(NumberSubjects+1):798]
)

setwd("D:/Radicalism_Change_of_Mind/github")

# Load the temporal weighting model
Temporal_Weighting_model <- stan_model(file = "Temporal_Weighting.stan")

# Fit the temporal weighting model to Study 2
Fit_temporal_weighting_1 <-vb(Temporal_Weighting_model, data=dataInputStduy1, pars = c("Xpre", "Xpost", "P_all_combined"),include = FALSE,output_samples=1000, seed = sample.int(.Machine$integer.max, 1),elbo_samples=500, tol_rel_obj=0.0001, iter=200000)

# exctract parameters
Params_temporal_weighting_1<-extract(Fit_temporal_weighting_1)
Model1_M1=colMeans(Params_temporal_weighting_1$m)
STD_Model1_M1=apply(Params_temporal_weighting_1$m, 2, sd)
Model1_scaling1=colMeans(Params_temporal_weighting_1$scaling_parameter_pre)
STD_Model1_scaling1=apply(Params_temporal_weighting_1$scaling_parameter_pre, 2, sd)
Model1_scalingPost1=colMeans(Params_temporal_weighting_1$scaling_parameter_post)
STD_Model1_scalingPost1=apply(Params_temporal_weighting_1$scaling_parameter_post, 2, sd)
Model1_w_pre1=colMeans(Params_temporal_weighting_1$w_pre)
STD_Model1_w_pre1=apply(Params_temporal_weighting_1$w_pre, 2, sd)
Model1_w_post1=colMeans(Params_temporal_weighting_1$w_post)
STD_Model1_w_post1=apply(Params_temporal_weighting_1$w_post, 2, sd)
report_noise_1_1=mean(Params_temporal_weighting_1$report_noise)

# Fit the temporal weighting model to Study 3
Fit_temporal_weighting_2 <-vb(Temporal_Weighting_model, data=dataInputStduy2, pars = c("Xpre", "Xpost", "P_all_combined"),include = FALSE,output_samples=1000, seed = sample.int(.Machine$integer.max, 1),elbo_samples=500, tol_rel_obj=0.0001, iter=200000)

# extract parameters
Params_temporal_weighting_1<-extract(Fit_temporal_weighting_2)
Model1_M2=colMeans(Params_temporal_weighting_1$m)
STD_Model1_M2=apply(Params_temporal_weighting_1$m, 2, sd)
Model1_scaling2=colMeans(Params_temporal_weighting_1$scaling_parameter_pre)
STD_Model1_scaling2=apply(Params_temporal_weighting_1$scaling_parameter_pre, 2, sd)
Model1_scalingPost2=colMeans(Params_temporal_weighting_1$scaling_parameter_post)
STD_Model1_scalingPost2=apply(Params_temporal_weighting_1$scaling_parameter_post, 2, sd)
Model1_w_post2=colMeans(Params_temporal_weighting_1$w_post)
STD_Model1_w_post2=apply(Params_temporal_weighting_1$w_post, 2, sd)
Model1_w_pre2=colMeans(Params_temporal_weighting_1$w_pre)
STD_Model1_w_pre2=apply(Params_temporal_weighting_1$w_pre, 2, sd)
report_noise_1_2=mean(Params_temporal_weighting_1$report_noise)



# Specify which parameters to save 
colNames=c("ParameterM", "ParameterScalingPre", "ParameterScalingPost" ,"ParameterWpost","ParameterWpre", "STDM", "STDScalingPre", "STDScalingPost" ,"STDWpost","STDWpre", "MEAN_confidence_correct","MEAN_confidence_incorrect","MEAN_confidence_correct_low","MEAN_confidence_incorrect_low","MEAN_confidence_correct_high","MEAN_confidence_incorrect_high","Performance","Radicalism")
Modelling_output=matrix(c(c(Model1_M1, Model1_M2),c(Model1_scaling1, Model1_scaling2),c(Model1_scalingPost1, Model1_scalingPost2),c(Model1_w_post1, Model1_w_post2),c(Model1_w_pre1, Model1_w_pre2),c(STD_Model1_M1, STD_Model1_M2),c(STD_Model1_scaling1, STD_Model1_scaling2),c(STD_Model1_scalingPost1, STD_Model1_scalingPost2),c(STD_Model1_w_post1, STD_Model1_w_post2),c(STD_Model1_w_pre1, STD_Model1_w_pre2), c(Conf_correct), c(Conf_incorrect), c(Conf_correct_low), c(Conf_incorrect_low), c(Conf_correct_high), c(Conf_incorrect_high),c(Perormance), c(Radicalism)), nrow=798, ncol=18)
colnames(Modelling_output)=colNames
#save parameters
write.table(Modelling_output, file="D:/Radicalism_Change_of_Mind/github/Temporal_weighting_params.csv", sep=",", row.names = FALSE)

#save group-level report-noise
colNames_sum=c("ReportNoise1", "ReportNoise2")
Model_comparison=matrix(c(report_noise_4_1, report_noise_4_2), nrow=1, ncol=2)
colnames(Model_comparison)=colNames_sum
write.table(Model_comparison, file="D:/Radicalism_Change_of_Mind/github/Temporal_weighting_reportNoise.csv", sep=",", row.names = FALSE)





######### Load the choice Bias model
Choice_Bias_model <- stan_model(file = "Choice_Bias.stan")

# Fit Choice Bias model to Study 2
Fit_Chocie_Bias_1 <-vb(Choice_Bias_model, data=dataInputStduy1, pars = c("Xpre", "Xpost", "P_all_combined"),include = FALSE,output_samples=1000, seed = sample.int(.Machine$integer.max, 1),elbo_samples=500, tol_rel_obj=0.0001, iter=200000)

#extract parameters
Params_Choice_Bias_1<-extract(Fit_Chocie_Bias_1)
Model2_M=colMeans(Params_Choice_Bias_1$m)
STD_Model2_M=apply(Params_Choice_Bias_1$m, 2, sd)
Model2_scaling=colMeans(Params_Choice_Bias_1$scaling_parameter_pre)
STD_Model2_scaling=apply(Params_Choice_Bias_1$scaling_parameter_pre, 2, sd)
Model2_scalingPost=colMeans(Params_Choice_Bias_1$scaling_parameter_post)
STD_Model2_scalingPost=apply(Params_Choice_Bias_1$scaling_parameter_post, 2, sd)
Model2_w=colMeans(Params_Choice_Bias_1$w)
STD_Model2_w=apply(Params_Choice_Bias_1$w, 2, sd)
report_noise_2_1=mean(Params_Choice_Bias_1$report_noise)


# Fit Choice Bias model to Study 3
Fit_Chocie_Bias_2 <-vb(Choice_Bias_model, data=dataInputStduy2, pars = c("Xpre", "Xpost", "P_all_combined"),include = FALSE,output_samples=1000, seed = sample.int(.Machine$integer.max, 1),elbo_samples=500, tol_rel_obj=0.0001, iter=200000)

#extract parameters
Params_Choice_Bias_2<-extract(Fit_Chocie_Bias_2)
Model2_M2=colMeans(Params_Choice_Bias_2$m)
STD_Model2_M2=apply(Params_Choice_Bias_2$m, 2, sd)
Model2_scaling2=colMeans(Params_Choice_Bias_2$scaling_parameter_pre)
STD_Model2_scaling2=apply(Params_Choice_Bias_2$scaling_parameter_pre, 2, sd)
Model2_scalingPost2=colMeans(Params_Choice_Bias_2$scaling_parameter_post)
STD_Model2_scalingPost2=apply(Params_Choice_Bias_2$scaling_parameter_post, 2, sd)
Model2_w2=colMeans(Params_Choice_Bias_2$w)
STD_Model2_w2=apply(Params_Choice_Bias_2$w, 2, sd)
report_noise_2_2=mean(Params_Choice_Bias_2$report_noise)

#specify which parameters to save 
colNames=c("ParameterM", "ParameterScalingPre", "ParameterScalingPost" ,"ParameterW", "STDM", "STDScalingPre", "STDScalingPost" ,"STDW","MEAN_confidence_correct","MEAN_confidence_incorrect","MEAN_confidence_correct_low","MEAN_confidence_incorrect_low","MEAN_confidence_correct_high","MEAN_confidence_incorrect_high","Performance","Radicalism")
Modelling_output=matrix(c(c(Model2_M, Model2_M2),c(Model2_scaling, Model2_scaling2),c(Model2_scalingPost, Model2_scalingPost2),c(Model2_w, Model2_w2),c(STD_Model2_M, STD_Model2_M2),c(STD_Model2_scaling, STD_Model2_scaling2),c(STD_Model2_scalingPost, STD_Model2_scalingPost2),c(STD_Model2_w, STD_Model2_w2),c(Conf_correct), c(Conf_incorrect), c(Conf_correct_low), c(Conf_incorrect_low), c(Conf_correct_high), c(Conf_incorrect_high),c(Perormance), c(Radicalism)), nrow=798, ncol=16)
colnames(Modelling_output)=colNames
write.table(Modelling_output, file="D:/Radicalism_Change_of_Mind/github/Choice_Bias_params.csv", sep=",", row.names = FALSE)

#save group-level report-noise
colNames_sum=c("ReportNoise1", "ReportNoise2")
Model_comparison=matrix(c(report_noise_5_1, report_noise_5_2), nrow=1, ncol=2)
colnames(Model_comparison)=colNames_sum
write.table(Model_comparison, file="D:/Radicalism_Change_of_Mind/github/Choice_bias_reportNoise.csv", sep=",", row.names = FALSE)



##################Load Choice wehighting model 

Choice_Weighting_Model <- stan_model(file = "Choice_Weighting.stan")

# Fit Choice weighting to Study 2
Fit_Chocie_Weighting_1 <-vb(Choice_Weighting_Model, data=dataInputStduy1, pars = c("Xpre", "Xpost", "P_all_combined"),include = FALSE,output_samples=1000, seed = sample.int(.Machine$integer.max, 1),elbo_samples=500, tol_rel_obj=0.0001, iter=200000)

# extract Parameters
Params_Chocie_Weighting_1<-extract(Fit_Chocie_Weighting_1)
Model3_M=colMeans(Params_Chocie_Weighting_1$m)
STD_Model3_M=apply(Params_Chocie_Weighting_1$m, 2, sd)
Model3_scaling=colMeans(Params_Chocie_Weighting_1$scaling_parameter_pre)
STD_Model3_scaling=apply(Params_Chocie_Weighting_1$scaling_parameter_pre, 2, sd)
Model3_scalingPost=colMeans(Params_Chocie_Weighting_1$scaling_parameter_post)
STD_Model3_scalingPost=apply(Params_Chocie_Weighting_1$scaling_parameter_post, 2, sd)
Model3_confirmatory=colMeans(Params_Chocie_Weighting_1$w_confirmation)
STD_Model3_confirmatory=apply(Params_Chocie_Weighting_1$w_confirmation, 2, sd)
Model3_disconfirmatory=colMeans(Params_Chocie_Weighting_1$w_disconfirmation)
STD_Model3_disconfirmatory=apply(Params_Chocie_Weighting_1$w_disconfirmation, 2, sd)
report_noise_3_1=mean(Params_Chocie_Weighting_1$report_noise)


# Fit Choice weighting to Study 3
Fit_Chocie_Weighting_2 <-vb(Choice_Weighting_Model, data=dataInputStduy2, pars = c("Xpre", "Xpost", "P_all_combined"),include = FALSE,output_samples=1000, seed = sample.int(.Machine$integer.max, 1),elbo_samples=500, tol_rel_obj=0.0001, iter=200000)

# extract parameters
Params_Chocie_Weighting_2<-extract(Fit_Chocie_Weighting_2)
Model3_M2=colMeans(Params_Chocie_Weighting_2$m)
STD_Model3_M2=apply(Params_Chocie_Weighting_2$m, 2, sd)
Model3_scaling2=colMeans(Params_Chocie_Weighting_2$scaling_parameter_pre)
STD_Model3_scaling2=apply(Params_Chocie_Weighting_2$scaling_parameter_pre, 2, sd)
Model3_scalingPost2=colMeans(Params_Chocie_Weighting_2$scaling_parameter_post)
STD_Model3_scalingPost2=apply(Params_Chocie_Weighting_2$scaling_parameter_post, 2, sd)
Model3_confirmatory2=colMeans(Params_Chocie_Weighting_2$w_confirmation)
STD_Model3_confirmatory2=apply(Params_Chocie_Weighting_2$w_confirmation, 2, sd)
Model3_disconfirmatory2=colMeans(Params_Chocie_Weighting_2$w_disconfirmation)
STD_Model3_disconfirmatory2=apply(Params_Chocie_Weighting_2$w_disconfirmation, 2, sd)
report_noise_3_2=mean(Params_Chocie_Weighting_2$report_noise)

#save parameters
colNames=c("ParameterM", "ParameterScalingPre", "ParameterScalingPost" ,"ParameterConfirmatory","ParameterDisconfirmatory","STDM", "STDScalingPre", "STDScalingPost" ,"STDConfirmatory","STDDisconfirmatory","MEAN_confidence_correct","MEAN_confidence_incorrect","MEAN_confidence_correct_low","MEAN_confidence_incorrect_low","MEAN_confidence_correct_high","MEAN_confidence_incorrect_high","Performance","Radicalism")
Modelling_output=matrix(c(c(Model3_M, Model3_M2),c(Model3_scaling, Model3_scaling2),c(Model3_scalingPost, Model3_scalingPost2),c(Model3_confirmatory, Model3_confirmatory2),c(Model3_disconfirmatory, Model3_disconfirmatory2),c(STD_Model3_M, STD_Model3_M2),c(STD_Model3_scaling, STD_Model3_scaling2),c(STD_Model3_scalingPost, STD_Model3_scalingPost2),c(STD_Model3_confirmatory, STD_Model3_confirmatory2),c(STD_Model3_disconfirmatory, STD_Model3_disconfirmatory2), c(Conf_correct), c(Conf_incorrect), c(Conf_correct_low), c(Conf_incorrect_low), c(Conf_correct_high), c(Conf_incorrect_high),c(Perormance), c(Radicalism)), nrow=798, ncol=18)
colnames(Modelling_output)=colNames
write.table(Modelling_output, file="D:/Radicalism_Change_of_Mind/github/Choice_Weighting_params.csv", sep=",", row.names = FALSE)

#save group-level report-noise
colNames_sum=c("ReportNoise1", "ReportNoise2")
Model_comparison=matrix(c(report_noise_3_1, report_noise_3_2), nrow=1, ncol=2)
colnames(Model_comparison)=colNames_sum
write.table(Model_comparison, file="D:/Radicalism_Change_of_Mind/github/Choice_Weighting_reportNoise.csv", sep=",", row.names = FALSE)

