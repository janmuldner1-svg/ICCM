## Geoscripting project repository.

- Title: **Checking Timber Permit and Oil Palm Concession Boundaries with Remote Sensing in Indonesia**
- Team name and members: **Bali Starlings; Jan Müldner, Joelle van Drie, Tosca Koeze, Pascal Dubbelman**
- Challenge number (or "own"): **Challenge 1**
- Description, how to run/reproduce:

## About the project
The aim of our project is to construct reproducible code which will be able to identify discrepancies between **legal concessions** issued and **open source land cover/change maps** for two major commodities managed in Indonesia: **legal timber and oil palms**. Additionally, we aim to assess the **reality** of the situation visually through the use of remotely sensed imagery applied to the largest mismatches uncovered through our code.

The following **table** will demonstrate the intended structure further, as it lists which types of data will be sourced for each commodity under each category.

| **Commodity**               |  **Official concessions**   |       **Open source maps**       |         **Real-time RS imagery**           |
| ---------------------------:| ---------------------------:| --------------------------------:| ------------------------------------------:|
| **Timber**                  | Managed forests, wood fiber | Forest cover loss, deforestation |  Mismatch (Unauthorized/informal logging)  |
| **Oil palm**                |    Oil palm concessions     |     True oil palm occurrence     |  Mismatch (Unauthorized/informal planting) |

The objectives of the project are comparing open source datasets, such as oil palm plantations as attributes of land cover maps, with official concession boundaries. In order to minimize extent and reach feasible data sizes, the project will be focused on the Barat province of Kalimantan Island, Indonesia, otherwise known as West Kalimantan. GeoBoundaries will be used as a source for provincial boundaries withing Indonesia, downloadable as a shapefile containing the administrational level n. 1, following datasets will likely be clipped to its extent in our script. Initially, we seek to acquire concessions as polygon features (shapefiles, geojson files) for both commodities separately. It is important to mention here that for timber, the authorized areas of logging and wood management are divided into two categories. The first are Managed Forest concessions, are downloadable from the Global Forest Watch (GFW) for the entire world. They refer to areas allocated by a government for harvesting timber and other wood products in a public forest. The second are Wood Fiber concessions for Indonesia, which are issued locally for the exclusive production of pulp and paper products, also available from GFW. Once booth timber concessions are acquired, our scripting task will be to merge them into a single multipolygon object for further use once overlaying with open source maps. Finally, the oil palm concessions are obtainable through the same source (GFW), and can be downloaded as a whole, since they are very strictly permitted in Indonesia, and are therefore listed under a large dataset that includes all permits.

Accordingly, two existing datasets will be downloaded for reviewing the current state of oil palm plantations, as well as forest cover loss (which should both not happen outside of authorized areas obtained in the first part of our project). For timber, a dataset containing deforestation or tree cover loss in Indonesia will be obtained. The source will likely be the Google Earth Engine or Nusantra Atlas, however we haven't been able to fully verify how we will handle deforestation data yet, since they are timely and unlike viewing a current state of something, eg. current occurrence of oil palm plantations, it is not possible to view the current state of missing trees, unless this is compared to existing trees in the past (over time). Therefore, we will likely select a dataset showing tree loss and gain from 2010-2024 (or as recent as we can obtain), and we will write code that will identify regions in which tree loss has occurred, but were not within managed forests or wood fiber concession polygons. For oil palms, the MapBiomass platform will be used, and only oil palm plantations will be filtered out and extracted for the project. 

Additionally, we aim to obtain the datasets as current as possible, in order for comparable and relevant temporal analysis. With the four datasets mentioned above (timber concessions as joint multipolygon, deforestation raster, oil palm concession, oil palm plantation raster), our code should be able to overlay them, therefore identifying possible mismatches, where either deforestation, or oil palm cultivating, would be occurring outside of the borders of the corresponding concessions.

If our script runs well, our project should be able to identify all mismatches happening, and ultimately, we can take the two largest mismatched areas (per area over-reach or per %) for each commodity as outputs for our final part - the remote sensing analysis. The two largest mismatch plots would now be our ROIs, and we will use real-time imagery from Sentinel-2 to **visually** inspect the nature of both mismatches, identifying reasons for their occurrence. Since we will be focusing on the two largest mismatches for each commodity, their reasons might vary from errors in original datasets, to on-ground activity disrespecting the legal concessions.

The project will support it's aims through the following 4 research questions:
- Q1: To what extent (in %) do the timber permit concessions align with open-source forest loss maps in the Kalimantan Barat province in Indonesia?
- Q2: What percentage of oil palm plantations fall within their designated concession areas in the Kalimantan Barat province in Indonesia?
- Q3: How many mismatch cases does our code identify, and what are the statistical values for them? (mean mismatch area, total number of mismatches, sd)
- Q4: Through use of RS, which new insights can be derived for the two largest mismatches for each commodity? Can visual inspection of such RS imagery be used for the interpretation of the causes for mismatch?

## Getting started
### Open a terminal
### Make sure git is installed
### Clone the git repository with an HTTPS
git clone https://git.wur.nl/geoscripting-2025/staff/project/Project_Starter-Bali_starlings.git

### Set the working directory to the project folder
cd Project_Starter-Bali_Starlings (in terminal)
or use the setwd() function in R

### Download data from MS Teams 
There are a few data sets for which we did not have a download link. 
We downloaded these data sets and put them on MS Teams. 
To be able to run the main script, you should download these files first. 
The file names are:
 * ketapang_palm_2023_90.tif
 * managed_forst_data.zip
 * west_kalimantan_forest_loss.tif
 * west_kalimantan_forest_loss_year.tif
 
After downloading, you should place these files in the data folder. 
The data folder is created in the main.R, so you can only put the downloaded files in there after you run the first part of the main script that creates the necessary directories.

## Install necessary packages in R
install.packages("sits")
install.packages("sf")
install.packages("terra")
install.packages("dplyr")
 
## Usage
Run the main.R file 

explain the output of the main.R file and include some examples (screenshots of maps/ouput)


## Contributing
The code was created by the Bali starlings team, consisting of:
* Joëlle van Drie
* Jan Müldner
* Pascal Dubbelman
* Tosca Koeze

## License
The project is distributed under the MIT license, more information on the license can be found in the LICENSE.txt file.

## Contacts

## Acknowledgements 
The original idea for this project came from Space4Good. This company is among other things involved in deforestation monitoring for various Indonesian entities.
Throughout the creation of this project we were in contact with Ramadhan from Space4Good, whom provided us with very helpful feedback.

This project was created by students from Wageningen University and Research during the course Geoscripting. 



