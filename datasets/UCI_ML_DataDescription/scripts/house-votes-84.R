getData <- function(path)
{
    files <- "house-votes-84.data"
    files <- paste(path, files, sep="/")
    dat <- read.table(files[1],
        sep=",",
        comment.char="",
        na.strings="",
        stringsAsFactors=FALSE, strip.white=TRUE)
    dat[dat == "?"] <- "-"
    dat
}

