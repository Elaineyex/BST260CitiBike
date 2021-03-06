# BST260CitiBike

Group members: Bhawesh Kumar, Ian Lo, Amber Nigam, James Wen, QJ Yap, Elaine Ye

## File Order
1) ```BST260CitiBike.html```: a brief summary of our project goal  
2) ```Data Processing.rmd``` (for reference, not necessary to run)
3) ```EDA_.html``` files
4) ```Modeling_.html``` files
5) ```Shiny_``` folders

Most of the data are hosted in the OneDrive Folder: https://hu-my.sharepoint.com/:f:/g/personal/elaine_ye_hsph_harvard_edu/Enp4cHMie0NDigAXkRM7OuUBXUabQfooYYBa3ouYNe_cpA?e=j9ntU8

The main data is obtained from the Citi Bike system data https://ride.citibikenyc.com/system-data. External data use is detailed in ```Data Processing.rmd```.

## Shiny App instructions
1) Download the two ```Shiny_.zip``` folders. Unzip locally.
2) Run ```App.R```
3) You can also access the links here: https://ianlo.shinyapps.io/shiny_ian/, https://bhaweshk.shinyapps.io/Shiny_Bhawesh/

## EDA and Modeling files instructions 
```EDA_Ye.rmd``` and ```Modeling_Ye.rmd``` include visualization of bike trips by county and XGboost model to predict user type of Citi Bike.
1) Download ```bike_join.Rdata``` from the OneDrive
2) Run rmd files

```James_EDA.rmd``` and ```James_Model.rmd``` include visualizations and modeling related to User Type. This section of the report utilizes logistic regression to make predictions on user type per trip. 
1) Download ```geo_sample.csv``` from the OneDrive
2) Run rmd files

```EDA_QJ.rmd``` and ```Modeling_QJ.rmd``` include visualizations and modeling related to Trip Duration. This section of the report utilizes Random Forest to make predictions on trip duration. 
1) Download ```bike_join.Rdata``` from the OneDrive
2) Download ```COVIDcasedata.csv``` from the OneDrive
3) Download ```NYCWeather.csv``` from the OneDrive
4) Run rmd files (warning: Modeling_QJ.rmd takes a long time! If encountering a vector memory exhausted error, follow the following steps:
  * Open terminal
  * cd ~
  * touch .Renviron
  * open .Renviron
  * Save the following as the first line of .Renviron: R_MAX_VSIZE=100Gb
 
```EDA_Amber.rmd``` and ```Modeling_Amber.rmd``` include time-series prediction for daily trips using exponential, double exponential, holt-winter, and LSTM.
1) Download https://www.dropbox.com/sh/6fnodxpoyr3txbk/AAC3u2SXfY8VP3itdfUvsxdHa?dl=0 and keep the excel files and .rmd files in the same folder
2) Run .rmd files
