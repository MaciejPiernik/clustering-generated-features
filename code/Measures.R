library(igraph)

degree.neg <- function(adj.matrix, normalize = TRUE) {
    result <- rep(1, nrow(adj.matrix)) %*% adj.matrix
    
    if (normalize) {
        result <- normalize.min.max(result)   
    }
    
    as.vector(result)
}

status <- function(adj.matrix, n_iter = 10000, normalize = TRUE) {
    result <- rep(1, nrow(adj.matrix))
    prev <- rep(0, nrow(adj.matrix))
    for (i in 1:n_iter) {
        result <- result %*% adj.matrix
        if(max(abs(result)) == 0) {
            break
        }
        result <- result / max(abs(result))
        if (all(prev == result)) {
            print(paste(i, "iterations"))
            break
        }
        prev <- result
    }
    
    if (normalize) {
        result <- normalize.min.max(result)   
    }
    
    as.vector(result)
}

PN <- function(adj.matrix, normalize = TRUE) {
    n <- nrow(adj.matrix)
    
    V1 <- rep(1, n)
    I <- diag(n)
    P <- (adj.matrix > 0) * 1
    N <- (adj.matrix < 0) * 1
    A <- P - 2 * N
    
    result <- solve(I - 1 / (2*n - 2) * A) %*% V1
    
    if (normalize) {
        result <- normalize.min.max(result)   
    }
    
    as.vector(result)
}

clustering.coefficient.neg <- function(adj.matrix, normalize = TRUE){
    result <- rep(0, nrow(adj.matrix))
    
    result <- apply(adj.matrix, 1, function(x) {
        r <- 0
        
        ids <- cbind(expand.grid(1:nrow(adj.matrix), 1:nrow(adj.matrix)), rep(0, nrow(adj.matrix) * nrow(adj.matrix)))
        k <- sum((x != 0) * 1)
        if (k == 0 || k == 1) {
            r <- 1
        }
        else {
            ids[, 3] <- (x[ids[, 1]] + x[ids[, 2]] + adj.matrix[as.matrix(ids[, 1:2])]) * ((x[ids[, 1]] * x[ids[, 2]] * adj.matrix[as.matrix(ids[, 1:2])]) != 0)
            r <- sum(ids[, 3]) / (3 * (k * (k - 1)))
        }
        
        r
    })
    
    if (normalize) {
        result <- normalize.min.max(result)   
    }
    
    as.vector(result)
}

normalize.min.max <- function(d) {
    if (max(abs(d)) == 0) {
        result <- rep(0, length(d))
    }
    else if(max(d) == min(d)) {
        result <- rep(1, length(d))
    }
    else {
        result <- d / max(abs(d))
        # result <- (d - min(d)) / (max(d) - min(d))
    }
    
    result
}
