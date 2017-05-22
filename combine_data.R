# Combines data from individual content files to create an incidence array

library(lubridate)
library(stringr)

groups <- read.table("group_list.txt", stringsAsFactors = FALSE,strip.white = TRUE, blank.lines.skip = TRUE)
groups <- apply(groups,1,str_to_lower)
groups <- unique(groups)

num_groups <- length(groups)

miss_date <- mdy("1/1/1990")
miss_group <- ""

missing <- data.frame(miss_date, miss_group, stringsAsFactors = FALSE)

for (doc in list.files("./data/", include.dirs=FALSE)) {
  one_day <- readLines(paste("./data/",doc,sep=""))
  one_day <- trimws(one_day)
  one_day <- one_day[one_day != ""]
  
  one_day_groups <- vector(mode = "logical", length=num_groups)
  names(one_day_groups) <- groups
  
  date_info <- unlist(strsplit(one_day[1], " "))
  date_info <- trimws(str_to_lower(date_info))
  
  date <- mdy(date_info[length(date_info)])
  
  if ('midday' %in% date_info) {
    time <- 'Midday'
  } else if ('morning' %in% date_info) {
    time <- 'Morning'
  } else {
    time <- NA
  }
  
  if (is.na(date)) {
    info <- paste(doc,"---------------\n",sep="\n")
    write.table(info, "ubiquitous_files.txt", append=TRUE, col.names=FALSE, row.names=FALSE, quote=FALSE)
    write.table(one_day, "ubiquitous_files.txt", append=TRUE, col.names=FALSE, row.names=FALSE, quote=FALSE)
    write.table("\n\n", "ubiquitous_files.txt", append=TRUE, col.names=FALSE, row.names=FALSE, quote = FALSE)
  } else if("elements" %in% unlist(strsplit(one_day)))
    for (i in 2:length(one_day)) {
      group <- trimws(str_to_lower(one_day[i]))
      if (group %in% names(one_day_groups)) {
        one_day_groups[group] <- TRUE
      } else {
        missing <- rbind(missing, list(date, group))
      }
    }
    
    one_day_groups <- data.frame(one_day_groups)
    if (is.na(time)) {
      colnames(one_day_groups) <- date
    } else {
      colnames(one_day_groups) <- paste(date,time,sep="-")
    }
    
    if (doc == 'content_1.txt') {
      all_data <- one_day_groups
    } else {
      all_data <- cbind(all_data, one_day_groups)
    }
  }
}

missing <- missing[!missing$miss_date==mdy("1/1/1990"),]
missing <- missing[!missing$miss_group=="3a",]

index <- c()

for(i in 1:nrow(missing)) {
  if("no" %in% unlist(strsplit(missing$miss_group[i], " ")) & "testing" %in% unlist(strsplit(missing$miss_group[i], " ")))
    index <- c(index, i)
}

missing <- missing[!index,]



write.table(all_data, "incidence_array.csv", sep=",", row.names=TRUE, col.names=TRUE, quote=FALSE)
write.table(missing, "missing_entries.csv", sep=",", col.names=TRUE, row.names=FALSE, quote=FALSE)
