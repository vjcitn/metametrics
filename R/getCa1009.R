
#https://s3.amazonaws.com/biocfound-metadata/ca1009.zip
#https://s3.amazonaws.com/biocfound-metadata/ds_can1009b.rda

remote_doczip = function() "https://s3.amazonaws.com/biocfound-metadata/ca1009.zip"
remote_DocSet = function()  "https://s3.amazonaws.com/biocfound-metadata/ds_can1009b.rda" 

cameta_check_cache_doczip = function( cache = 
    BiocFileCache::BiocFileCache()) {
  allr = BiocFileCache::bfcinfo(cache)$rname
  remote_doczip() %in% allr
}
cameta_check_cache_DocSet = function( cache = 
    BiocFileCache::BiocFileCache()) {
  allr = BiocFileCache::bfcinfo(cache)$rname
  remote_DocSet() %in% allr
}
 

#' retrieve metadata examples from AWS S3 to BiocFileCache
#' @export
putCa1009 = function(cache = BiocFileCache::BiocFileCache()) {
  if (!requireNamespace("BiocFileCache")) 
        stop("install BiocFileCache to use this function")
    if (!cameta_check_cache_doczip(cache)) 
        message("adding zipped CSVs to local cache, future invocations will use local image")
    BiocFileCache::bfcrpath(cache, remote_doczip())
    if (!cameta_check_cache_DocSet(cache)) 
        message("adding DocSet RDS to local cache, future invocations will use local image")
    BiocFileCache::bfcrpath(cache, remote_DocSet())
}

#' @export
DocSet_ca1009 = function(cache = BiocFileCache::BiocFileCache()) {
    if (!cameta_check_cache_DocSet(cache)) stop("run putCa1009 to populate BiocFileCache instance")
    ds = get(load(BiocFileCache::bfcrpath(cache, remote_DocSet())))
    assign("zipf", csvs_ca1009(), envir=environment(ds@doc_retriever))
    ds
}

#' @export
csvs_ca1009 = function(cache = BiocFileCache::BiocFileCache()) {
    if (!cameta_check_cache_DocSet(cache)) stop("run putCa1009 to populate BiocFileCache instance")
    BiocFileCache::bfcrpath(cache, remote_doczip())
}

  
