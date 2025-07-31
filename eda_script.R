# EDA 

# libraries:
library(tidyverse)
library(summarytools)


# IMPORT DATA AND FIRST CHECK ------------------------------------------------------------------

# read data:
pa <- read_csv("data/raw_data/product_alias.csv")
rp <- read_csv("data/raw_data/raw_product.csv")

# check data:
glimpse(pa)
glimpse(rp)

# summary:
view(dfSummary(pa))
view(dfSummary(rp))



# FIRST CLEAN -------------------------------------------------------------

# product_alias:
# remove duplicates in product_alias and select only relevant columns:
pa_c <- pa |> 
    select(product_id, mapped_product) |> 
    distinct()
 
# convert product_id to character and mapped_product to upper case: 
# (always good to have IDs as character)
# upper case for mapped_product to ensure consistency for the mapping:

pa_c <- pa_c |> 
    mutate(product_id = as.character(product_id),
           mapped_product = str_to_upper(mapped_product)) |> 
    arrange(mapped_product)



# raw_product:
# remove duplicates and the 4 missing values in raw_product:
rp_c <- rp |> 
    filter(!is.na(raw_product)) |> 
    distinct()


rp_c <- rp_c |> 
    mutate(provider_id = as.character(provider_id),
           raw_product = str_to_upper(raw_product)) |> 
    arrange(raw_product)



# first match

j <- left_join(rp_c, pa, by = c("raw_product" = "alias"))

match <- j |> 
    filter(!is.na(mapped_product)) |> 
    select(raw_product, mapped_product) |> 
    distinct()
