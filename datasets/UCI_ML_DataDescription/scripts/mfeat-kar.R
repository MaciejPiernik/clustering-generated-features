getData <- function(path)
{
    files <- "mfeat-kar"
    files <- paste(path, files, sep="/")
    dat <- read.table(files[1],
        comment.char="",
        na.strings="",
        stringsAsFactors=FALSE, strip.white=TRUE)
    cl <- rep(1:10, each=200)
    data.frame(dat, y=cl, stringsAsFactors=FALSE)
}

