getData <- function(path)
{
    files <- c("soybean-large.data", "soybean-large.test")
    files <- paste(path, files, sep="/")
    dat1 <- read.table(files[1],
        sep=",",
        comment.char="",
        na.strings="?",
        stringsAsFactors=FALSE, strip.white=TRUE)
    dat2 <- read.table(files[2],
        sep=",",
        comment.char="",
        na.strings="?",
        stringsAsFactors=FALSE, strip.white=TRUE)
    rbind(dat1, dat2)
}

