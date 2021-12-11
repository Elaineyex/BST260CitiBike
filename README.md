# BST260CitiBike

## File Order
1) ```BST260CitiBike.html```
2) ```Data Processing.rmd``` 
3) ```EDA_.html``` files
4) ```Modeling_.html``` files
5) ```Shiny_``` folders
6) ```Data.rar``` (for reference)

## Shiny App instructions
1) Download the entire folder
2) Unzip ```bikedata_sampled_1percent.csv``` into the folder
3) Run ```App.R```

## EDA and Modeling files instructions 
```EDA_Ye.rmd``` and ```Modeling_Ye.rmd``` include visualization of bike trips by county and XGboost model to predict user type of Citi Bike.
1) Download ```bike_join.Rdata``` from Google Drive https://drive.google.com/file/d/1K-Jc_kls_PFghMPSG0XHh72MNbAFngJF/view?usp=sharing
2) Run rmd files

```James_EDA.rmd``` and ```James_Model.rmd``` include visualizations and modeling related to User Type. This section of the report utilizes logistic regression to make predictions on user type per trip. 
1) Download ```geo_sample.csv``` from Google Drive https://drive.google.com/file/d/1L1I5VYGJN5iJ94GSrvyuL3QCIWseJKXI/view?usp=sharing
2) Run rmd files

```EDA_QJ.rmd``` and ```Modeling_QJ.rmd``` include visualizations and modeling related to Trip Duration. This section of the report utilizes Random Forest to make predictions on trip duration. 
1) Download ```bike_join.Rdata``` from Google Drive https://drive.google.com/file/d/1K-Jc_kls_PFghMPSG0XHh72MNbAFngJF/view?usp=sharing
2) Download ```COVIDcasedata.csv``` from Google Drive https://drive.google.com/file/d/1fp0pxZVh7rIYn13IawCbuFKgWW41Lvs-/view?usp=sharing
3) Download ```NYCWeather.csv``` from Google Drive https://drive.google.com/file/d/10DOJLSRGz3UsnF9V4G0SODtUyrdiZcR-/view?usp=sharing
4) Run rmd files (warning: Modeling_QJ.rmd takes a long time! If encountering a vector memory exhausted error, follow the following steps:
  * Open terminal
  * cd ~
  * touch .Renviron
  * open .Renviron
  * Save the following as the first line of .Renviron: R_MAX_VSIZE=100Gb
 
```EDA_Amber.rmd``` and ```Modeling_Amber.rmd``` include time-series prediction for daily trips using exponential, double exponential, holt-winter, and LSTM.
1) Download https://www.dropbox.com/sh/6fnodxpoyr3txbk/AAC3u2SXfY8VP3itdfUvsxdHa?dl=0 and keep the excel files and .rmd files in the same folder
2) Run .rmd files
