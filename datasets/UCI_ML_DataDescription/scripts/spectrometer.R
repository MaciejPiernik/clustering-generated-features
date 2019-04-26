getData <- function(path)
{
    files <- "lrs.data"
    files <- paste(path, files, sep="/")
    dat <- read.table(files[1],
        sep="\n",
        comment.char="",
        na.strings="",
        stringsAsFactors=FALSE, strip.white=TRUE)
    row <- dat[, 1]
    bcase <- grep("(", row, fixed=TRUE)
    ecase <- grep(")", row, fixed=TRUE)
    case <- data.frame(lab="", matrix(nrow=length(bcase), ncol=102), stringsAsFactors=FALSE)
    for (i in 1:length(bcase)) {
        aux <- paste(row[bcase[i]:ecase[i]], collapse=" ")
        aux <- gsub("(", "", aux, fixed=TRUE)
        aux <- gsub(")", "", aux, fixed=TRUE)
        aux <- sub("^ ", "", aux)
        aux <- strsplit(aux, " ", fixed=TRUE)[[1]]
        stopifnot(length(aux) == 103)
        case$lab[i] <- aux[1]
        case[i,2:103] <- as.double(aux[-1])
    }
    data.frame(case[-c(1,2)], case[2], stringsAsFactors=FALSE)
}

