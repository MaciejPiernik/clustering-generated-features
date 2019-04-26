library(readMLData)
library(apcluster)
library(kernlab)
library(caret)
library(dplyr)
#library(FSelector)
library(spatstat)
library(matrixcalc)
source("https://raw.githubusercontent.com/ggrothendieck/gsubfn/master/R/list.R")

is.dataset.numeric <- function(dataset) {
    is.numeric(dataset[, !names(dataset) %in% c("Class", "Cluster")][, 1])
}

isMahalanobian <- function(data) {
    nrow(unique(data)) > ncol(data) &&
        all(apply(data, 2, var) != 0) &&
        !is.singular.matrix(cov(data))
}

getNumberOfClusters <- function(dataset) {
    result = 1
    max.clusters = nrow(dataset)
    
    if(max.clusters > 2) {
        wss = nrow(dataset) * sum(apply(dataset, 2, var))
        tryCatch({
                for (i in 2:max.clusters) {
                    wss[i] = sum(kmeans(dataset, i)$withinss)
                }   
            },
            error = function(cond) {
                print(cond)
            }
        )
    
        wss.diffs = wss[-1] - wss[-length(wss)]
        
        result = min(which(abs(wss.diffs) < sqrt(var(wss.diffs)))) + 1
        
        if(result %in% c(NaN, NA, Inf, -Inf, FALSE)) {
            result = 1
        }
    }
    
    result
}

preprocessData <- function(dataset, dataset.name) {
    dataset = na.omit(dataset)
    
    numeric.columns = sapply(dataset, is.numeric)
    columns.with.no.variance = names(dataset[, numeric.columns])[sapply(dataset[, numeric.columns], var) == 0]
    
    dataset[, numeric.columns] = scale(dataset[, numeric.columns])
    dataset = dataset[, !names(dataset) %in% columns.with.no.variance]
    
    dataset
}

getDataset <- function(name, type, dsList=NULL, responseName="Class",
                       pathData="../datasets/UCI_ML_DataFolders/",
                       pathDescription="../datasets//UCI_ML_DataDescription") {
    if (type == "package") {
        data(list=name)   
        get(name)
    } else if (type == "UCI") {
        if (is.null(dsList)){
            dsList = prepareDSList(pathData, pathDescription)
        }
        dsDownload(dsList, name, "curl -O", "links.txt")
        dsRead(dsList, name, responseName)
    } else {
        stop(paste("Unknown dataset type: ", type))
    }
}

clustersToBinaryFeatures <- function(clusters.assignment, clusters=sort(unique(clusters.assignment))) {
    noSamples = length(clusters.assignment)
    noClusters = length(clusters)
    
    features = apply(as.data.frame(clusters), 1, function(clu, clusters.assignment) {
        (clu == clusters.assignment)*1
    }, clusters.assignment=clusters.assignment)
    
    features = as.data.frame(features)
    names(features) = paste0("C", 1:noClusters)
    
    features
}

clustersToNumericFeatures <- function(dataset, centers, measure="euclidean", covMat=NULL) {
    
    if(nrow(dataset) == 0) {
        features = data.frame(matrix(ncol=nrow(centers)))
        colnames(features) = paste0("C", 1:nrow(centers))
        features = features[0, ]
    } else {
        dataset.isNumeric = is.dataset.numeric(dataset)
        
        features = apply(dataset[, !names(dataset) %in% "Class"], 1, 
                       function (example, centers, m, cM) {
                           if(dataset.isNumeric) {
                               if(m == "euclidean" || is.singular.matrix(cM)) {
                                   distances = apply(centers, 1, function(v1, v2) {
                                       dist(rbind(v1, v2))
                                   }, v2=example)
                               } else if (m == "mahalanobis") {
                                   distances = apply(centers, 1, mahalanobis, example, cM)
                               }
                           } else {
                               distances = apply(centers, 1, function(v1, v2) {
                                   sum((v1!=v2)*1)
                               }, v2=example)
                           }
                           
                           distances
                       }, centers=centers, m=measure, cM=covMat)
        
        features = as.data.frame(t(features))
        colnames(features) = paste0("C", 1:nrow(centers))
    }
    
    features
}

fisher.score <- function(a, c) {
    mi = mean(a)
    
    data = data.frame(a, c) %>%
        dplyr::group_by(c) %>%
        dplyr::summarise(mi_i = mean(a), sigma_i = sd(a), n_i = n()) %>%
        dplyr::summarise(result = sum(n_i*(mi_i - mi)^2)/sum(n_i*ifelse(is.na(sigma_i), 0 , sigma_i)^2))
    
    data$result
}

splitDataset <- function(dataset, splitRatio) {
    index = createDataPartition(dataset$Class, p=splitRatio, list=FALSE)
    trainSet = dataset[ index,]
    testSet = dataset[-index,]
    
    list(train=trainSet, test=testSet)
}

convertClusteringFeatures <- function(dataset, feature.type, clusters.assignment, 
                                  clusters=sort(unique(clusters.assignment)),
                                  centers=NULL, measure="euclidean", covMat=NULL, newFeaturesOnly){
    if (feature.type == "factor") {
        features = data.frame(Cluster=clusters.assignment)
    } else if (feature.type == "binary") {
        features = clustersToBinaryFeatures(clusters.assignment, clusters)
    } else if (feature.type == "distance") {
        features = clustersToNumericFeatures(dataset, centers, measure, covMat)
    } else if (feature.type == "binaryDist") {
        bin.features = clustersToBinaryFeatures(clusters.assignment, clusters)
        dist.features = clustersToNumericFeatures(dataset, centers, measure, covMat)
        features = bin.features * dist.features;
    } else if (feature.type == "revDistSquared") {
        features = clustersToNumericFeatures(dataset, centers, measure, covMat)
        features = 1 / features^2;
        features[features == Inf] = max(features[features < Inf]) + 1
    }

    if(newFeaturesOnly) {
        cbind(features, Class=dataset[, "Class"])
    } else {
        cbind(dataset, features)
    }
}

evaluateFeatures <- function(dataset) {
    #ig = information.gain(Class~., dataset)
    #gr = gain.ratio(Class~., dataset)
    fs = sapply(dataset[, !names(dataset) %in% "Class"], fisher.score, c=dataset$Class)
    gains = data.frame(fs)
    colnames(gains) = c("Fisher score")
    
    gains
}

plotCohesionVsPurity <- function(class, clusters, wss) {
    cluster.purity = data.frame(Class=class, Cluster=clusters) %>%
        dplyr::group_by(Cluster, Class) %>%
        dplyr::count() %>%
        dplyr::summarise(m = max(n), s = sum(n)) %>%
        dplyr::mutate(Purity = m / s) %>%
        dplyr::select(Cluster, Purity)
    
    cohesionAndPurity = data.frame(cohesion=wss, purity=cluster.purity$Purity)
    
    p = ggplot(cohesionAndPurity, aes(x=cohesion, y=purity)) + geom_point()
    
    ggplotly(p + theme(plot.margin = unit(c(1,0,1,2), "lines")))
}

getDistanceMatrix <- function(dataset, measure = "euclidean") {
    if(is.dataset.numeric(dataset)) {
        if(measure == "euclidean" | !isMahalanobian(dataset[, !names(dataset) %in% "Class"])) {
            distMatrix = abs(negDistMat(dataset[, !names(dataset) %in% "Class"], r=2))
        } else if(measure == "mahalanobis") {
            covMat = cov(dataset[, !names(dataset) %in% "Class"])
            distMatrix = apply(dataset[, !names(dataset) %in% "Class"], 1, function(x) { 
                mahalanobis(dataset[, !names(dataset) %in% "Class"], x, covMat) 
            })
        }
    } else {
        distMatrix = outer(1:nrow(dataset), 1:nrow(dataset), Vectorize(function(i, j) {
            sum((dataset[i, ] != dataset[j, ])*1)
        }))
        
        distMatrix = as.matrix(distMatrix)
        colnames(distMatrix) = rownames(dataset)
        rownames(distMatrix) = rownames(dataset)
    }
    
    distMatrix
}

kClustering <- function(dataset, k) {
    result = kmeans(dataset, k)
    
    list(model=result, wss=result$withinss)
}

affinityPropagation <- function(dataset, measure) {
    negDistMatrix = getDistanceMatrix(dataset, measure)*-1
    
    result = apcluster(negDistMatrix, maxits=10000)
    
    wss = sapply(1:length(result@exemplars), function(i, ap) {
        sum(abs(negDistMatrix[ap@clusters[[i]], ap@exemplars[1]]))
    }, ap=result)
    
    list(model=result, wss=wss)
}

trainClassifier <- function(dataset, classifier, folds, repeats) {
    fitControl = trainControl(method = "repeatedcv",
                               number = folds,
                               repeats = repeats)
    
    capture.output(
        if(classifier == "multinom") {
            fit = train(x = dataset[!names(dataset) %in% "Class"],
                        y = dataset[, "Class"],
                        method = classifier,
                        MaxNWts = 10000000,
                        trControl = fitControl,
                        tuneLength = 10)
        } else {
            fit = train(x = dataset[!names(dataset) %in% "Class"],
                        y = dataset[, "Class"],
                        method = classifier,
                        trControl = fitControl,
                        tuneLength = 10)
            
        }
    )
    
    fit
}

evaluateClassifier <- function(fit, testSet) {
    predictions = predict.train(object=fit, testSet[!names(testSet) %in% "Class"], type="raw")
    
    confusionMatrix(predictions, testSet[, "Class"])
}

assignClusters <- function(testSet, centers) {
    testSet.isNumeric = is.dataset.numeric(testSet)
    
    result = apply(testSet[, !names(testSet) %in% "Class"], 1, 
                   function (testItem, centers) {
                       distances = apply(centers, 1, function(v1, v2) {
                           ifelse(testSet.isNumeric, dist(rbind(v1, v2)), sum((v1!=v2)*1))
                           }, v2=testItem)
                       bestCluster = which.min(distances)[[1]]
                       }, centers=centers)
    
    result
}

trainTestEvaluate <- function(trainSet, testSet, classifier, folds, repeats) {
    ### Prepare classifier
    fit = trainClassifier(trainSet, classifier, folds, repeats)
    
    ### Test and evaluate on training data
    train.predictions = predict.train(object=fit, trainSet[!names(trainSet) %in% "Class"], type="raw")
    train.cm = confusionMatrix(train.predictions, trainSet[, "Class"])
    
    ### Test and evaluate on testing data
    test.predictions = predict.train(object=fit, testSet[!names(testSet) %in% "Class"], type="raw")
    test.cm = confusionMatrix(test.predictions, testSet[, "Class"])

    list(trainAccuracy=train.cm$overall[["Accuracy"]], testAccuracy=test.cm$overall[["Accuracy"]])
}

saveResults <- function(output, dataset, classifier, clusterer, trainAccuracy, testAccuracy, k) {
    result.row = cbind(Dataset=dataset,
                       Classifier=classifier,
                       Clustering=clusterer,
                       K=k,
                       TrainAccuracy=trainAccuracy,
                       TestAccuracy=testAccuracy)
    
    header = FALSE
    if(!file.exists(output)){
        header = TRUE
    }
    
    write.table(x=result.row, file=output, 
                row.names=FALSE, col.names=header, append=TRUE, quote=FALSE, sep=",")
    
    result.row
}

addClusteringFeatures <- function(clustering, trainSet, testSet, feature.type, scaling, noClusters,
                                  measure, clusteringPerClass, newFeaturesOnly, semi_supervised) {
    
    if(semi_supervised) {
        noTrainingExamples = nrow(trainSet)
        trainSet = rbind(trainSet, testSet)
        testSet = testSet[0, ]
    }
    
    if(clustering == "km") {
        result = addKMeansFeatures(trainSet, testSet, feature.type, scaling, measure, clusteringPerClass, noClusters, newFeaturesOnly)
    } else if(clustering == "ap") {
        result = addAffinityPropagationFeatures(trainSet, testSet, feature.type, scaling, measure, clusteringPerClass, newFeaturesOnly)
    } else if(clustering == "sc") {
        result = addSpectralClusteringFeatures(trainSet, testSet, feature.type, scaling, measure, noClusters, newFeaturesOnly)
    } else if(clustering == "rnd") {
        result = addRandomFeatures(trainSet, testSet, feature.type, scaling, measure, noClusters, newFeaturesOnly, uniform=FALSE)
    } else if(clustering == "unf") {
        result = addRandomFeatures(trainSet, testSet, feature.type, scaling, measure, noClusters, newFeaturesOnly, uniform=TRUE)
    } else {
        stop("The only viable clustering options are km (kMeans), ap (Affinity Propagation), sc (Spectral Clustering), and rnd (random points).")
    }
    
    if(semi_supervised) {
        result$test = result$train[(noTrainingExamples+1):nrow(result$train), ]
        result$train = result$train[1:noTrainingExamples, ]
    }
    
    result
}

addRandomFeatures <- function(trainSet, testSet, feature.type, scaling, measure,
                              noClusters, newFeaturesOnly, uniform=FALSE) {

    if(feature.type != "distance") {
        stop("Feature types other than numeric are not supported for random features!")
    }
    
    mins = apply(trainSet[, !names(trainSet) %in% "Class"], 2, min)
    maxs = apply(trainSet[, !names(trainSet) %in% "Class"], 2, max)
    if(uniform) {
        centers = as.data.frame(runifpointx(noClusters, boxx(rbind(mins, maxs)))$data)
        colnames(centers) = colnames(trainSet[, !names(trainSet) %in% "Class"])
    } else {
        centers = t(replicate(noClusters, apply(cbind(mins, maxs), 1, function(x) { sample(x[1]:x[2], size = 1) })))
    }
    cluster.assignment = NA
    
    addFeatures(trainSet, testSet, feature.type, scaling,
                cluster.assignment,
                centers, 
                assignClusters(testSet, centers),
                measure, newFeaturesOnly)
}

addSpectralClusteringFeatures <- function(trainSet, testSet, feature.type, scaling, 
                                          measure, noClusters, newFeaturesOnly) {
    
    result.sc = specc(as.matrix(trainSet[, !names(trainSet) %in% "Class"]), centers=noClusters)
    centers = result.sc@centers
    
    addFeatures(trainSet, testSet, feature.type, scaling, 
                result.sc@.Data,
                centers, 
                assignClusters(testSet, centers),
                measure, newFeaturesOnly)
}

addAffinityPropagationFeatures <- function(trainSet, testSet, feature.type, scaling,
                                           measure, clusteringPerClass, newFeaturesOnly) {
    centers = data.frame()
    if(clusteringPerClass) {
        classes = unique(trainSet[, "Class"])
        for(c in classes) {
            if(nrow(trainSet[trainSet["Class"] == c, !names(trainSet) %in% "Class"]) == 1) {
                centers = rbind(centers, trainSet[trainSet["Class"] == c, !names(trainSet) %in% "Class"])
            } else {
                partial.result.ap = affinityPropagation(trainSet[trainSet["Class"] == c, !names(trainSet) %in% "Class"], measure)$model;
                centers = rbind(centers,  trainSet[partial.result.ap@exemplars, !names(trainSet) %in% c("Class")])
            }
        }
    } else {
        result.ap = affinityPropagation(trainSet[, !names(trainSet) %in% "Class"], measure)$model;
        centers = trainSet[result.ap@exemplars, !names(trainSet) %in% c("Class")]
    }
    
    addFeatures(trainSet, testSet, feature.type, scaling, 
                result.ap@idx, 
                centers, 
                result.ap@exemplars[assignClusters(testSet, trainSet[sort(result.ap@exemplars), !names(trainSet) %in% c("Class", "cluster")])],
                measure, newFeaturesOnly);
}

addKMeansFeatures <- function(trainSet, testSet, feature.type, scaling, measure,
                              clusteringPerClass,  noClusters, newFeaturesOnly) {
    centers = data.frame()
    if(clusteringPerClass) {
        classes = unique(trainSet[, "Class"])
        for(c in classes) {
            noClusters = getNumberOfClusters(trainSet[trainSet["Class"] == c, !names(trainSet) %in% "Class"])
            partial.result.km = kmeans(trainSet[trainSet["Class"] == c, !names(trainSet) %in% "Class"], noClusters)
            centers = rbind(centers, partial.result.km$centers)
        }
    } else {
        result.km = kmeans(trainSet[, !names(trainSet) %in% "Class"], noClusters);
        centers = result.km$centers
    }

    addFeatures(trainSet, testSet, feature.type, scaling,
                result.km$cluster, 
                centers, 
                assignClusters(testSet, centers),
                measure, newFeaturesOnly);
}

addFeatures <- function(trainSet, testSet, feature.type, scaling, clusters, centers, 
                        cluster.assignment, measure, newFeaturesOnly) {
    covMat = NULL
    if(measure == "mahalanobis") {
        covMat = cov(trainSet[, !names(trainSet) %in% "Class"])
    }
    
    result.train = convertClusteringFeatures(trainSet, feature.type, clusters, 
                                         centers=centers, measure=measure, covMat=covMat, newFeaturesOnly=newFeaturesOnly)
    
    result.test = convertClusteringFeatures(testSet, feature.type,
                                        cluster.assignment, sort(unique(clusters)),
                                        centers=centers, measure, covMat, newFeaturesOnly)
    
    if(scaling) {
        newFeatureNames = paste0("C", 1:nrow(centers))
        fs = sapply(result.train[newFeatureNames], fisher.score, c=result.train$Class)
        result.train[newFeatureNames] = sweep(result.train[newFeatureNames], MARGIN=2, fs, "*")
        result.test[newFeatureNames] = sweep(result.test[newFeatureNames], MARGIN=2, fs, "*")
    }
    
    list(train=result.train, test=result.test, k=nrow(centers))
}

showResultsSummary <- function(result, method="ap", by="classifier") {
    no = result %>%
        dplyr::filter(FeatureType == "numeric", Clustering %in% c("no")) %>%
        dplyr::select(Dataset, Classifier, Accuracy)
    
    ap = result %>%
        dplyr::filter(FeatureType == "numeric", Clustering %in% c(method)) %>%
        dplyr::select(Dataset, Classifier, Accuracy)
    
    result = c()
    if(by == "classifier") {
        result = no %>%
            dplyr::full_join(ap, by = c("Dataset", "Classifier")) %>%
            dplyr::group_by(Classifier) %>%
            dplyr::summarise(Better = sum(Accuracy.y > Accuracy.x), Worse = sum(Accuracy.y < Accuracy.x), Equal = sum(Accuracy.y == Accuracy.x)) %>%
            dplyr::arrange(-Better, Worse)
    }else {
        result = no %>%
            dplyr::full_join(ap, by = c("Dataset", "Classifier")) %>%
            dplyr::group_by(Dataset) %>%
            dplyr::summarise(Better = sum(Accuracy.y > Accuracy.x), Worse = sum(Accuracy.y < Accuracy.x), Equal = sum(Accuracy.y == Accuracy.x)) %>%
            dplyr::arrange(-Better, Worse)
    }
    
    result
}
