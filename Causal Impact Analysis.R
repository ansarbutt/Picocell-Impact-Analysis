## Import Data from Excel to DataFrame
library(readxl)
data.import <- read_excel("C:/Users/User/Desktop/Telecom Case/Total_UL_DL_PICO_MACRO.xlsx")

## Filter for records before Pico data stops
library(dplyr)
data.filtered <- filter(data.import, Date_Format <= "2016-09-29" & Date_Format >= "2015-12-31")

## Create time series label
first.date <- head(data.filtered, n=1)$Date_Format
last.date <- tail(data.filtered, n=1)$Date_Format
time.points <- as.Date(data.filtered$Date_Format)

## Import and filter data of other sectors
library(reshape2)
other.data.import <- read_excel("C:/Users/User/Desktop/Telecom Case/other_cells_data_no_sector.xlsx")
other.filtered <- filter(other.data.import, Date_Format <= "2016-09-29" 
                         & Date_Format >= "2015-12-31" & !Area %in% c("YY1290", "YY0104", "YY1755"))


## Prepare dataset for MarketMatching
other.mm <- select(other.filtered, Area, Date_Format, data_dl)
data.filtered['Area'] <- "PICO"
pico.mm <- select(data.filtered, Area, Date_Format, data_dl = DL_Total)
final.mm <- rbind(other.mm, pico.mm)
final.mm$Date_Format <- as.Date(final.mm$Date_Format)

## MarketMatching to select other sites that are the most similar to the PICO site
# install.packages("dtw")
# install.packages("rlang",type="win.binary") 
# install.packages("Rcpp",type="win.binary") 

library(dtw)
library(devtools)
library(rlang)
library(Rcpp)

# install_github("klarsen1/MarketMatching", build_vignettes=TRUE)

library(MarketMatching)
mm <- best_matches(data=final.mm,
                   id_variable="Area",
                   date_variable="Date_Format",
                   matching_variable="data_dl",
                   parallel=TRUE,
                   warping_limit=1, 
                   dtw_emphasis=1, # rely only on dtw for pre-screening
                   matches=18, # request 15 matches
                   start_match_period="2016-01-01",
                   end_match_period="2016-09-29")

matches <- as.data.frame(mm$BestMatches)

## Pivot other data and filter for top matched sites
other.pivot <- dcast(other.filtered,Date_Format ~ Area, value.var = "data_dl")  
other.usage <- other.pivot[sapply(other.pivot, function(x) !any(is.na(x)))] # remove any columns with NA
matches.pico <- matches %>%
  filter(Area == "PICO") %>%
  select(BestControl)
idx <- match(matches.pico[['BestControl']], names(other.usage)) # get indices of best control columns in usage data
other.final <- other.usage[,idx] # using the indices filter the usage data for the best controls

## Convert data into object digestable by CausalImpact
library(zoo)
data.combined <- cbind(data.filtered$DL_Total, other.final[,-1])
colnames(data.combined)[1] <-  "DL_Total"
data.model <- zoo(data.combined, time.points)
head(data.model)

## Specifying pre and post period date ranges
pre.end.date = "2016-07-10"
post.start.date = "2016-07-18"
pre.period <- as.Date(c(as.character(first.date), pre.end.date))
post.period <- as.Date(c(post.start.date, as.character(last.date)))

## Execute CausalImpact algorithm
# install.packages("CausalImpact")
library(CausalImpact)
impact <- CausalImpact(data.model, pre.period, post.period, list(niter = 10000, nseasons = 7))
plot(impact)
summary(impact)
summary(impact, "report")


