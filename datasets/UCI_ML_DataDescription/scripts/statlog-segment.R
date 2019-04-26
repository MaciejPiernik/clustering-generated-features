getData <- function(path)
{
    files <- "segment.dat"
    files <- paste(path, files, sep="/")
    dat <- read.table(files[1],
        comment.char="",
        na.strings="",
        stringsAsFactors=FALSE, strip.white=TRUE)
    dat
}

