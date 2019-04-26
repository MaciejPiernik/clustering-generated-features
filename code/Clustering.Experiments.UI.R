suppressPackageStartupMessages(source("Clustering.Experiments.R"))
suppressPackageStartupMessages(source("Experiments.Interface.R"))

## Execute the experiment
#set.seed(23)

runclusteringExperiment(opt$output, datasets, classifiers, clusterers, opt$type, opt$scaling, opt$measure,
                        opt$noClusters, opt$new, opt$semi_supervised, opt$local, opt$split, opt$folds, opt$repeats)
