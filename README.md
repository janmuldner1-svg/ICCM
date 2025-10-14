## Geoscripting project repository.

- Title: **Checking Timber Permit and Oil Palm Concession Boundaries with Remote Sensing in Indonesia**
- Team name and members: **Bali Starlings; Jan Müldner, Joelle van Drie, Tosca Koeze, Pascal Dubbelman**
- Challenge number (or "own"): **Challenge 1**
- Description, how to run/reproduce (see below "Usage")

## About the project
The aim of our project is to construct reproducible code which will be able to identify discrepancies between legal concessions issued and open-source land cover/change maps for two major commodities managed in Indonesia: legal timber and oil palms. 
Additionally, we assess the reality of the situation visually using remotely sensed imagery applied to the largest mismatches uncovered through our code.

The following **table** demonstrates the intended structure further, as it lists which types of data are sourced for each commodity under each category.

| **Commodity**               |  **Official concessions**   |       **Open source maps**       |         **Real-time RS imagery**           |
| ---------------------------:| ---------------------------:| --------------------------------:| ------------------------------------------:|
| **Timber**                  | Managed forests, wood fiber | Forest cover loss, deforestation |  Mismatch (Unauthorized/informal logging)  |
| **Oil palm**                |    Oil palm concessions     |     True oil palm occurrence     |  Mismatch (Unauthorized/informal planting) |

The objectives of the project are comparing open-source datasets, such as oil palm plantations as attributes of land cover maps, with official concession boundaries. To minimize extent and reach feasible data sizes, the project is focused on the Barat province of Kalimantan Island, Indonesia, otherwise known as West Kalimantan. GeoBoundaries are used as a source for provincial boundaries within Indonesia, downloaded as a shapefile containing the administrational level n. 1. 
The analysed datasets are clipped to its extent in our script. Initially, we acquired concessions as polygon features (shapefiles, geojson files) for both commodities separately. It is important to mention here that for timber, the authorized areas of logging and wood management are divided into two categories. The first are Managed Forest concessions, are downloadable from the Global Forest Watch (GFW) for the entire world. They refer to areas allocated by a government for harvesting timber and other wood products in a public forest. The second are Wood Fiber concessions for Indonesia, which are issued locally for the exclusive production of pulp and paper products, also available from GFW. Both timber data sets are merged into one timber concessions data set with the merge_timber fundtion. Finally, the oil palm concessions are obtained through the same source (GFW).

Additionally, two open-source datasets are downloaded for reviewing the current state of oil palm plantations, as well as forest cover loss (which should both not happen outside of authorized areas obtained in the first part of our project). For timber, a dataset containing deforestation or tree cover loss in Indonesia is obtained from Google Earth Engine.  This data set shows deforestation (tree loss) from 2000-2024. The Identify_mismatch_polygons function identifies regions where tree loss has occurred, but where not in the timber concession or oil palm concession polygons. For oil palms, the open-source data set called “Palm probability model 2025a” was downloaded from Google Earth Engine. The Identify_mismatch_polygons function is used to compare the open-source palm data with the official oil palm concessions and identify where oil palm cultivating occurs outside of the concession boundaries.

The script identifies all mismatches within the extent of the project and calculates statistics for them. It returns the following statistics: the number of mismatch polygons, the total area of the mismatches within the extent (km²), the mean area of a mismatch polygon (km²),  the standard deviation of the area, and the total area of the mismatches expressed in number of football fields.

The project will support it's aims through the following 4 research questions:
•	Q1: To what extent (in %) do the timber permit concessions align with open-source forest loss maps in the Kalimantan Barat province in Indonesia?
•	Q2: What percentage of oil palm plantations fall within their designated concession areas in the Kalimantan Barat province in Indonesia?
•	Q3: How many mismatch cases does our code identify, and what are the statistical values for them? (mean mismatch area, total number of mismatches, sd)
•	Q4: Through use of RS, which new insights can be derived for the two largest mismatches for each commodity? Can visual inspection of such RS imagery be used for the interpretation of the causes for mismatch?


## Getting started
### Open a terminal
### Make sure git is installed
### Clone the git repository with an HTTPS
git clone https://git.wur.nl/geoscripting-2025/staff/project/Project_Starter-Bali_starlings.git

### Set the working directory to the project folder
cd Project_Starter-Bali_Starlings (in terminal)
or use the setwd() function in R

### Download data from MS Teams 
There are a few data sets which could not be acquired through a URL link within the code, either due to size, or accessibility.
We downloaded these data sets and prepared them on MS Teams (under Files tab).
To be able to run the main script, download them following these three steps:

1. Download the files with the following names from MS Teams to your computer:
 * ketapang_palm_2023_90.tif
 * managed_forest_data.zip
 * west_kalimantan_forest_loss_year.tif

2. Run the very first part of the main.R, so that the correct directories are created
(Lines 4, 5, 6, titled "# Create necessary directories")

3. Move the files you downloaded into the "data" directory

Now, all necessary data will be ready in "data" for when the full main.R is run later on (see below).

## Install necessary packages in R
install.packages("sf")
install.packages("terra")
install.packages("dplyr")
install.packages("shiny")
install.packages("leaflet")
 
## Usage
Run the full main.R file. The script was developed in RStudio, so we recommend using it as the default IDE. The following should happen as result:
- The mismatches identified by the script will be stored as .json files (as polygons) in the "output" directory.
- The statistical results will be stored as a .csv file with two rows, one for each commodity, in the "output" directory.
- A window will pop up with the Shiny Web Application with a box suggesting "open in Browser". Click on it and an interactive, visual map should open up.

A few examples/screenshots of output may be found below:


## Contributing
The code was created by the Bali starlings team, consisting of:
* Joëlle van Drie
* Jan Müldner
* Pascal Dubbelman
* Tosca Koeze

## License
The project is distributed under the MIT license, more information on the license can be found in the LICENSE.txt file.

## Acknowledgements 
The original idea for this project came from Space4Good. This company is among other things involved in deforestation monitoring for various Indonesian entities.
Throughout the creation of this project we were in contact with Ramadhan from Space4Good, whom provided us with very helpful feedback.

This short-term project was created by students of Wageningen University and Research under the course Geoscripting. 

## Contacts
If you have any questions, you can contact the following email address: 
joelle@dontcontactme.gmail.com



