suppressPackageStartupMessages(library(optparse))

## Supported parameter values
supportedDatasets = c("wine", "breast-cancer-wisconsin", "yeast", "glass", "ecoli",
                      "vowel-context", "iris", "pima-indians-diabetes", "sonar.all",
                      "image-segmentation", "ionosphere", "spectrometer", "statlog-vehicle",
                      "optdigits", "statlog-satimage", "pendigits")

supportedClassifiers = c("PART" ,"multinom", "pda", "gbm", "bayesglm", "rpart", "knn", "svmLinear", "svmRadial")

supportedClusterers = c("no", "km", "ap", "sc", "rnd", "unf")

supportedFeatureTypes = c("factor", "binary", "distance", "binaryDist", "revDistSquared")

supportedMeasures = c("euclidean", "mahalanobis")

## Parse parameters
option_list = list(
    make_option(c("-o", "--output"), type="character", default="result.csv", 
                help="output file name", metavar="character"),
    make_option(c("-d", "--dataset"), type="character", default="pima-indians-diabetes", 
                help=paste("name of a dataset to be used [default= %default] [supported datasets:",
                           paste(supportedDatasets, collapse=", "), "]"),
                metavar="character"),
    make_option(c("-c", "--classifier"), type="character", default="svmLinear", 
                help=paste("classifier to be tested [default= %default] [supported classifiers:", 
                           paste(supportedClassifiers, collapse=", "), "]"),
                metavar="character"),
    make_option(c("-a", "--clusterer"), type="character", default="ap", 
                help=paste("clustering algorithm to be used [default= %default] [supported clustering algorithms:",
                           paste(supportedClusterers, collapse=", "), "]"),
                metavar="character"),
    make_option(c("-t", "--type"), type="character", default="distance", 
                help=paste("feature type [default= %default] [supported feature types:", paste(supportedFeatureTypes, collapse=", "), "]"),
                metavar="character"),
    make_option(c("-g", "--scaling"), type="logical", default=FALSE,
                help="parameter indicating whether new features should be scaled using fisher score"),
    make_option(c("-m", "--measure"), type="character", default="euclidean", 
                help=paste("distance measure [default= %default] [supported distance measures:", paste(supportedMeasures, collapse=", "), "]"),
                metavar="character"),
    make_option(c("-k", "--noClusters"), type="integer", default=8, 
                help=paste("number of clusters [default= %default]"),
                metavar="integer"),
    make_option(c("-n", "--new"), type="logical", default=FALSE,
                help="parameter indicating whether new features should be added to the existing ones or replace them"),
    make_option(c("-p", "--semi_supervised"), type="logical", default=FALSE,
                help="parameter indicating whether new features should be computed in a semi-supervised fashion"),
    make_option(c("-l", "--local"), type="logical", default=FALSE,
                help="parameter indicating whether clustering should be done locally (per class) or globally (on the whole training set)"),
    make_option(c("-s", "--split"), type="double", default=.5,
                help="train-test set split ratio [default= %default]"),
    make_option(c("-f", "--folds"), type="integer", default=5,
                help="number of folds in cross-validation [default= %default]"),
    make_option(c("-r", "--repeats"), type="integer", default=2,
                help="number of repeats of cross-validation [default= %default]")
);

optParser = OptionParser(option_list=option_list);
opt = parse_args(optParser);

if (is.null(opt$output)){
    print_help(optParser)
    stop("At least one argument must be supplied (output file)", call.=FALSE)
}

if(opt$dataset == "all") {
    datasets = supportedDatasets
} else {
    datasets = opt$dataset
}

if(opt$classifier == "all") {
    classifiers = supportedClassifiers
} else {
    classifiers = opt$classifier
}

if(opt$clusterer == "all") {
    clusterers = supportedClusterers
} else {
    clusterers = opt$clusterer
}
