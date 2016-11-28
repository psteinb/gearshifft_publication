#!/usr/bin/env Rscript

library(docopt)
library(ggplot2)
library(readr)
library(dplyr)
# also requires svglite

'Usage:
   compare [options] <csv-files>...

 -y --ymetric=YMETRIC 	Use metric YMETRIC for plotting along y [default: Time_Total]
 -x --xmetric=XMETRIC 	Use metric XMETRIC for plotting along y [default: Size_DeviceBuffer]
 -a --aesthetics=AES    plot these aesthetics, comma separated list with up to 3 elements [default: library,hardware]
                        AES will be matched to (color,linetype,shape)
 -k --kind=KINDTYPE	Filter for KINDTYPE before plotting [default: powerof2], do not filter if KINDTYPE="all"
 -f --filename=FNAME    Use FNAME as base stem for output plots [default: gearshifft_plot]
' -> doc

opts <- docopt(doc)


open_gearshifft_csv <- function (fname){

    #extracting measurements
    local_frame <- read_csv(fname,skip=3,col_names=TRUE)
    colnames(local_frame) <- gsub(' ','_',colnames(local_frame))
    #extracting card info
    lines <- readLines(fname)
    lines[[1]] <- gsub(' "','',lines[[1]])
    lines[[1]] <- gsub('"','',lines[[1]])
    lines[[1]] <- gsub(';','',lines[[1]])
    colnames(local_frame) <- gsub('ID','id',colnames(local_frame))
    
    line_1 <- strsplit(c(lines[[1]]),",")
    gpu_model <- ""
    nrw <- nrow(local_frame)
    #cat(paste(line_1),typeof(line_1),"\t",length(line_1),"\n\n")
    if(grepl("clfft", line_1[[1]][1], ignore.case = TRUE)){
        gpu_model <- line_1[[1]][3]
        
        cat("THIS IS CLFFT ",gpu_model,"\twith ",nrw,"\n")
    }
    else {
        gpu_model <- line_1[[1]][1]
        cat("THIS IS cuFFT ",gpu_model,"\twith ",nrw,"\n")

    }

    local_frame$hardware <- gpu_model
    return(local_frame)
}

dframes <- lapply(opts[["<csv-files>"]], open_gearshifft_csv) %>% bind_rows()

gearshifft_data <- dframes %>% bind_rows()


cat("total rows collected: \t",nrow(gearshifft_data),"\n")


filter_kind <- opts[["kind"]]

####################################### FILTER ##############################################
succeeded <- gearshifft_data %>% filter(success == "Success")
filtered_by <- c("success")

if ( nchar(filter_kind) > 0 && !("all" %in% filter_kind) ){
    succeeded <- succeeded %>% filter(kind == filter_kind)
    cat("filtered for kind == ",filter_kind,": \t",nrow(succeeded),"\n")
    filtered_by <- c(filtered_by, filter_kind)
}


cat("total rows filtered: \t",nrow(succeeded),"\n")
avcols <- colnames(succeeded)

if(grep(opts[["ymetric"]],avcols) == 0){
    
    stop(cat(opts[["ymetric"]], "for y not found in available columns \n",avcols,"\n"))
}

if(grep(opts[["xmetric"]],avcols) == 0){
    
    stop(cat(opts[["xmetric"]], "for x not found in available columns \n",avcols,"\n"))
}

succeeded_ymetric_of_interest  <- succeeded %>% select(contains(opts[["ymetric"]]))
succeeded_xmetric_of_interest  <- succeeded %>% select(contains(opts[["xmetric"]]))

succeeded_factors <- succeeded %>% select(-ends_with("]"))

succeeded_reduced <- bind_cols(succeeded_factors,
                               succeeded_xmetric_of_interest,
                               succeeded_ymetric_of_interest)


name_of_ymetric <- colnames(succeeded_ymetric_of_interest)[1]
name_of_xmetric <- colnames(succeeded_xmetric_of_interest)[1]


cat("calculating mean,median and sd of ",paste(name_of_ymetric)," versus ",name_of_xmetric,"\n")

names(succeeded_reduced)[names(succeeded_reduced) == name_of_ymetric] <- "moi"
names(succeeded_reduced)[names(succeeded_reduced) == name_of_xmetric] <- "xmoi"


cols_to_consider <- Filter(function(i){ !(i %in% filtered_by || i == "id" || i == "run") },c(colnames(succeeded_factors),"xmoi"))
cols_to_grp_by <- lapply(c(cols_to_consider,"id"), as.symbol)
        

cat("summarizing by ",paste(cols_to_grp_by),"\n")
data_for_plotting <- succeeded_reduced %>%
    group_by_(.dots = cols_to_grp_by) %>%
    ##group_by(library, hardware, id, nx, ny, nz, xmoi) %>%
    summarize( moi_mean = mean(moi),
              moi_median = median(moi),
              moi_stddev = sd(moi)
              )


glimpse(data_for_plotting)

# print(data_for_plotting)
write.csv(data_for_plotting, file=paste(opts[["filename"]],".csv",sep=""))
