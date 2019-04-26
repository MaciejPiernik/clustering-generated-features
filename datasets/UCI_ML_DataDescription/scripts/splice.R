getData <- function(path)
{
    files <- "splice.data"
    files <- paste(path, files, sep="/")
    dat <- read.table(files[1],
        sep=",",
        comment.char="",
        na.strings="",
        stringsAsFactors=FALSE, strip.white=TRUE)
    aux <- strsplit(dat[, 3], "")
    names(aux) <- 1:length(aux)
    aux <- data.frame(t(data.frame(aux, stringsAsFactors=FALSE)), stringsAsFactors=FALSE)
    dat <- data.frame(dat[1:2], aux, stringsAsFactors=FALSE)
    dat
}

