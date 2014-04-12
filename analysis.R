#!/usr/bin/Rscript
# Purpose: Put the MBA survey data in a more useful form
# Author: John Horton

# read the raw data 
df.raw <- read.csv("data.csv",
                   stringsAsFactors = FALSE)

# to get an update, go here:
# https://docs.google.com/spreadsheets/d/1t_N7dgi82KF3uDI8I-bQ1WE5ONrbKrMNZpVqJJVAUC8/edit#gid=0

# create headings for the new datasaet 
headings <- c("Tech", "NoProgram", "ProdDev")
outcomes <- c("Fall.1", "Spring.1", "Elec", "Current", "NotInterested")
headers <- as.character(sapply(headings,
                               function(heading) sapply(outcomes,function(outcome) paste0(heading,".", outcome))))

# get the list of majors 
majors.list <- colnames(df.raw)[7:38]

dechunkify <- function(i){
    row.1 <- df.raw[i, ]
    row.2 <- df.raw[i + 1, ]
    row.3 <- df.raw[i + 2, ]
    row.4 <- df.raw[i + 3, ] 
    row.5 <- df.raw[i + 4, ]
    pref.row <- as.numeric(c(row.1[2:6], row.2[2:6], row.3[2:6]))
    pref.row[is.na(pref.row)] <- 0
    major <- as.numeric(row.4[7:38])
    major[is.na(major)] <- 0
    sharing.comments <- row.5[39]
    new.row <- c(pref.row, major, as.character(sharing.comments))
    names(new.row) <- c(headers, majors.list, "sharing_comments")
    new.row
}

# map over the "chunks" of the data in blocks of 6 & combine into a  
df <- data.frame(do.call("rbind",  lapply(seq(1,516,6), dechunkify)))

write.csv(df, "cleaned_up.csv")
