# Load necessary libraries and packages
library(shiny)
library(RPostgres) # For connecting to PostgreSQL
library(leaflet) # For interactive maps
library(sf) # For spatial data handling
library(memoise) # Optimizing function performance 

# Connect to the PostgreSQL/PostGIS database
connect_db <- function(){
  con <- dbConnect(
    RPostgres::Postgres(),
    dbname = 'spatial_data', # Database name
    host = 'localhost', # Running locally
    port = 5432, # Default PostgreSQL port
    user = 'lidiaacosta', # PostgreSQL username
    password = 'sm2905' # Your PostgreSQL password
  )
  return(con)
}

# Memoise function to fetch data from the database
get_countries_data <- memoise(function(con) {
  query <- 'SELECT name, geom FROM public.countries;'
  countries_sf <- st_read(con, query = query) # Read data as an sf object
  return(countries_sf)
})

# Define the buffered countries function
get_buffered_countries <- function(con) {
  query <- "SELECT name, ST_Buffer(geom, 0.5) AS geom FROM public.countries WHERE name = 'Canada';"
  buffered_countries <- st_read(con, query = query)
  return(buffered_countries)
}

# Define the intersections function
get_intersections <- function(con) {
  query <- "SELECT a.name, ST_Intersection(a.geom, b.geom) AS geom
            FROM public.countries a, public.countries b
            WHERE a.name = 'Canada' AND b.name = 'United States';"
  intersections <- st_read(con, query = query)
  return(intersections)
}

# Define UI for the Shiny app
ui <- fluidPage(
  titlePanel('Interactive Countries Map'),
  sidebarLayout(
    sidebarPanel(
      h3('Welcome to the Countries Map Viewer'),
      fileInput("shapefile", "Upload Shapefile (ZIP)", accept = ".zip"),  # File upload for shapefiles
      p("Upload a ZIP file containing .shp, .shx, and .dbf files.")
    ),
    mainPanel(
      leafletOutput('map') # Output for the Leaflet map
    )
  )
)

# Define the server logic
server <- function(input, output){
  
  # Connect to the database when the app is launched
  con <- connect_db()
  
  # Fetch the regular spatial data from the database
  countries_data <- get_countries_data(con)
  
  # Fetch buffered and intersection data
  buffered_countries <- get_buffered_countries(con)  # Calling the function here
  intersections <- get_intersections(con)  # Calling the function here
  
  # Create the Leaflet map and render it
  output$map <- renderLeaflet({
    leaflet(countries_data) %>%
      addTiles() %>%
      addPolygons(data = countries_data, 
                  color = 'blue', 
                  weight = 1, 
                  opacity = 1, 
                  fillColor = 'lightgreen', 
                  fillOpacity = 0.7,
                  highlight = highlightOptions(
                    weight = 5, 
                    color = 'yellow', 
                    fillOpacity = 0.9, 
                    bringToFront = TRUE
                  ),
                  label = ~name,  # Simply use the name column
                  labelOptions = labelOptions(
                    style = list("font-weight" = "bold", "color" = "black"),
                    textsize = "12px",
                    direction = "auto"
                  )
      ) %>%
      # Add the buffered geometry
      addPolygons(data = buffered_countries, 
                  color = 'red', 
                  weight = 2, 
                  fillColor = 'orange', 
                  fillOpacity = 0.5, 
                  label = ~name) %>%
      # Add the intersection geometry
      addPolygons(data = intersections, 
                  color = 'purple', 
                  weight = 2, 
                  fillColor = 'pink', 
                  fillOpacity = 0.7)
  })
  
  # Disconnect from the database when the app closes
  onStop(function() {
    dbDisconnect(con)
  })
}

# Run the Shiny app
shinyApp(ui = ui, server = server)