source("Clustering.Util.R")

runclusteringExperiment <- function(output, datasets, classifiers, clusterers,
                                    featureType, scaling, measure, noClusters, newFeaturesOnly=FALSE,
                                    semi_supervised=FALSE, local=FALSE, split=0.5, folds=5, repeats=2) {
    
    for(datasetName in datasets) {
        print(paste("Processing dataset", datasetName))
        
        ## Read dataset
        dataset = getDataset(datasetName, "UCI")
        dataset = preprocessData(dataset)
        
        ## Split into training and testing datasets
        sets = list()
        sets$no = splitDataset(dataset, split)
        sets$no$k = 0

        for(clusterer in setdiff(clusterers, "no")) {
            sets[[clusterer]] = addClusteringFeatures(clusterer, sets$no$train, sets$no$test,
                                                      featureType, scaling, noClusters, measure, local,
                                                      newFeaturesOnly, semi_supervised)
        }
        
        for(classifier in classifiers) {
            tryCatch({
                print(paste("Processing classifier", classifier))
                
                for(clusterer in clusterers) {
                    
                    list[trainAccuracy, testAccuracy] = trainTestEvaluate(sets[[clusterer]]$train, sets[[clusterer]]$test,
                                          classifier, folds, repeats)
                    
                    saveResults(output, datasetName, classifier, clusterer, trainAccuracy, testAccuracy, sets[[clusterer]]$k)
                }
                
            }, error = function(e) {
                print(paste("Error during processing dataset", datasetName))
                print(paste("Original error:", e))
            })
        }
    }
}
