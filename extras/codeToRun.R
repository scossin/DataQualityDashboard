source("./getConnectionDetails.R")

# fill out the connection details -----------------------------------------------------------------------
cdmDatabaseSchema <- "OMOP" # the fully qualified database schema name of the CDM
resultsDatabaseSchema <- "OMOP_COHORT" # the fully qualified database schema name of the results schema (that you can write to)
cdmSourceName <- "CDWBordeaux" # a human readable name for your CDM source

# determine how many threads (concurrent SQL sessions) to use ----------------------------------------
numThreads <- 1 # on Redshift, 3 seems to work well

# specify if you want to execute the queries or inspect them ------------------------------------------
sqlOnly <- FALSE # set to TRUE if you just want to get the SQL scripts and not actually run the queries

# where should the logs go? -------------------------------------------------------------------------
outputFolder <- "output"

# logging type -------------------------------------------------------------------------------------
verboseMode <- T # set to TRUE if you want to see activity written to the console

# write results to table? -----------------------------------------------------------------------
writeToTable <- FALSE # set to FALSE if you want to skip writing to results table

# if writing to table and using Redshift, bulk loading can be initialized -------------------------------

# Sys.setenv("AWS_ACCESS_KEY_ID" = "",
#            "AWS_SECRET_ACCESS_KEY" = "",
#            "AWS_DEFAULT_REGION" = "",
#            "AWS_BUCKET_NAME" = "",
#            "AWS_OBJECT_KEY" = "",
#            "AWS_SSE_TYPE" = "AES256",
#            "USE_MPP_BULK_LOAD" = TRUE)

# which DQ check levels to run -------------------------------------------------------------------
checkLevels <- c("TABLE", "FIELD", "CONCEPT")

# which DQ checks to run? ------------------------------------

checkNames <- c() #Names can be found in inst/csv/OMOP_CDM_v5.3.1_Check_Desciptions.csv

# which CDM tables to exclude? ------------------------------------
emptyTables <- c("OBSERVATION", 
                 "DRUG_ERA",
                 "DOSE_ERA",
                 "DEVICE_EXPOSURE", 
                 "NOTE_NLP", 
                 "SPECIMEN",  
                 "FACT_RELATIONSHIP",
                 "PAYER_PLAN_PERIOD",
                 "COST")

tablesToExclude <- c(emptyTables)
# run the job --------------------------------------------------------------------------------------
DataQualityDashboard::executeDqChecks(connectionDetails = connectionDetails, 
                              cdmDatabaseSchema = cdmDatabaseSchema, 
                              resultsDatabaseSchema = resultsDatabaseSchema,
                              cdmSourceName = cdmSourceName, 
                              numThreads = numThreads,
                              sqlOnly = sqlOnly, 
                              outputFolder = outputFolder, 
                              verboseMode = verboseMode,
                              writeToTable = writeToTable,
                              checkLevels = checkLevels,
                              tablesToExclude = tablesToExclude,
                              checkNames = checkNames)

# inspect logs ----------------------------------------------------------------------------
ParallelLogger::launchLogViewer(logFileName = file.path(outputFolder, 
                                                        sprintf("log_DqDashboard_%s.txt", cdmSourceName)))

# (OPTIONAL) if you want to write the JSON file to the results table separately -----------------------------
jsonFilePath <- ""
DataQualityDashboard::writeJsonResultsToTable(connectionDetails = connectionDetails, 
                                              resultsDatabaseSchema = resultsDatabaseSchema, 
                                              jsonFilePath = jsonFilePath)

jsonFile <- "CDWbordeaux-20210728232540.json"
DataQualityDashboard::viewDqDashboard(file.path(getwd(),outputFolder, 
                                                jsonFile))
