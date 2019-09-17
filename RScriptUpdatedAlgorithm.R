#install IAT analysis package
install.packages("IAT")
library(IAT)

install.packages("devtools")
library(devtools)
install_github("dpmartin42/IAT")

# Set the path to the IAT folder here (be sure to include trailing slash)
# on Linux (use a single forward slash):
#base.dir = "~/Documents/Research/IAT/"
# on Windows (use double forward slashes):
base.dir = "C:\\Users\\anton\\Documents\\Research\\IAT\\"

# File delimiter = '/' for Unix/Max, '\\' for Windows
fd = '\\'

# Set the template you want to analyze here
template.name = "Race"
output.dir = paste(base.dir,"templates",fd,template.name,fd,"output",fd,sep="")
setwd(output.dir)

files <- list.files(path=output.dir, pattern=".txt")
DF <- NULL

for (f in files) {
  dat <- read.table(f, header=F, sep=",")
  dat$ID <- unlist(strsplit(f,split="-",fixed=T))[2]
  dat$isCongruentFirst <- c(0)
  DF <- rbind(DF, dat)
}



colnames(DF) <- c("BLOCK_NAME_S","Trials","CatLabel","CatIndex","TRIAL_ERROR","TRIAL_LATENCY","SESSION_ID","isCongruentFirst")

for(i in 1:length(DF$BLOCK_NAME_S)){
  DF$BLOCK_NAME_S[i] <- paste("BLOCK",as.character(DF$BLOCK_NAME_S[i]),sep="")
}



cong_second <- DF[DF$isCongruentFirst == 0, ]

dscore_second <- cleanIAT(my_data = cong_second,
                          block_name = "BLOCK_NAME_S",
                          trial_blocks =  c("BLOCK2","BLOCK3","BLOCK5","BLOCK6"),
                          session_id = "SESSION_ID",
                          trial_latency = "TRIAL_LATENCY",
                          trial_error = "TRIAL_ERROR",
                          v_error = 1, v_extreme = 2, v_std = 1)

d_score <- dscore_second

write.csv(d_score,file="output.csv")




