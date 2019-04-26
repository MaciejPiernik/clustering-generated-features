set output=results\kbs\07semi_supervised\supervisedKmFeaturesOnlyDistTest_result.csv
set alg=km
set classifier=svmLinear
set newFeaturesOnly=TRUE
set type=distance
set scaling=FALSE
set local=FALSE
set semi=FALSE

for /l %%r in (1, 1, 10) do (
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "wine" -c %classifier% -a %alg% -k 15 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local% -p %semi%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "breast-cancer-wisconsin" -c %classifier% -a %alg% -k 36 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local% -p %semi%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "yeast" -c %classifier% -a %alg% -k 90 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local% -p %semi%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "glass" -c %classifier% -a %alg% -k 29 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local% -p %semi%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "ecoli" -c %classifier% -a %alg% -k 21 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local% -p %semi%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "vowel-context" -c %classifier% -a %alg% -k 81 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local% -p %semi%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "iris" -c %classifier% -a %alg% -k 9 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local% -p %semi%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "pima-indians-diabetes" -c %classifier% -a %alg% -k 58 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local% -p %semi%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "sonar.all" -c %classifier% -a %alg% -k 26 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local% -p %semi%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "image-segmentation" -c %classifier% -a %alg% -k 93 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local% -p %semi%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "ionosphere" -c %classifier% -a %alg% -k 48 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local% -p %semi%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "spectrometer" -c %classifier% -a %alg% -k 39 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local% -p %semi%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "statlog-vehicle" -c %classifier% -a %alg% -k 41 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local% -p %semi%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "optdigits" -c %classifier% -a %alg% -k 298 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local% -p %semi%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "statlog-satimage" -c %classifier% -a %alg% -k 114 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local% -p %semi%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "pendigits" -c %classifier% -a %alg% -k 212 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local% -p %semi%
%	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "magic" -c %classifier% -a %alg% -k 339 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local% -p %semi%
%	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "letter" -c %classifier% -a %alg% -k 365 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local% -p %semi%
)
