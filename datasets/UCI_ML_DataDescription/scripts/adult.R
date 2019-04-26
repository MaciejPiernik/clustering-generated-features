getData <- function(path)
{
    files <- c("adult.data", "adult.test")
    files <- paste(path, files, sep="/")
    dat1 <- read.table(files[1],
        sep=",",
        comment.char="|",
        na.strings="?",
        stringsAsFactors=FALSE, strip.white=TRUE)
    dat2 <- read.table(files[2],
        skip=1,
        sep=",",
        comment.char="|",
        na.strings="?",
        stringsAsFactors=FALSE, strip.white=TRUE)
    ncol <- ncol(dat2)
    aux <- substr(dat2[, ncol], nchar(dat2[, ncol]), nchar(dat2[, ncol]))
    if (all(aux == ".")) {
        dat2[, ncol] <- substr(dat2[, ncol], 1, nchar(dat2[, ncol])-1)
    }
    dat <- rbind(dat1, dat2)
    rm(dat1, dat2)
    dat
}

