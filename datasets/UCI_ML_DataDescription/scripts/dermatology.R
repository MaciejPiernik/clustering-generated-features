getData <- function(path)
{
    files <- "dermatology.data"
    files <- paste(path, files, sep="/")
    dat <- read.table(files[1],
        sep=",",
        comment.char="",
        na.strings="?",
        stringsAsFactors=FALSE, strip.white=TRUE)
    dat
}

