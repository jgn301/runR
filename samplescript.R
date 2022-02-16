# load library for command line options
library(getopt)

# specify command line options
# long flag, short flag, required, variable type
spec = matrix(c(
  'optiona', 'a', 2, "character",
  'optionb', 'b', 2, "integer",
  'optionx', 'x', 2, "logical",
  'taskid',  't', 2, "integer"  # a flag named "taskid" is REQUIRED if a script is called as an array job using runR.sh AND the getopt package is used 
), byrow=TRUE, ncol=4)

# set defaults
optiona = "default"
optionb = 17
optionx = F
taskid = F

# read command line options
opt = getopt(spec)

# overwrite defaults if flag was set
for(arg_ in names(opt)[!names(opt)=="ARGS"])
  assign(arg_, opt[[arg_]])
  
# inspect variable values
cat(paste0('\nvariables:',
			'\noptiona: ', optiona,
			'\noptionb: ', optionb,
			'\noptionx: ', optionx,
			'\ntaskid: ', taskid, '\n'))

cat(paste0('\nthe working directory is ', getwd(), '\n'))			
			
if(taskid) cat(paste0('This is an instance of an array job, and its task ID is: ', taskid, '\n'))
			