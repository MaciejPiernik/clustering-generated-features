set output=results\kbs\01representation\svmApFeaturesOnlyDistTest_result.csv
set alg=ap
set classifier=svmLinear
set newFeaturesOnly=TRUE
set type=distance
set scaling=FALSE
set local=FALSE

for /l %%r in (1, 1, 10) do (
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "wine" -c %classifier% -a %alg% -k 10 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "breast-cancer-wisconsin" -c %classifier% -a %alg% -k 25 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "yeast" -c %classifier% -a %alg% -k 58 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "glass" -c %classifier% -a %alg% -k 16 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "ecoli" -c %classifier% -a %alg% -k 13 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "vowel-context" -c %classifier% -a %alg% -k 45 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "iris" -c %classifier% -a %alg% -k 6 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "pima-indians-diabetes" -c %classifier% -a %alg% -k 35 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "sonar.all" -c %classifier% -a %alg% -k 16 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "image-segmentation" -c %classifier% -a %alg% -k 56 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "ionosphere" -c %classifier% -a %alg% -k 29 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "spectrometer" -c %classifier% -a %alg% -k 29 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "statlog-vehicle" -c %classifier% -a %alg% -k 27 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "optdigits" -c %classifier% -a %alg% -k 178 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "statlog-satimage" -c %classifier% -a %alg% -k 73 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "pendigits" -c %classifier% -a %alg% -k 136 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local%
%	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "magic" -c %classifier% -a %alg% -k 339 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local%
%	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "letter" -c %classifier% -a %alg% -k 365 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local%
)
