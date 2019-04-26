getData <- function(path)
{
    files <- "vowel-context.data"
    files <- paste(path, files, sep="/")
    dat <- read.table(files[1],
        comment.char="",
        na.strings="",
        stringsAsFactors=FALSE, strip.white=TRUE)
    dat
}

