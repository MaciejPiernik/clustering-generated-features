getData <- function(path)
{
    files <- c("horse-colic.data", "horse-colic.test")
    files <- paste(path, files, sep="/")
    dat1 <- read.table(files[1],
        comment.char="",
        na.strings="?",
        stringsAsFactors=FALSE, strip.white=TRUE)
    dat2 <- read.table(files[2],
        comment.char="",
        na.strings="?",
        stringsAsFactors=FALSE, strip.white=TRUE)
    rbind(dat1, dat2)
}

