library(coloc)
library(tidyverse)
library(config)
library(optparse)


option_list <- list(
  make_option(c("-c", "--config-file"), type="character",
              help="Configuration file in the format specified on Github", metavar="FILE"),
  make_option(c("-y", "--yaml-file"), type="character",
              help="YAML file in the format specified on Github", metavar="FILE"),
  make_option(c("-o", "--output-file"), type="character",
              help="Output file name [default= %default]", metavar="FILE"),
  make_option(c("-s", "--sample-sizes"), type="character",
              help="Sample size info file name [default= %default]", metavar="FILE")
); 

parser <- optparse::OptionParser()
opt <- optparse::parse_args(OptionParser(option_list=option_list))

config_f <- opt[['config-file']]
yaml_f <- opt[['yaml-file']]
output_f <- opt[['output-file']]
sample_size_f <- opt[['sample-sizes']]
  



print('===================')
print(paste0('Config file: ',config_f))
print(paste0('YAML file: ',yaml_f))
print(paste0('Sample size file: ',sample_size_f))
print(paste0('Output file: ',output_f))
print('===================')
config_dat <- read_config_dat(config_f)
yaml_dat <- read_yaml_dat(yaml_f)
summstats_list <- collect_summstats(config_dat,yaml_dat,sample_size_f)

coloc_res <- data.frame()
for(line in 1:summstats_list[['num_lines']]) {
  line_idx <-as.character(line)
  print(paste0('Doing colocalization for region in line: ',line_idx))
  # print(summstats_list)
  if (summstats_list[[line_idx]][['skipped']]==F) {
    region <- summstats_list[[line_idx]][['region']]
    #Formatting output
    #COLOC
    annotated_res <- perform_coloc(summstats_list,as.character(line_idx))
    num_traits <- summstats_list[[line_idx]][['num_traits']]
    for (j in 1:num_traits) {
      trait_id <- paste0('T',j)
      annotated_res[[trait_id]] <- summstats_list[[line_idx]][['traits']][trait_id]
    }    
    annotated_res <- annotated_res %>% dplyr::mutate(n=line_idx)
    coloc_res <- rbind(coloc_res,annotated_res)
  } 
  
  
}

#print(coloc_res)
write.table(coloc_res,file = output_f,quote=F,col.names = F,row.names = F,sep='\t')


