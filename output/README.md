# DQD output of Bordeaux University Hospital 19/08/2021

* errors: package errors
* errors_classified: errors manually reviewed and classified
* Fail_analysis.csv: an export in the Shiny interface of fail tests, they were manually reviewed. The comment column indicates to which github issue an error refers to. 
* CDWbordeaux-20210819045649.json: json output file. Open it with RShiny:

```R
jsonFile <- "CDWbordeaux-20210819045649.json"
DataQualityDashboard::viewDqDashboard(file.path(getwd(), jsonFile))
```