


library(data.table)
library(stringr)

d0 = fread(
    paste0(
        "https://www.ebi.ac.uk/ena/portal/api/search?result=sequence",
        "&query=country=%22Greece%22",
        "&fields=",
        "accession,country,first_public,",
        "altitude,location,",
        "isolation_source,host,host_tax_id,",
        "tax_division,tax_id,scientific_name,",
        "tag,keywords,topology"
    )
)

fix_taxonomic_division <- function(q) {
    
    q$tax_division2 = q$tax_division |>
        str_replace_all("PRO", "Prokaryota") |>
        str_replace_all("VRL", "Virus") |>
        str_replace_all("MAM", "Mammalia") |>
        str_replace_all("INV", "Invertebrates") |>
        str_replace_all("VRT", "Vertebrates") |>
        str_replace_all("PLN", "Plantae") |>
        str_replace_all("FUN", "Fungi") |>
        str_replace_all("HUM", "Homo sapiens") |>
        str_replace_all("ENV", "Environment") |>
        str_replace_all("ROD", "Rodentia") |>
        str_replace_all("MUS", "Mus") |>
        str_replace_all("PHG", "Phage") |>
        str_replace_all("UNC", "Unclassified")
    
    return(q)
    
    
}

fix_tag <- function(q) {
    
    t = q$tag |>
        str_split("\\;", simplify = TRUE) |>
        as.data.frame() |>
        setDT()
    
    colnames(t) = paste0("tag", ncol(t) |> seq_len())
    
    q = cbind(q, t)
    
    return(q)
    
}

fix_location <- function(q) {
    
    q$lat = q$location |>
        str_split_i("N", 1) |>
        str_squish() |>
        as.numeric()
    
    q$long = q$location |>
        str_split_i("N", 2) |>
        str_remove_all("E") |>
        str_squish() |>
        as.numeric()
    
    
    
    return(q)
    
}

fix_country <- function(q) {
    
    # create region column ---------------
    
    q$region = q$country |> 
        str_split("\\:", n = 2) |> 
        lapply(function(x) x[2]) |> 
        unlist() |> 
        str_remove_all("\\'|\\=|\\[|\\]|\\>")
    
    q$country = q$country |> str_split_i("\\:", 1)
    
    index = q$country |> str_detect("Greece") |> which()
    q = q[index]
    
    q$country = "Greece"
    
    # split to known and unknow coordinates -------------
    
    # a = q[which(!is.na(lat) & !is.na(long))]
    # b = q[which(is.na(lat) | is.na(long))]
    # 
    a = q[which(is.na(region))]
    b = q[which(!is.na(region))]
    
    
    t = b$region |> 
        str_remove_all("[a-z|A-Z]|[0-9]|\\.|\\(|\\)|\\ |\\;|\\~") |>
        str_squish() |>
        str_split("") |>
        unlist() |>
        unique() |>
        paste(collapse = "|")
    
    b$region = b$region |> 
        str_replace_all(t, "\\;") |> 
        str_split("\\;") |>
        lapply(function(x) x |> str_squish() |> paste(collapse = "; ")) |>
        unlist() |>
        str_to_title()
    
    
    # b$region |> 
    #     str_remove_all("[a-z]|[A-Z]|\\.|\\(|\\)") |> 
    #     unique()
    
    
    out = rbind(a, b)
    
    return(out)
    
    
}


d1 = d0 |>
    fix_taxonomic_division() |>
    fix_tag() |>
    fix_location() |>
    fix_country()


fwrite(
    d1, "inst/extdata/data_ena_clean.tsv",
    row.names = FALSE, quote = FALSE, sep = "\t"
)


# lexicon <- function(string) {
# 
#     string |>
#         str_replace_all("Rethymnon|Rethymno|Rethimno", "Rethimnon") |>
#         str_replace_all("Carpathos")
# 
# 
# }
# 
# 
# retrieve_ebi_data <- function(string) {
# 
#     if( !RCurl::url.exists(string) ) stop(c("url ", string, " not accessible!"))
# 
#     df = string |> fread(verbose = FALSE)
# 
#     # correct scientific name
#     df$scientific_name = df$scientific_name |> str_squish() |> str_to_title()
# 
#     df$country = df$country |>
#         str_replace_all("-|\\[|\\]|\\(|\\)", " ") |>
#         str_squish()
# 
# 
#     df$region = df$country |>
#         str_split_i("\\:", 2) |>
#         str_squish() |>
#         str_to_title()
# 
#     df$country = df$country |> str_split_i("\\:", 1)
#     df$country = ifelse(df$country == "Greece Greece", "Greece", df$country)
# 
#     df = df[which(country == "Greece")]
# 
#     df$lat = df$location |>
#         str_split_i("N", 1) |>
#         str_squish() |>
#         as.numeric()
# 
#     df$lon = df$location |>
#         str_split_i("N", 2) |>
#         str_remove_all("E") |>
#         str_squish() |>
#         as.numeric()
# 
#     df$region = df$region |> lexicon()
# 
#     # part 2 --------------------------
# 
#     a = df[which( !is.na(lat) & !is.na(lon) )]
#     b = df[which( is.na(lat) | is.na(lon) )]
# 
#     for(i in seq_along(greece_cities$name)) {
# 
#         index = b$region |>
#             str_detect(greece_cities[i]$name) |>
#             which()
# 
#         b[index]$lat = greece_cities[i]$lat
#         b[index]$lon = greece_cities[i]$long
# 
#     }
# 
#     a = rbind(a, b[which( !is.na(lat) & !is.na(lon) )])
#     b = b[which(is.na(lat) | is.na(lon))]
# 
#     df = rbind(a, b)
# 
# }

