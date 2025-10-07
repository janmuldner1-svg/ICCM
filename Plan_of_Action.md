Plan of Action Project Week

Reproducible for other regions in Indonesia

By Wednesday evening: Basic code to retrieve datasets and dataset for extent fixed.
Use shiny for visualization? -> Pascal will look into it.

Day 1

* Review Datasets
* WGS 84 and local Indonesia One CRS
* Message contact person S4G
* Create project structure (main, directories)

Pascal - Do GEE tutorial and download missing datasets


Project Structure:

Main file
    import functions

Day 2

* Extent as clippable dataset: The ADM1 for Indonesia url downloads a .shp with polygons as individual provinces. We want to extract West-Kalimantan from it only, and then define it as a new variable with geometry features stored. Once done, review the output .shp in QGIS, should only view the West-Kalimantan province.
* Add all datasets, start clipping each one to the above mentioned extent.
* Look into exercises/tutorials and see what we would be using to identify mismatches (ex. with Matto Grosso state and agricultural land could be useful for this)
* Look at reply from Rhamadan, if we get one
* Look at how we could visualize end product (Shiny?)



