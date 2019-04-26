suppressPackageStartupMessages(source("Clustering.Experiments.R"))
suppressPackageStartupMessages(source("Experiments.Interface.R"))

#set.seed(23)

## Read dataset
dataset = getDataset("ecoli", "UCI")
dataset = preprocessData(dataset)

list[train, test] = splitDataset(dataset, opt$split)

list[train, test, k] = addClusteringFeatures(opt$clusterer, train, test, opt$type, 
                                          opt$scaling, opt$noClusters, opt$measure, 
                                          opt$local, opt$new, opt$semi_supervised)

feature.scores = evaluateFeatures(train)

for(fsorder in c("desc", "asc")) {
    
    outputFile = paste0(substr(opt$output, 1, nchar(opt$output)-4), "_", fsorder, substr(opt$output, nchar(opt$output)-3, nchar(opt$output)))

    ordered.features = row.names(feature.scores[order(feature.scores$`Fisher score`, decreasing = ifelse(fsorder == "desc", TRUE, FALSE)), ])
    
    for(i in 1:k) {
        curr.train = train[names(train) %in% c(ordered.features[1:i], "Class")]
        curr.test = train[names(train) %in% c(ordered.features[1:i], "Class")]
        
        list[trainAccuracy, testAccuracy] = trainTestEvaluate(curr.train, curr.test, opt$classifier, opt$folds, opt$repeats)
        
        saveResults(outputFile, opt$dataset, opt$classifier, opt$clusterer, trainAccuracy, testAccuracy, i)
    }
}
