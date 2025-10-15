## Geoscripting project repository.

- Title: **Identifying Commodity Concession Mismatches in the North Kayong Regency of Indonesia**
- Subtitle: Uncovering where forest cover loss and oil palm planting occur outside of designated concession areas using geo-data sets, scripting, and visualization
- Team name and members: **Bali Starlings; Jan Müldner, Joelle van Drie, Tosca Koeze, Pascal Dubbelman**
- Challenge number: **Challenge 1**
- Description on how to run/reproduce can be found under ## Getting started

## About the project
The aim of our project is to construct reproducible code which will be able to identify discrepancies between legal concessions issued and open-source land cover/change maps for two major commodities managed in Indonesia: legal timber and oil palms, both crucial for habitat management & conservation efforts in Indonesia.
In addition to identifying these mismatches and providing a quick statistical overview regarding their occurrence and extent; an interactive map is produced, allowing the user to visually engage with individual data sets and mismatches as optional layers.

The objectives of the project are comparing open-source datasets, such as oil palm plantations as attributes of land cover maps, with official concession boundaries related to their legal planting (or, logging in terms of timber). To minimize extent and reach feasible data sizes, the project is focused on the North Kayong (Kayong Utara) regency of Kalimantan Island, Indonesia, which is defined as our **ROI**.The analyzed datasets are clipped to its extent through our script. Initially, we acquire concessions as polygon features (shapefiles, geojson files) for both commodities separately using data sets published by the Global Forest Watch (GFW). The oil palm concessions are available as a single data set, but for timber, the authorized areas of logging and wood management are divided into two categories. The first are Managed Forest concessions, downloaded from (GFW). They refer to areas allocated by a government for harvesting timber and other wood products in a public forest. The second are Wood Fiber concessions for Indonesia, which are issued locally for the exclusive production of pulp and paper products, also available from GFW. Both timber data sets are merged into one timber concessions data set with the merge_timber function.

Next, two open-source datasets are downloaded for obtaining the recent state of oil palm plantations, as well as forest cover loss, which should both not take place outside of authorized areas. For timber, a raster data set containing yearly tree cover loss in Indonesia is obtained from Google Earth Engine (GEE) under the Hansen model for the years 2000-2024, later filtered only for the years 2019-2024.  For oil palms, the open-source data set called “Palm probability model 2025a” was obtained from GEE. Both of the GEE acquired data sets were downloaded through jupyter notebook scripts, which are included in the Python directory. As this was a probability model, a threshold of <90% was set to ensure that all mismatches identified later are truly oil palm-based. Similarly, the probability model works with a 10 m resolution precision, meaning that despite the above-mentioned threshold, occasionally, single pixels are identified as oil palms, despite being in the middle of the thick and diverse rain forests, which are certainly not plantations. To avoid a large number of faulty thresholds resulting from single (or a few) pixels; a threshold of >10 000 m*2 is applied (more than ten pixels sharing area).

All data sets were chosen so that concession year matches the occurrence year as closely as possible. Their dates and other relevant information is further described under #Metadata.

The following **table** demonstrates the intended data structure further, as it lists which types of data are sourced and used for both commodities and their concessions/occurrence.

| **Commodity**               |    **Concessions data**     |        **Occurrence data**       |
| ---------------------------:| ---------------------------:| --------------------------------:|
| **Timber**                  | Managed forests, wood fiber |         Forest cover loss        |
| **Oil palm**                |    Oil palm concessions     |     True oil palm occurrence     |

After data sets are acquired and processed, the script identifies all mismatches within the extent of the project and calculates statistics for them. It returns the following statistics: the total number of mismatch polygons, the total area of the mismatches within the extent (km²), the % of forest loss/oil palm planting outside of concessions areas, the mean area of a mismatch polygon (km²),  the standard deviation of the results, and the total area of the mismatches expressed in number of football fields. It stores the statistical results in tabular form as .csv files in the "output" directory. It also stores the mismatch polygons as .geojson files in the output directory, allowing the end user to handle mismatches directly if desired, since they are the primary output. Finally, the Shiny R package is used to create a temporary Web with a interactive map. With the use of ESRI-provided satellite imagery, the map comprehensively illustrates mismatches on top of original data sets, allowing the user to view them individually/together by selecting optional layers. It includes a description for all data sets on the top left, as well as having general map features, such as the legend, scale, or zoom-in/out feature. This final map makes it possible to interpret the mismatches on a visual level, rather than just knowing where they occur, allowing for deeper insight, possibly cause determination and reasoning.

The project will support it's aims through the following 4 research questions:
* Q1: What percentage of forest loss occurs outside of managed forests & wood fiber concessions?
* Q2: What percentage of oil palm plantations are grown outside of their designated concession areas?
* Q3: How many mismatch cases are identified, where are they happening, and what are the statistical dependencies behind them?
* Q4: Through use of satellite imagery, which new insights can be derived from the ten largest mismatches for each commodity? Can visual inspection of such imagery be used for the interpretation of the causes for mismatch when displayed through an interactive map?

## Getting started
### Open a terminal
### Make sure git is installed
### Clone the git repository with an HTTPS
git clone https://git.wur.nl/geoscripting-2025/staff/project/Project_Starter-Bali_starlings.git

### Set the working directory to the project directory
Use either of the following examples (or your own preferred method) to navigate to the correct directory:
- cd Project_Starter-Bali_Starlings (in terminal)
- setwd() function in R

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

Now, all necessary data will be ready in "data" for when the full main.R is run later on (see below "Usage").

## Install necessary packages in R
install.packages("sf")
install.packages("terra")
install.packages("dplyr")
install.packages("shiny")
install.packages("leaflet")
 
## Usage
Run the full main.R file. The script was developed in RStudio, so we recommend using it as the default IDE. The following should happen as result:
- The mismatches identified by the script will be stored as .json files (as polygons) in the "output" directory.
- The statistical results will be stored as a .csv files (per commodity) in the "output" directory.
- A window will pop up with the Shiny Web Application with a box suggesting "open in Browser". Click on it and an interactive, visual map should open up.

The Shiny Web Application may be navigated using the cursor. In the main screen, a base satellite imagery map is displayed. On top of it, several layers may be displayed, if selected in the box on the far left which includes layers, such as mismatches or . It is recommended to zoom in onto mismatches, since the extent of the Kayong province is still rather large. The +/- icons on the top of the map may be used to do so. The map is centered with true north at the top, and loads with all layers "turned on" on default apart from the 10 significant mismatches. The bottom of the map also displays the table with statistical results, which are connected to the layers displayed, and can therefore be turned on/off based on layer selection.

A few examples/screenshots of output may be found below:

![An overview of the interactive map as a screenshot from the Shiny Web Application](/Images/ExampleOutputMap.png)

![A more detailed view covering individual concession polygons from output map](/Images/ExampleOutputMap_2.png)
## Contributing
The code was created by the Bali starlings team, consisting of:
* Joëlle van Drie
* Jan Müldner
* Pascal Dubbelman
* Tosca Koeze

## License
The project is distributed under the MIT license, more information on the license can be found in the LICENSE.txt file.

## Acknowledgments 
The original idea for this project came from Space4Good. This company is among other things involved in deforestation monitoring for various Indonesian entities.
Throughout the creation of this project we were in contact with Ramadhan from Space4Good, whom provided us with very helpful feedback.

This short-term project was created by students of Wageningen University and Research under the course Geoscripting. 

## Contacts
If you have any questions, you can contact the following email address: 
joelle@dontcontactme.gmail.com

# Sources and metadata

## Data sets sourced (metadata)
**Kayong regency extent:** 
- Obtained from geoBoundaries using the following link: https://www.geoboundaries.org/simplifiedDownloads.html and specifying the following:
- Name: Indonesia
- ISO-3: IDN
- Type: ADM2
- Year: 2020
- Source: BPS Statistics Indonesia

**Oil palm concessions:**
- URL: https://data.globalforestwatch.org/datasets/gfw::indonesia-oil-palm-concessions/about
- Title: Indonesia oil palm concessions
- Author: Indonesia Ministry of Forestry, Greenpeace, and WRI, accessed through Global Forest Watch (GFW)
- Date: published February 15 2015, data last updated on October 10 2023
- Extent: Indonesia
- Resolution: at best 2 meters
- Access: can be accessed via a download link
- Size: 12.3 MB as a GeoJSON
- Limitations: This data set is known to be incomplete, but it is currently the best available.

**Legal timber concessions (both data sets):**
- URL: https://data.globalforestwatch.org/search?tags=logging%2520concessions **AND** https://data.globalforestwatch.org/datasets/gfw::indonesia-wood-fiber-concessions/about
- Author: Global Forest Watch (GFW) (for both)
- Date: published on 14 December 2021, last updated on 27 December 2023 **AND** 2nd April 2019, last updated on 2nd April 2019
- Extent: worldwide (however, converted to .gpkg and clipped to extent of Indonesia) **AND** the extent of Indonesia
- Resolution: at best 2 meters
- Can both be accessed via download link 
- Size: 7.28 MB (after clipping) **AND** XX MB

**Oil Palm Probabilty Model ( oil palm occurrence)**
- name: Palm Probability model 2025a
- author: Forest Data Partnership
- publish date: 2025
- extent covers the following countries: Indonesia, Malaysia, Thailand, Nigeria, Colombia, Brazil, Côte d'Ivoire, Ghana, Ecuador, and Honduras
- resolution: 10 meters

**Forest Cover Loss**
- name: Global Forest Change
- authors: Hansen, M. C., P. V. Potapov, R. Moore, M. Hancher, S. A. Turubanova, A. Tyukavina, D. Thau, S. V. Stehman, S. J. Goetz, T. R. Loveland, A. Kommareddy, A. Egorov, L. Chini, C. O. Justice, and J. R. G. Townshend.
- first published: 15 november 2013
- last updated: 2024
- data from: 2000-2024 (filtered out to 2019 to 2024)
extent: whole world
resolution: 30.92 meters
  
## Sources for packages used
- citation sf package: Pebesma E, Bivand R (2023). Spatial Data Science: With applications in R. Chapman and Hall/CRC. doi:10.1201/9780429459016, https://r-spatial.org/book/
- citation terra package: Hijmans R (2025). terra: Spatial Data Analysis. R package version 1.8-73, https://github.com/rspatial/terra
- citation dplyr package: Wickham H, François R, Henry L, Müller K, Vaughan D (2025). dplyr: A Grammar of Data Manipulation. R package version 1.1.4, https://dplyr.tidyverse.org
- citation shiny package: Chang W, Cheng J, Allaire J, Sievert C, Schloerke B, Aden-Buie G, Xie Y, Allen J, McPherson J, Dipert A, Borges B (2025). shiny: Web Application Framework for R. R package version 1.11.1.9001, https://github.com/rstudio/shiny
- citation leaflet package: Cheng J, Schloerke B, Karambelkar B, Xie Y, Aden-Buie G (2025). leaflet: Create Interactive Web Maps with the JavaScript 'Leaflet' Library. R package version 2.2.3.9000, https://rstudio.github.io/leaflet/
- citation base64enc package: Urbanek S (2024). base64enc: Tools for base64 Encoding. R package version 0.1-4, https://www.rforge.net/base64enc

## Sources used for visualization
- https://www.rdocumentation.org/packages/shiny/versions/1.11.1
- https://www.geeksforgeeks.org/r-language/shiny-package-in-r-programming/
- https://www.rdocumentation.org/packages/leaflet/versions/2.2.2
- https://www.geeksforgeeks.org/r-language/leaflet-package-in-r/
- For background satellite imagery: Leaflet │ Titles © Esri -- Source: Esri, I-cubed, USDA, USGS, AEX, GeoEye, Getmapping, Aerogrid, IGN, IGP, UPR-EGP, and the GIS User Community

## Jupyter Notebook sources
- geemap citation: Wu, Q., (2020). geemap: A Python package for interactive mapping with Google Earth Engine. The Journal of Open Source Software, 5(51), 2305. https://doi.org/10.21105/joss.02305
- Gorelick, N., Hancher, M., Dixon, M., Ilyushchenko, S., Thau, D., & Moore, R. (2017). Google Earth Engine: Planetary-scale geospatial analysis for everyone. Remote Sensing of Environment, 202, 18-27. https://doi.org/10.1016/j.rse.2017.06.031

## General sources
- https://www.rdocumentation.org/packages/xfun/versions/0.11/topics/file_ext
- https://stackoverflow.com/questions/3402371/combine-two-data-frames-by-rows-rbind-when-they-have-different-sets-of-columns
- https://www.datacamp.com/doc/r/merging
- https://stackoverflow.com/questions/79343873/cropping-in-sf-flat-space-vs-spherical-geometry-and-sf-use-s2
- Complete use of sources may also be found as in-line description in the script files

## AI source, version, release date
- Miscrosoft Copilot (Unified Branding, 1.25095.161.0), release date: October 2025
- ChatGPT-4o (GPT-4 Optimized), release date: October 2025
- Claude (Claude Sonnet 4), release date: October 2025
- Gemini (Gemini 2.5 Pro), release date: June 2025
- Grok (Grok 4), release date: July 2025

AI was used for generating script ideas, writing code snippets, troubleshooting errors (mainly!), and improving documentation during the geoscripting project.

## Geoscripting tutorials sources
- Link: https://geoscripting-wur.github.io/
- Authors: Jan Verbesselt, Dainius Masiliūnas, Arno Timmer
- Last updated: 2025-08-18
