# Country Viewer Shiny App

This repository contains an interactive web application developed using R Shiny, Leaflet, and PostgreSQL/PostGIS. The app allows users to visualize country-level geospatial data and perform advanced spatial operations such as buffering and intersection. It also provides the option for users to upload their own shapefiles, overlaying them on the existing map data for comparison.

![App Screenshot](./image)

## Key Features

### 1. Interactive Map with Country Highlighting
- The map displays countries using data stored in a PostGIS database. Users can hover over any country to see its name displayed in a popup.
- The map is rendered using the `leaflet` package, providing panning, zooming, and interactivity.

### 2. Buffering and Intersection Spatial Operations
- The application performs spatial operations such as:
  - **Buffering:** A buffer is applied to certain countries, expanding their boundaries by a user-defined distance.
  - **Intersection:** The intersection between specific countries is calculated and visualized on the map.

### 3. Shapefile Upload and Display
- Users can upload their own shapefiles (in `.zip` format) containing `.shp`, `.shx`, and `.dbf` files. These shapefiles are then displayed on the map alongside the existing geospatial data.

### 4. Optimized Database Queries
- PostgreSQL/PostGIS is used to store and retrieve spatial data efficiently. The app uses memoization to cache frequently accessed data for improved performance.

### 5. Caching Mechanism
- The application employs caching using the `memoise` package to speed up queries for frequently requested geographic areas, reducing redundant processing and improving user experience.

## Dataset and Source
The spatial dataset used for this application is from [Natural Earth](https://www.naturalearthdata.com/downloads/10m-cultural-vectors/), specifically the **Admin 0 – Countries** dataset. This dataset provides detailed geometry for country boundaries, and the data is stored and queried from a PostGIS-enabled PostgreSQL database.

## Technologies and Packages Used
- **R Shiny:** For the web application framework.
- **Leaflet:** For rendering interactive maps.
- **PostgreSQL/PostGIS:** For storing and querying geospatial data.
- **sf (Simple Features):** For handling spatial data in R.
- **memoise:** For caching results of expensive queries.
- **shinyFiles:** For allowing shapefile uploads and processing.

## Objective
This Shiny app demonstrates the integration of spatial data visualization, advanced PostGIS operations, and user interactivity through a clean and responsive interface. It is designed to showcase proficiency in handling spatial data, performing geographic queries, and developing interactive web applications using R Shiny.
