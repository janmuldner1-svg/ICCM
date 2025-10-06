
# Geoscripting project proposal
- Title: **Checking Timber Permit and Oil Palm Concession Boundaries with Remote Sensing in Indonesia**
- Both (old) team names: **Jan_Pascal + rebel_impossible_mantis**
- Name of the new full team: **Bali Starlings**
- Number of the topic chosen (or "own"): **CHALLENGE 1**

## (1) Objective and research questions
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

## (2) Data (what?)

## Province boundaries
- URL: https://www.geoboundaries.org/simplifiedDownloads.html

# Official concessions:
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

**Legal timber logging concessions:**
- URL: https://data.globalforestwatch.org/search?tags=logging%2520concessions AND https://data.globalforestwatch.org/datasets/gfw::indonesia-wood-fiber-concessions/about
- Author: Global Forest Watch (GFW) (for both)
- Date: published on 14 December 2021, last updated on 27 December 2023 AND 2nd April 2019 for Wood fiber concessions, last updated on the same day
- Extent: worldwide (however, converted to .gpkg and clipped to extent of Indonesia) AND the extent of Indonesia
- Resolution: at best 2 meters
- Can be accessed via a download link 
- Size: 7.28 MB (after clipping) AND xxx MB

# Open source land cover maps for deforestation and oil palms:
**Open-source dataset for oil palm:**
- URL: https://platform.indonesia.mapbiomas.org/coverage/coverage_lclu?t[regionKey]=indonesia&t[ids][]=4-1-1&t[divisionCategoryId]=2&tl[id]=1&tl[themeKey]=coverage&tl[subthemeKey]=coverage_lclu&tl[pixelValues][]=40&tl[pixelValues][]=35&tl[pixelValues][]=9&tl[pixelValues][]=21&tl[pixelValues][]=30&tl[pixelValues][]=24&tl[pixelValues][]=25&tl[pixelValues][]=3&tl[pixelValues][]=5&tl[pixelValues][]=76&tl[pixelValues][]=27&tl[pixelValues][]=13&tl[pixelValues][]=31&tl[pixelValues][]=33&tl[legendKey]=default&tl[year]=2024
- Author: MapBiomas Indonesia
- Date: published 08/2025, data from 1990-2024
- Extent: Indonesia 
- Resolution:
- Access: 
- Size:

**Deforestation (as part of) land use maps:**
/// likely Google Earth Engine or Nusantra Atlas, we hope to make this clear at the start of next week to have all datasets defined

# Remote sensing data:
**Remote sensing imagery:**
- We have chosen for Sentinel 2 data, since it has a higher resolution, provides more frequent images (to help with cloud-free coverage) and we have worked before with the sits package in R, which gets satellite data from Google Earth Engine. 
- Author: 
-   Data producer: European Space Agency (ESA) (part of Copernicus programme)
-   Provider: Google Earth Engine (GEE)
- Date: Since 2015-present
- Extent: Most of the world, so this will include the entirety of our research location: Indonesia
- Resolution: depending on the bands, 10-60 meters
- Size: ~ 250 mb. We are hoping to get it below 500 mb by selecting our roi, selecting bands and potentially reducing spatial resolution/compressing the data if it is still too big.

## (3) Methods

First we will import official concession shapefiles containing timber permits and oil palm concessions. We will overlay them with the open source data, and check if they align. 
Code will be written to identify mismatches (e.g. concessions overlapping with primary forest) and the percentage and area (km2) of mismatches compared to the total extent of our area will be calculated. We will document the two most significant cases where the concession polygon does not match the open source data per commodity. In addition to this, we will visually inspect these cases using remote sensing data to identify potential causes for the mismatch and to determine which data source is more accurate.

We are not certain about all packages we will use, but we will most probably make use of the following:
- geopandas for handling vector data (overlays, intersections, mismatches)
- rasterio for reading and clipping our raster data
- shapely (haven't used it yet, but it seems to be used often for geometry operations)
- numpy for numerical/statistical analysis or calculations

Result/output:
Upon running, our script calculates the percentage of mismatches between the different data-sources (concession boundaries and open source data) for both oil-palm and timber. Furthermore, it will display general statistics (such as total mismatch area in km2, number of mismatches, their mean size, SD, ...) and ideally, it should also return the two "worst" cases of a mismatch, which it will also graphically plot out, most likely using MatPlotLib. In addition to this, we will visually inspect these mismatches and make use of remotely sensed imagery to find out why these mismatches occur.
