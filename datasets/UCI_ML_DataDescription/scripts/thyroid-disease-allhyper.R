getData <- function(path)
{
    files <- c("allhyper.data", "allhyper.test")
    files <- paste(path, files, sep="/")
    dat1 <- read.table(files[1],
        sep=",",
        comment.char="|",
        na.strings="?",
        stringsAsFactors=FALSE, strip.white=TRUE)
    dat2 <- read.table(files[2],
        sep=",",
        comment.char="|",
        na.strings="?",
        stringsAsFactors=FALSE, strip.white=TRUE)
    dat <- rbind(dat1, dat2)
    rm(dat1, dat2)
    ncol <- ncol(dat)
    aux <- substr(dat[, ncol], nchar(dat[, ncol]), nchar(dat[, ncol]))
    if (all(aux == ".")) {
        dat[, ncol] <- substr(dat[, ncol], 1, nchar(dat[, ncol])-1)
    }
    dat
}

