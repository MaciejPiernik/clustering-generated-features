getData <- function(path)
{
    files <- "flare.data2"
    files <- paste(path, files, sep="/")
    dat <- read.table(files[1],
        skip=1,
        comment.char="",
        na.strings="",
        stringsAsFactors=FALSE, strip.white=TRUE)
    dat
}

