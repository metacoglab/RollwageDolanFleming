data {
int N;
 int J;
  int choice[N, J];
  matrix[N, J] worldstate;
  matrix[N, J] confidence_report;
  matrix[N, J] RT;
 row_vector[J] coherencePre;
 row_vector[J] coherencePost1;
 row_vector[J] coherencePost2;
  matrix[N,J] coherencePost;
 real <lower=0> sigma;
 }
parameters {
 matrix[N, J] Xpre;
matrix[N, J] Xpost;
real mu_m;
real<lower=0,upper=10> sd_m;
real m[J];
real <lower=0,upper=10> scaling_parameter_pre[J];
real <lower=0,upper=10> scaling_parameter_post_add[J];

real <lower=0> mu_scaling;
real <lower=0,upper=10> sigma_scaling;

real  <lower=0, upper=5> w_post[J];
real  <lower=0> mu_post;
real  <lower=0>  sigma_post;

real  <lower=0, upper=5> w_pre[J];
real  <lower=0> mu_pre;
real  <lower=0>  sigma_pre;

real bias_subj[J];
real  <lower=0>  sigma_bias;
real  mu_bias;
real<lower=0,upper=1> report_noise;

}
transformed parameters {

real muT[J];
real muPre[J];
real varT[J];
real  kTheta1[J];
real  kTheta2[J];
real   loglikdir_pre[N,J];


matrix<lower=0,upper=1>[N,J] P_all_combined;
real   loglikdir_post[N,J];

real   loglikC_post[N,J];
real   scaling_parameter_post[J];


for (j in 1:J) {

scaling_parameter_post[j]=  scaling_parameter_post_add[j]+scaling_parameter_pre[j];

  kTheta1[j] = scaling_parameter_pre[j];
  kTheta2[j] = scaling_parameter_post[j];
  muT[j] = (kTheta1[j]+kTheta2[j])/2;
  varT[j]  = (pow((kTheta1[j] - muT[j]), 2)+pow((kTheta2[j] - muT[j]), 2))/2 + 1;
  muPre[j] = scaling_parameter_pre[j];

 
for (n in 1:N)  { 
real c;
real   loglikC_pre;
real   loglikC;

if (coherencePost[n,j] < 0.01 && confidence_report[n,j] <.5){
P_all_combined[n,j]=.5;
loglikdir_post[n,j]=0;
loglikC_post[n,j]=0;
loglikdir_pre[n,j]=0;

}else{




    if (coherencePost[n,j] < 0.01) {
	loglikdir_pre[n,j] = (2 * muPre[j] * Xpre[n,j])/1;
    loglikdir_post[n,j] = 0; // no PDE on these trials
    } else {
	loglikdir_pre[n,j] = (2 * muT[j] * Xpre[n,j])/varT[j];
	loglikdir_post[n,j] = (2 * muT[j] * Xpost[n,j])/varT[j] ;
	}
 
 
 if (choice[n,j]> .9) {
 loglikC_pre=loglikdir_pre[n,j];
 loglikC_post[n,j] = loglikdir_post[n,j];
 } else {
 loglikC_pre=-loglikdir_pre[n,j];
 loglikC_post[n,j] = -loglikdir_post[n,j];
 }
 
if (coherencePost[n,j] < 0.01) {

loglikC = w_pre[j]*loglikC_pre;
} else{
loglikC = w_pre[j]*loglikC_pre + (w_post[j]*loglikC_post[n,j]);

}
 
 P_all_combined[n,j] = inv_logit(loglikC);
}
}
}
}
 model{
 sd_m~uniform(0,10);
 mu_m ~ normal(0, 1);

sigma_post~normal(0,10);
mu_post~normal(1,1);
sigma_pre~normal(0,10);
mu_pre~normal(1,1);

mu_bias~normal(0,1);
sigma_bias~normal(0,10);

report_noise~ normal(0, .1);

 for (j in 1:J){
scaling_parameter_pre[j]~normal(coherencePre[j],1);
scaling_parameter_post_add[j]~normal(coherencePost2[j]-coherencePre[j],1);

m[j]~ normal(mu_m, sd_m);
w_post[j]~normal(mu_post,sigma_post);
w_pre[j]~normal(mu_pre,sigma_pre);
bias_subj[j]~normal(mu_bias,sigma_bias);



  for (n in 1:N){

if (worldstate[n,j]!=0) {
 Xpre[n,j] ~ normal(worldstate[n,j].*scaling_parameter_pre[j], 1);
 if(coherencePost[n,j]>(coherencePost1[j])){
  Xpost[n,j] ~ normal(worldstate[n,j].*scaling_parameter_post[j], 1);
 }else{
   Xpost[n,j] ~ normal(worldstate[n,j].*scaling_parameter_pre[j], 1);
 }
choice[n,j] ~ bernoulli_logit(1000*(Xpre[n,j]-m[j]));
confidence_report[n,j] ~ normal(P_all_combined[n,j],report_noise);

}
} 
}
}


