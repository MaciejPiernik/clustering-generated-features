getData <- function(path)
{
    files <- "auto-mpg.data"
    files <- paste(path, files, sep="/")
    dat <- read.table(files[1],
        comment.char="",
        na.strings="?",
        stringsAsFactors=FALSE, strip.white=TRUE)
    dat
}

