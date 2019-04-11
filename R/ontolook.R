#' create through downloads a tibble amalgamating terms in ORDO HP UBERON DOID NCIT
#' @return tibble
#' @author Sean Davis, minor mods by VJ Carey
#' @note `load_ontolookup` will retrieve an April 2019 snapshot of the data in a tibble from AWS S3 or local cache
#' @examples
#' if (interactive()) {
#'   if (isTRUE(askYesNo("This will perform a download of 5 ontologies including NCIT, are you sure you want to proceed?"))) {
#'       cur_ontolook = make_ontolookup()
#'     cur_ontolook
#'       }
#'  }
#' @export
make_ontolookup = function() {
 if (!requireNamespace("tidyverse")) stop("install tidyverse to use this function")
 build_ontology_table = function(ontology_name) {
     destfile = paste0(ontology_name,".csv.gz")
     download.file(sprintf("http://data.bioontology.org/ontologies/%s/download?apikey=8b5b7825-538d-40e0-9e9e-5ab9274a9aeb&download_format=csv", ontology_name),
                   destfile = destfile)
     tmptab = read.csv(destfile, header = TRUE, stringsAsFactors = FALSE)[,1:8]
     tmptab$ontology = ontology_name
     unlink(destfile)
     return(as_tibble(tmptab))
 }
 
 bind_rows(build_ontology_table('ORDO'),
                        build_ontology_table('HP'),
                        build_ontology_table('UBERON'),
                        build_ontology_table('DOID'),
                        build_ontology_table('NCIT'))
}

#' retrieve a snapshot of terms in ORDO HP UBERON DOID NCIT
#' @param cache instance of `BiocFileCache`, defaults to `BiocFileCache::BiocFileCache()`
#' @return a data.frame
#' @examples
#' if (interactive()) head(load_ontolookup())
#' @export
load_ontolookup = function(cache = BiocFileCache::BiocFileCache()) {
  if (!requireNamespace("tibble")) stop("please install tibble package to use this function")
  resname = "https://s3.amazonaws.com/biocfound-metadata/ontolookup.rda"
  allr = BiocFileCache::bfcinfo(cache)$rname
  if (!(resname %in% allr)) message("one time retrieval for ", resname)
  get(load(BiocFileCache::bfcrpath(cache, resname)))
}

