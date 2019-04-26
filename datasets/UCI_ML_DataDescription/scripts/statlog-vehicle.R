getData <- function(path)
{
    files <- c("xaa.dat", "xab.dat", "xac.dat", "xad.dat", "xae.dat", "xaf.dat", "xag.dat", "xah.dat", "xai.dat")
    files <- paste(path, files, sep="/")
    dat <- vector("list", length=length(files))
    for (i in seq.int(along.with=files)) {
        dat[[i]] <- read.table(files[i],
            comment.char="",
            na.strings="",
            stringsAsFactors=FALSE, strip.white=TRUE)
    }
    do.call("rbind", dat)
}

