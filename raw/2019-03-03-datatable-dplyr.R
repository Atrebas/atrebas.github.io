
## @knitr INTRODUCTION_EXAMPLE_DATA
## INTRODUCTION --------------------------------------------------------
## >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

## @knitr data1.1
library(data.table)
set.seed(1L)

## Create a data table
DT <- data.table(V1 = rep(c(1L, 2L), 5)[-10],
                V2 = 1:9,
                V3 = c(0.5, 1.0, 1.5),
                V4 = rep(LETTERS[1:3], 3))

class(DT)
DT

## @knitr data1.2
library(dplyr)
set.seed(1L)

## Create a data frame (tibble)
DF <- tibble(V1 = rep(c(1L, 2L), 5)[-10],
             V2 = 1:9,
             V3 = rep(c(0.5, 1.0, 1.5), 3),
             V4 = rep(LETTERS[1:3], 3))

class(DF)
DF



## @knitr BASICS
## BASIC OPERATIONS ----------------------------------------------------
## >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

## @knitr filterRows
## Filter rows ---------------------------------------------------------

## @knitr filterRows1.1
DT[3:4,]
DT[3:4] # same
## @knitr filterRows1.2
DF[3:4,]
slice(DF, 3:4) # same

## @knitr filterRows2.1
DT[!3:7,]
DT[-(3:7)] # same
## @knitr filterRows2.2
DF[-(3:7),]
slice(DF, -(3:7)) # same

## @knitr filterRows3.1
DT[V2 > 5]
DT[V4 %chin% c("A", "C")] # fast %in% for character
## @knitr filterRows3.2
filter(DF, V2 > 5)
filter(DF, V4 %in% c("A", "C"))

## @knitr filterRows4.1
DT[V1 == 1 & V4 == "A"]
# any logical criteria can be used
## @knitr filterRows4.2
filter(DF, V1 == 1, V4 == "A")
# any logical criteria can be used

## @knitr filterRows5.1
unique(DT)
unique(DT, by = c("V1", "V4")) # returns all cols
## @knitr filterRows5.2
distinct(DF) # distinct_all(DF)
distinct(DF, across(c(V1, V4))) # returns selected cols
# distinct_at(DF, vars(V1, V4))

## @knitr filterRows6.1
na.omit(DT, cols = 1:4)  # fast S3 method with cols argument
## @knitr filterRows6.2
tidyr::drop_na(DF, names(DF))

## @knitr filterRows7.1
DT[sample(.N, 3)] # .N = nb of rows in DT
DT[sample(.N, .N / 2)]
DT[frankv(-V1, ties.method = "dense") < 2]
## @knitr filterRows7.2
slice_sample(DF, n = 3)      # n random rows
# sample_n(DF, 3)
slice_sample(DF, prop = 0.5) # fraction of rows
# sample_frac(DF, 0.5)
DF %>% slice_max(V1, n = 1)
# top_n(DF, 1, V1)


# @knitr filterRows8.1
DT[V4 %like% "^B"]
DT[V2 %between% c(3, 5)]
DT[data.table::between(V2, 3, 5, incbounds = FALSE)]
DT[V2 %inrange% list(-1:1, 1:3)] # see also ?inrange
# @knitr filterRows8.2
filter(DF, grepl("^B", V4))
filter(DF, dplyr::between(V2, 3, 5))
filter(DF, V2 > 3 & V2 < 5)
filter(DF, V2 >= -1:1 & V2 <= 1:3)


## @knitr sortRows
## Sort rows -----------------------------------------------------------

## @knitr sortRows1.1
DT[order(V3)]  # see also setorder
## @knitr sortRows1.2
arrange(DF, V3)

## @knitr sortRows2.1
DT[order(-V3)]
## @knitr sortRows2.2
arrange(DF, desc(V3))

## @knitr sortRows3.1
DT[order(V1, -V2)]
## @knitr sortRows3.2
arrange(DF, V1, desc(V2))


## @knitr selectCols
## Select columns ------------------------------------------------------

## @knitr selectCols1.1
DT[[3]] # returns a vector
DT[, 3]  # returns a data.table
## @knitr selectCols1.2
DF[[3]] # returns a vector
DF[3]   # returns a tibble

## @knitr selectCols2.1
DT[, list(V2)] # returns a data.table
DT[, .(V2)]    # returns a data.table
# . is an alias for list
DT[, "V2"]     # returns a data.table
DT[, V2]       # returns a vector
DT[["V2"]]     # returns a vector
## @knitr selectCols2.2
select(DF, V2) # returns a tibble
pull(DF, V2, name = V4)   # returns a (named) vector
DF[, "V2"]        # returns a tibble
DF[["V2"]]        # returns a vector

## @knitr selectCols3.1
DT[, .(V2, V3, V4)]
DT[, list(V2, V3, V4)]
DT[, V2:V4] # select columns between V2 and V4
## @knitr selectCols3.2
select(DF, V2, V3, V4)
select(DF, V2:V4) # select columns between V2 and V4

## @knitr selectCols4.1
DT[, !c("V2", "V3")]
## @knitr selectCols4.2
select(DF, -V2, -V3)

## @knitr selectCols5.1
cols <- c("V2", "V3")
DT[, ..cols] # .. prefix means 'one-level up'
DT[, !..cols] # or DT[, -..cols]
## @knitr selectCols5.2
cols <- c("V2", "V3")
select(DF, !!cols) # unquoting
select(DF, -!!cols)

## @knitr selectCols6.1
cols <- paste0("V", 1:2)
cols <- union("V4", names(DT))
cols <- grep("V",   names(DT))
cols <- grep("3$",  names(DT))
cols <- grep(".2",  names(DT))
cols <- grep("^V1|X$",  names(DT))
cols <- grep("^(?!V2)", names(DT), perl = TRUE)
DT[, ..cols]
## @knitr selectCols6.2
select(DF, num_range("V", 1:2))
select(DF, V4, everything()) # reorder columns
select(DF, contains("V"))
select(DF, ends_with("3"))
select(DF, matches(".2"))
select(DF, one_of(c("V1", "X")))
select(DF, -starts_with("V2"))
# remove variables using "-" prior to function


## @knitr summarise
## Summarise data ------------------------------------------------------

## @knitr summarise1.1
DT[, sum(V1)]    # returns a vector
DT[, .(sum(V1))] # returns a data.table
DT[, .(sumV1 = sum(V1))] # returns a data.table
## @knitr summarise1.2
summarise(DF, sum(V1)) # returns a tibble
summarise(DF, sumV1 = sum(V1)) # returns a tibble

## @knitr summarise2.1
DT[, .(sum(V1), sd(V3))]
## @knitr summarise2.2
summarise(DF, sum(V1), sd(V3))

## @knitr summarise3.1
DT[, .(sumv1 = sum(V1),
       sdv3  = sd(V3))]
## @knitr summarise3.2
DF %>%
  summarise(sumv1 = sum(V1),
            sdv3  = sd(V3))

## @knitr summarise4.1
DT[1:4, sum(V1)]
## @knitr summarise4.2
DF %>%
  slice(1:4) %>%
  summarise(sum(V1))

## @knitr summarise5.1
DT[, data.table::first(V3)]
DT[, data.table::last(V3)]
DT[5, V3]
DT[, uniqueN(V4)]
uniqueN(DT)
## @knitr summarise5.2
summarise(DF, dplyr::first(V3))
summarise(DF, dplyr::last(V3))
summarise(DF, nth(V3, 5))
summarise(DF, n_distinct(V4))
n_distinct(DF)


## @knitr cols
## Add/Update/Delete columns --------------------------------------------

## @knitr cols1.1
DT[, V1 := V1^2]
DT
## @knitr cols1.2
DF <- DF %>% mutate(V1 = V1^2)
DF

## @knitr cols2.1
DT[, v5 := log(V1)][] # adding [] prints the result
## @knitr cols2.2
DF <- mutate(DF, v5 = log(V1))
# see ?mutate for options (.keep, .before, ...)

## @knitr cols3.1
DT[, c("v6", "v7") := .(sqrt(V1), "X")]

DT[, ':='(v6 = sqrt(V1),
          v7 = "X")]     # same, functional form
## @knitr cols3.2
DF <- mutate(DF, v6 = sqrt(V1), v7 = "X")

## @knitr cols4.1
DT[, .(v8 = V3 + 1)]
## @knitr cols4.2
transmute(DF, v8 = V3 + 1)

## @knitr cols5.1
DT[, v5 := NULL]
## @knitr cols5.2
DF <- select(DF, -v5)

## @knitr cols6.1
DT[, c("v6", "v7") := NULL]
## @knitr cols6.2
DF <- select(DF, -v6, -v7)

## @knitr cols7.1
cols <- c("V3")
DT[, (cols) := NULL] # ! not DT[, cols := NULL]
## @knitr cols7.2
cols <- c("V3")
DF <- select(DF, -one_of(cols))

## @knitr cols8.1
DT[V2 < 4, V2 := 0L]
DT
## @knitr cols8.2
DF <- mutate(DF, V2 = base::replace(V2, V2 < 4, 0L))
DF


## @knitr by
## by ------------------------------------------------------------------

## @knitr by1.1
# one-liner:
DT[, .(sumV2 = sum(V2)), by = "V4"]
# reordered and indented:
DT[, by = V4,
     .(sumV2 = sum(V2))]
# 
## @knitr by1.2
DF %>%
  group_by(V4) %>%
  summarise(sumV2 = sum(V2))
# ungrouped output

## @knitr by2.1
DT[, keyby = .(V4, V1),
     .(sumV2 = sum(V2))]
## @knitr by2.2
DF %>%
  group_by(V4, V1) %>%
  summarise(sumV2 = sum(V2))
# output grouped by V4


## @knitr by3.1
DT[, by = tolower(V4),
     .(sumV1 = sum(V1))]
## @knitr by3.2
DF %>%
  group_by(tolower(V4)) %>%
  summarise(sumV1 = sum(V1))

## @knitr by4.1
DT[, keyby = .(abc = tolower(V4)),
     .(sumV1 = sum(V1))]
## @knitr by4.2
DF %>%
  group_by(abc = tolower(V4)) %>%
  summarise(sumV1 = sum(V1))

## @knitr by5.1
DT[, keyby = V4 == "A",
     sum(V1)]
## @knitr by5.2
DF %>%
  group_by(V4 == "A") %>%
  summarise(sum(V1))

## @knitr by6.1
DT[1:5,                # i
   .(sumV1 = sum(V1)), # j
   by = V4]            # by
## complete DT[i, j, by] expression!
## @knitr by6.2
DF %>%
  slice(1:5) %>%
  group_by(V4) %>%
  summarise(sumV1 = sum(V1))

## @knitr by7.1
DT[, .N, by = V4]
## @knitr by7.2
count(DF, V4)
DF %>%
  group_by(V4) %>%
  tally()
DF %>%
  group_by(V4) %>%
  summarise(n())
DF %>%
  group_by(V4) %>%
  group_size() # returns a vector

## @knitr by8.1
DT[, n := .N, by = V1][]
DT[, n := NULL] # rm column for consistency
## @knitr by8.2
add_count(DF, V1)
DF %>%
  group_by(V1) %>%
  add_tally()

## @knitr by9.1
DT[, data.table::first(V2), by = V4]
DT[, data.table::last(V2), by = V4]
DT[, V2[2], by = V4]
## @knitr by9.2
DF %>%
  group_by(V4) %>%
  summarise(dplyr::first(V2))
DF %>%
  group_by(V4) %>%
  summarise(dplyr::last(V2))
DF %>%
  group_by(V4) %>%
  summarise(dplyr::nth(V2, 2))



## @knitr GOING_FURTHER
## GOING_FURTHER -------------------------------------------------------
## >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

## @knitr advCols
## Advanced columns manipulation ---------------------------------------

## @knitr advCols1.1
DT[, lapply(.SD, max)]
## @knitr advCols1.2
DF %>% summarise(across(everything(), max))
# summarise_all(DF, max)

## @knitr advCols2.1
DT[, lapply(.SD, mean),
     .SDcols = c("V1", "V2")]
## @knitr advCols2.2
DF %>% summarise(across(c(V1, V2), mean))
# summarise_at(DF, c("V1", "V2"), mean)

## @knitr advCols3.1
DT[, by = V4,
     lapply(.SD, mean),
     .SDcols = c("V1", "V2")]
## using patterns (regex)
DT[, by = V4,
     lapply(.SD, mean),
     .SDcols = patterns("V1|V2|Z0")]
## @knitr advCols3.2
DF %>%
  group_by(V4) %>%
  summarise(across(c(V1, V2), mean))
# DF %>%
#   group_by(V4) %>%
#   summarise_at(c("V1", "V2"), mean)
DF %>%
  group_by(V4) %>%
  summarise(across(any_of(c("V1", "V2", "Z0")), mean))


## @knitr advCols4.1
DT[, by = V4,
     c(lapply(.SD, sum),
       lapply(.SD, mean))]
## @knitr advCols4.2
DF %>%
  group_by(V4) %>%
  summarise(across(everything(),
                   list(sum = sum, mean = mean)))
# columns named automatically
# DF %>%
#   group_by(V4) %>%
#   summarise_all(list(sum, mean))

## @knitr advCols5.1
DT[, lapply(.SD, mean),
     .SDcols = is.numeric]
foo <- function(x) {is.numeric(x) && mean(x) > 3}
DT[, lapply(.SD, mean),
   .SDcols = foo]
## @knitr advCols5.2
DF %>%
  summarise(across(where(is.numeric),
                   mean))
# summarise_if(DF, is.numeric, mean)
DF %>% summarise(across(where(~ is.numeric(.x) && mean(.x) > 3), 
                        mean))

## @knitr advCols6.1
DT[, lapply(.SD, rev)]
## @knitr advCols6.2
DF %>%
  mutate(across(everything(),
                rev))
# mutate_all(DF, rev)
# transmute_all(DF, rev)

## @knitr advCols7.1
DT[, lapply(.SD, sqrt),
     .SDcols = V1:V2]
DT[, lapply(.SD, exp),
     .SDcols = !"V4"]
## @knitr advCols7.2
DF %>% transmute(across(c(V1, V2),
                 sqrt))
# transmute_at(DF, c("V1", "V2"), sqrt)
DF %>% transmute(across(-any_of("V4"),
                 exp))
# transmute_at(DF, vars(-V4), exp)

## @knitr advCols8.1
DT[, c("V1", "V2") := lapply(.SD, sqrt),
     .SDcols = c("V1", "V2")]

cols <- setdiff(names(DT), "V4")
DT[, (cols) := lapply(.SD, "^", 2L),
     .SDcols = cols]
DT
## @knitr advCols8.2
DF <- DF %>%
  mutate(across(all_of(c("V1", "V2")), sqrt))
# DF <- mutate_at(DF, c("V1", "V2"), sqrt)
DF <- DF %>%
  mutate(across(-any_of("V4"),
                 ~ "^"(.x, 2L)))
DF
# DF <- mutate_at(DF, vars(-V4), "^", 2L)

## @knitr advCols9.1
DT[, .SD - 1,
     .SDcols = is.numeric]
DT
## @knitr advCols9.2
DF %>%
  transmute(across(where(is.numeric),
                   ~ '-'(., 1L)))
DF
# transmute_if(DF, is.numeric, list(~ '-'(., 1L)))

## @knitr advCols10.1
DT[, (cols) := lapply(.SD, as.integer),
     .SDcols = is.numeric]
## @knitr advCols10.2
DF <- DF %>%
  mutate(across(where(is.numeric),
         as.integer))
# DF <- mutate_if(DF, is.numeric, as.integer)

## @knitr advCols11.1
DT[, by = V4,
     .(V1[1:2], "X")]
## @knitr advCols11.2
DF %>%
  group_by(V4) %>%
  slice(1:2) %>%
  transmute(V1 = V1,
            V2 = "X")

## @knitr advCols12.1
DT[, {print(V1) #  comments here!
      print(summary(V1))
      x <- V1 + sum(V2)
     .(A = 1:.N, B = x) # last list returned as a data.table
     }]
## @knitr advCols12.2
#


## @knitr chaining
## Chain expressions ---------------------------------------------------

## @knitr chain1.1
DT[, by = V4, 
     .(V1sum = sum(V1)) ][
     V1sum > 5]
## @knitr chain1.2
DF %>%
  group_by(V4) %>%
  summarise(V1sum = sum(V1)) %>%
  filter(V1sum > 5)

## @knitr chain2.1
DT[, by = V4, 
     .(V1sum = sum(V1))] %>%
  .[order(-V1sum)]
## @knitr chain2.2
DF %>%
  group_by(V4) %>%
  summarise(V1sum = sum(V1)) %>%
  arrange(desc(V1sum))


## @knitr key
## Indexing and Keys ----------------------------------------------------

## @knitr key1.1
setkey(DT, V4)
setindex(DT, V4)
DT
## @knitr key1.2
DF <- arrange(DF, V4) # ordered just for consistency
DF

## @knitr key2.1
DT["A", on = "V4"]
DT[c("A", "C"), on = .(V4)] # same as on = "V4"
## @knitr key2.2
filter(DF, V4 == "A")
filter(DF, V4 %in% c("A", "C"))

## @knitr key3.1
DT["B", on = "V4", mult = "first"]
DT[c("B", "C"), on = "V4", mult = "first"]
## @knitr key3.2
DF %>%
  filter(V4 == "B") %>%
  slice(1)
# ?

## @knitr key4.1
DT["A", on = "V4", mult = "last"]
## @knitr key4.2
DF %>%
  filter(V4 == "A") %>%
  slice(n())

## @knitr key5.1
# (default) returns a row with "D" even if not found
DT[c("A", "D"), on = "V4", nomatch = NA]
# no rows for unmatched values
DT[c("A", "D"), on = "V4", nomatch = 0]
## @knitr key5.2
#
filter(DF, V4 %in% c("A", "D"))

## @knitr key6.1
DT[c("A", "C"), sum(V1), on = "V4"]
## @knitr key6.2
DF %>%
  filter(V4 %in% c("A", "C")) %>%
  summarise(sum(V1))

## @knitr key7.1
DT["A", V1 := 0, on = "V4"]
DT
## @knitr key7.2
DF <- DF %>%
  mutate(V1 = base::replace(V1, V4 == "A", 0L)) %>%
  arrange(V4)
DF

## @knitr key8.1
DT[!"B", sum(V1), on = "V4", by = .EACHI]
DT[V4 != "B",
   by = V4,
   sum(V1)]   # same
## @knitr key8.2
DF %>%
  filter(V4 != "B") %>%
  group_by(V4) %>%
  summarise(sum(V1))

## @knitr key9.1
setkey(DT, V4, V1) # or setkeyv(DT, c("V4", "V1"))
setindex(DT, V4, V1) # setindexv(DT, c("V4", "V1"))
DT
## @knitr key9.2
DF <- arrange(DF, V4, V1) # ordered just for consistency
DF

## @knitr key10.1
DT[.("C", 1), on = .(V4, V1)]
DT[.(c("B", "C"), 1), on = .(V4, V1)]
# using which = TRUE only returns the matching rows indices
DT[.(c("B", "C"), 1), on = .(V4, V1), which = TRUE]
## @knitr key10.2
filter(DF, V1 == 1, V4 == "C")
filter(DF, V1 == 1, V4 %in% c("B", "C"))
# ?

## @knitr key11.1
setkey(DT, NULL)
setindex(DT, NULL)
DT
## @knitr key11.2
# 
DF

## @knitr set
## set* modifications ----------------------------------------------------

## @knitr set1.1
set(DT, i = 1L, j = 2L, value = 3L)
DT
## @knitr set1.2
DF[1, 2] <- 3L
DF

## @knitr set2.1
setorder(DT, V4, -V1)
setorderv(DT, c("V4", "V1"), c(1, -1))
## @knitr set2.2
DF <- arrange(DF, V4, desc(V1))

## @knitr set3.1
setnames(DT, old = "V2", new = "v2")
setnames(DT, old = -(c(1, 3)), new = "V2")
DT
## @knitr set3.2
DF <- rename(DF, v2 = V2)
DF <- rename(DF, V2 = v2) # reset upper
DF

## @knitr set4.1
setcolorder(DT, c("V4", "V1", "V2"))
DT
## @knitr set4.2
DF <- select(DF, V4, V1, V2)
DF

## @knitr set5.1
# ?setDT # data.frame or list to data.table
# ?setDF # data.table to data.frame
# ?setattr # modify attributes
## @knitr set5.2
# 

## @knitr set6.1
# coming soon (#4358)
## @knitr set6.2
DF %>%
  relocate(V4, .after = V2)


## @knitr advBy
## Advanced use of by ----------------------------------------------------

## @knitr advBy1.1
DT[, .SD[1], by = V4]
DT[, .SD[c(1, .N)], by = V4]
DT[, tail(.SD, 2), by = V4]
## @knitr advBy1.2
DF %>%
  group_by(V4) %>%
  slice(1)
DF %>%
  group_by(V4) %>%
  slice(1, n())
DF %>%
  group_by(V4) %>%
  group_map(~ tail(.x, 2))

## @knitr advBy2.1
DT[, .SD[which.min(V2)], by = V4]
## @knitr advBy2.2
DF %>%
  group_by(V4) %>%
  arrange(V2) %>%
  slice(1)

## @knitr advBy3.1
DT[, Grp := .GRP, by = .(V4, V1)][]
DT[, Grp := NULL] # delete for consistency
## @knitr advBy3.2
DF %>%
  group_by(V4, V1) %>%
  mutate(Grp = cur_group_id())
# DF %>% mutate(Grp = group_indices(., V4, V1))

## @knitr advBy4.1
DT[, .I, by = V4] # returns a data.table
DT[, .I[1], by = V4]
DT[, .I[c(1, .N)], by = V4]
## @knitr advBy4.2
DF %>%
  group_by(V4) %>%
  mutate(cur_group_rows())
#DF %>%
#  group_by(V4) %>%
#  group_data() %>%
#  tidyr::unnest(.rows)
DF %>%
  group_by(V4) %>%
  summarize(cur_group_rows()[1])
DF %>%
  group_by(V4) %>%
  summarize(cur_group_rows()[c(1, n())])
# DF %>% group_by(V4) %>% group_rows() # returns a list


## @knitr advBy5.1
DT[, .(.(V1)),  by = V4]  # return V1 as a list
DT[, .(.(.SD)), by = V4] # subsets of the data
## @knitr advBy5.2
DF %>%
  group_by(V4) %>%
  summarise(list(V1))
DF %>%
  group_by(V4) %>%
  group_nest()

## @knitr advBy6.1
rollup(DT,
       .(SumV2 = sum(V2)),
       by = c("V1", "V4"))

rollup(DT,
       .(SumV2 = sum(V2), .N),
       by = c("V1", "V4"),
       id = TRUE)

cube(DT,
     .(SumV2 = sum(V2), .N),
     by = c("V1", "V4"),
     id = TRUE)

groupingsets(DT,
             .(SumV2 = sum(V2), .N),
             by   = c("V1", "V4"),
             sets = list("V1", c("V1", "V4")),
             id   = TRUE)
## @knitr advBy6.2
#

## @knitr advBy7.1
# DT[, .BY, by = V4]
## @knitr advBy7.2
# DF %>% group_by(V4) %>% cur_group() 



## @knitr MISCELLANEOUS
## MISCELLANEOUS --------------------------------------------------------
## >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

## @knitr readwrite
## Read/write data ------------------------------------------------------

## @knitr readwrite1.1
fwrite(DT, "DT.csv")
## @knitr readwrite1.2
readr::write_csv(DF, "DF.csv")
# see also vroom

## @knitr readwrite2.1
fwrite(DT, "DT.txt", sep = "\t")
## @knitr readwrite2.2
readr::write_delim(DF, "DF.txt", delim = "\t")

## @knitr readwrite3.1
fwrite(setDT(list(0, list(1:5))), "DT2.csv")
## @knitr readwrite3.2
#

## @knitr readwrite4.1
fread("DT.csv")
# fread("DT.csv", verbose = TRUE) # full details
fread("DT.txt", sep = "\t")
## @knitr readwrite4.2
readr::read_csv("DF.csv")
readr::read_delim("DF.txt", delim = "\t")

## @knitr readwrite5.1
fread("DT.csv", select = c("V1", "V4"))
fread("DT.csv", drop = "V4")
## @knitr readwrite5.2
# NA

## @knitr readwrite6.1
rbindlist(lapply(c("DT.csv", "DT.csv"), fread))
# c("DT.csv", "DT.csv") %>% lapply(fread) %>% rbindlist
## @knitr readwrite6.2
c("DF.csv", "DF.csv") %>%
  purrr::map_dfr(readr::read_csv)

## @knitr readwrite7
## remove files
file.remove(c("DT.csv", "DF.csv", "DT.txt", "DF.txt", "DT2.csv"))


## @knitr reshape
## Reshape data ---------------------------------------------------------

## @knitr reshape1.1
melt(DT, id.vars = "V4")
mDT <- melt(DT,
            id.vars       = "V4",
            measure.vars  = c("V1", "V2"),
            variable.name = "Variable",
            value.name    = "Value")
## @knitr reshape1.2
tidyr::gather(DF, variable, value, -V4)
mDF <- tidyr::gather(DF,
                     key = Variable,
                     value = Value,
                     -V4)
# pivot_longer todo

## @knitr reshape2.1
dcast(mDT, V4 ~ Variable) # aggregate by count
dcast(mDT, V4 ~ Variable, fun.aggregate = sum)
dcast(mDT, V4 ~ Value > 5)
# see ?dcast: multiple values / fun.aggregate
## @knitr reshape2.2
tidyr::spread(data  = count(mDF, V4, Variable),
              key   = Variable,
              value = n,
              fill  = 0)
# pivot_wider todo

## @knitr reshape3.1
split(DT, by = "V4") # S3 method
## @knitr reshape3.2
group_split(DF, V4)

## @knitr reshape4.1
vec <- c("A:a", "B:b", "C:c")
tstrsplit(vec, split = ":", keep = 2L) # works on vector
setDT(tstrsplit(vec, split = ":"))[]
## @knitr reshape4.2
vec <- c("A:a", "B:b", "C:c")
# vector not handled
tidyr::separate(tibble(vec), vec, c("V1", "V2"))


## @knitr other
## Other ----------------------------------------------------------------

## @knitr other1.1
# test.data.table()
# There's more lines of test code in data.table than there is code!
## @knitr other1.2
#

## @knitr other2.1
tables()
## @knitr other2.2
#

## @knitr other3.1
getDTthreads() # setDTthreads()
## @knitr other3.2
#

## @knitr other4.1
shift(1:10, n = 1,   fill = NA, type = "lag")
shift(1:10, n = 1:2, fill = NA, type = "lag") # multiple
shift(1:10, n = 1,   fill = NA, type = "lead")
## @knitr other4.2
lag(1:10, n = 1, default = NA)
purrr::map(1:2, ~lag(1:10, n = .x))
lead(1:10, n = 1, default = NA)

## @knitr other5.1
rleid(rep(c("a", "b", "a"), each = 3)) # see also ?rleidv
rleid(rep(c("a", "b", "a"), each = 3), prefix = "G")
## @knitr other5.2
#

## @knitr other6.1
x <- 1:10
fcase(
  x %% 6 == 0, "fizz buzz",
  x %% 2 == 0, "fizz",
  x %% 3 == 0, "buzz",
  default = NA_character_
)

## @knitr other6.2
x <- 1:10
case_when(
  x %% 6 == 0 ~ "fizz buzz",
  x %% 2 == 0 ~ "fizz",
  x %% 3 == 0 ~ "buzz",
  TRUE ~ as.character(x)
)

## @knitr other7.1
# todo
## @knitr other7.2
#

## @knitr other8.1
x <- c(-3:3, NA)
fifelse(test = x < 0,
        yes  = "neg",
        no   = "pos",
        na   = "NA")

## @knitr other8.2
x <- c(-3:3, NA)
if_else(condition = x < 0,
        true      = "neg",
        false     = "pos",
        missing   = "NA")


## @knitr JOINS
## JOIN/BIND DATASETS ---------------------------------------------------
## >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

## @knitr join
## Join -----------------------------------------------------------------

## @knitr join1
x <- data.table(Id  = c("A", "B", "C", "C"),
                X1  = c(1L, 3L, 5L, 7L),
                XY  = c("x2", "x4", "x6", "x8"),
                key = "Id")

y <- data.table(Id  = c("A", "B", "B", "D"),
                Y1  = c(1L, 3L, 5L, 7L),
                XY  = c("y1", "y3", "y5", "y7"),
                key = "Id")

## @knitr join2.1
y[x, on = "Id"]
merge(x, y, all.x = TRUE, by = "Id")
y[x] # requires keys
## @knitr join2.2
left_join(x, y, by = "Id")

## @knitr join3.1
x[y, on = "Id"]
merge(x, y, all.y = TRUE, by = "Id")
x[y] # requires keys
## @knitr join3.2
right_join(x, y, by = "Id")

## @knitr join4.1
x[y, on = "Id", nomatch = 0]
merge(x, y)
x[y, nomatch = 0] # requires keys
## @knitr join4.2
inner_join(x, y, by = "Id")

## @knitr join5.1
merge(x, y, all = TRUE, by = "Id")
## @knitr join5.2
full_join(x, y, by = "Id")

## @knitr join6.1
unique(x[y$Id, on = "Id", nomatch = 0])
unique(x[y$Id, nomatch = 0]) # requires keys
## @knitr join6.2
semi_join(x, y, by = "Id")

## @knitr join7.1
x[!y, on = "Id"]
x[!y] # requires keys
## @knitr join7.2
anti_join(x, y, by = "Id")


## @knitr morejoins
## More join -------------------------------------------------------------

## @knitr morejoins1.1
x[y, .(Id, X1, i.XY)]   # i. prefix refers to cols in y
x[y, .(Id, x.XY, i.XY)] # x. prefix refers to cols in x
## @knitr morejoins1.2
right_join(select(x, Id, X1),
           select(y, Id, XY),
           by = "Id")
right_join(select(x, Id, XY),
           select(y, Id, XY),
           by = "Id")

## @knitr morejoins2.1
y[x, .(X1Y1 = sum(Y1) * X1), by = .EACHI]
## @knitr morejoins2.2
y %>%
 group_by(Id) %>%
 summarise(SumY1 = sum(Y1)) %>%
 right_join(x) %>%
 mutate(X1Y1 = SumY1 * X1) %>%
 select(Id, X1Y1)

## @knitr morejoins3.1
y[x, SqX1 := i.X1^2]
y[, SqX1 := x[.BY, X1^2, on = "Id"], by = Id] # more memory-efficient
y[, SqX1 := NULL] # rm column for consistency
## @knitr morejoins3.2
x %>%
 select(Id, X1) %>%
 mutate(SqX1 = X1^2) %>%
 right_join(y, by = "Id") %>%
 select(names(y), SqX1)

## @knitr morejoins4.1
x[, y := .(.(y[.BY, on = "Id"])), by = Id]
x[, y := NULL] # rm column for consistency
## @knitr morejoins4.2
nest_join(x, y, by = "Id")

## @knitr morejoins5.1
cols  <- c("NewXY", "NewX1")
icols <- paste0("i.", c("XY", "X1"))

y[x, (cols) := mget(icols)]

y[, (cols) := NULL] # rm columns for consistency
## @knitr morejoins5.2
# ?

## @knitr morejoins6
z <- data.table(ID = "C", Z1 = 5:9, Z2 = paste0("z", 5:9))
x[, X2 := paste0("x", X1)] # used to track the results
z; x

## @knitr morejoins6.1
x[z, on = "X1 == Z1"]
x[z, on = .(X1 == Z1)] # same
x[z, on = .(Id == ID, X1 == Z1)] # using two columns
## @knitr morejoins6.2
right_join(x, z, by = c("X1" = "Z1"))
right_join(x, z, by = c("Id" = "ID", "X1" = "Z1"))

## @knitr morejoins7.1
x[z, on = .(Id == ID, X1 <= Z1)]
x[z, on = .(Id == ID, X1 > Z1)]
x[z, on = .(X1 < Z1), allow.cartesian = TRUE] # allows 'numerous' matching values
## @knitr morejoins7.2
#

## @knitr morejoins8.1
# Nearest
x[z, on = .(Id == ID, X1 == Z1), roll = "nearest"]
## below, simplified examples with ad hoc subsets on a keyed data.table
setkey(x, Id, X1)
x[.("C", 5:9), roll = "nearest"]
## @knitr morejoins8.2
#

## @knitr morejoins9.1
# Last Observation Carried Forward
x[.("C", 5:9), roll = Inf]
x[.("C", 5:9), roll = 0.5]  # bounded
x[.("C", 5:9), roll = Inf, rollends = c(FALSE, TRUE)]  # default
x[.("C", 5:9), roll = Inf, rollends = c(FALSE, FALSE)] # ends not rolled
## @knitr morejoins9.2
#

## @knitr morejoins10.1
# Next Observation Carried Backward
x[.("C", 5:9), roll = -Inf]
x[.("C", 5:9), roll = -0.5] # bounded
x[.("C", 5:9), roll = -Inf, rollends = c(TRUE, FALSE)]
x[.("C", 5:9), roll = -Inf, rollends = c(TRUE, TRUE)]  # roll both ends
## @knitr morejoins10.2
#

## @knitr morejoins11.1
CJ(c(2, 1, 1), 3:2)
CJ(c(2, 1, 1), 3:2, sorted = FALSE, unique = TRUE)
## @knitr morejoins11.2
# base::expand.grid(c(2, 1, 1), 3:2)
#


## @knitr bind
## Bind ----------------------------------------------------------------

## @knitr bind1
x <- data.table(1:3)
y <- data.table(4:6)
z <- data.table(7:9, 0L)

## @knitr bind2.1
rbind(x, y)
rbind(x, z, fill = TRUE)
## @knitr bind2.2
bind_rows(x, y)
bind_rows(x, z) # always fills

## @knitr bind3.1
rbindlist(list(x, y), idcol = TRUE)
## @knitr bind3.2
bind_rows(list(x, y), .id = "id")

## @knitr bind4.1
base::cbind(x, y)
## @knitr bind4.2
bind_cols(x, y)


## @knitr setOps
## Set operations -------------------------------------------------------

## @knitr setOps0
x <- data.table(c(1, 2, 2, 3, 3))
y <- data.table(c(2, 2, 3, 4, 4))

## @knitr setOps1.1
fintersect(x, y)
fintersect(x, y, all = TRUE)
## @knitr setOps1.2
dplyr::intersect(x, y)
# no all option

## @knitr setOps2.1
fsetdiff(x, y)
fsetdiff(x, y, all = TRUE)
## @knitr setOps2.2
dplyr::setdiff(x, y)
# no all option

## @knitr setOps3.1
funion(x, y)
funion(x, y, all = TRUE)
## @knitr setOps3.2
dplyr::union(x, y)
union_all(x, y)

## @knitr setOps4.1
fsetequal(x, x[order(-V1),])
all.equal(x, x) # S3 method
## @knitr setOps4.2
setequal(x, x[order(-V1),])
all_equal(x, x)


##  @knitr session
## SESSION INFO ----------------------------------------------------------

## @knitr sessionInfo
sessionInfo()


