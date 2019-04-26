set output=results\kbs\03local_global\svmKmFeaturesOnlyDistGlobalTest_result.csv
set alg=km
set classifier=svmLinear
set newFeaturesOnly=TRUE
set type=distance
set scaling=FALSE
set local=FALSE

for /l %%r in (1, 1, 10) do (
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "wine" -c %classifier% -a %alg% -k 20 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "breast-cancer-wisconsin" -c %classifier% -a %alg% -k 49 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "yeast" -c %classifier% -a %alg% -k 102 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "glass" -c %classifier% -a %alg% -k 30 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "ecoli" -c %classifier% -a %alg% -k 33 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "vowel-context" -c %classifier% -a %alg% -k 82 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "iris" -c %classifier% -a %alg% -k 16 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "pima-indians-diabetes" -c %classifier% -a %alg% -k 46 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "sonar.all" -c %classifier% -a %alg% -k 22 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "image-segmentation" -c %classifier% -a %alg% -k 117 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "ionosphere" -c %classifier% -a %alg% -k 15 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "spectrometer" -c %classifier% -a %alg% -k 29 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "statlog-vehicle" -c %classifier% -a %alg% -k 42 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "optdigits" -c %classifier% -a %alg% -k 298 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "statlog-satimage" -c %classifier% -a %alg% -k 201 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local%
	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "pendigits" -c %classifier% -a %alg% -k 300 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local%
%	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "magic" -c %classifier% -a %alg% -k 336 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local%
%	RScript --vanilla Clustering.Experiments.UI.R -o %output% -d "letter" -c %classifier% -a %alg% -k 631 -n %newFeaturesOnly% -t %type% -g %scaling% -l %local%
)
