

ebi_url = paste0(
    "https://www.ebi.ac.uk/ena/portal/api/search?result=sequence&", 
    "query=country=%22Greece%22&fields=",
    "accession,",
    "country,",
    # "description,",
    "first_public,",
    "isolation_source,",
    "location,",
    "tax_division,",
    "scientific_name"
)