# Picocell Impact Analysis
## Problem Description
Our company has deployed some new network technology called Picocells in a particular area as a showcase.
The technology team is interested in whether or not the deployment of these additional Picocells in an area with existing cell coverage helped drive/enable additional data usage from our wireless subscribers. 
You are acting as the data scientist consultant who is in charge of helping with this project.

For this analysis, the engineering team has collected for you data usage traffic by day:  
a)	from the specific macro sites in the immediate nearby area overlapping with the Picocells  (some sectors from macro sites YY1290, YY0104, YY1755 that point towards the picocells area)  
b)	from the Picocells  
c)	from other macro sites in the city (possibly to help with understanding seasonality/growth trends)

The picocells were deployed over a one week period starting July 11, 2016. So a few were installed each day over the course of a week.

What we want to do is determine if there is a “lift”/increase in the total traffic in the area under study where the Picocells were deployed that can be attributed to addition of the Picocells.

## Data provided  
Total_UL_DL_PICO_MACRO.xlsx
-	DOWNLOAD & UPLOAD figures are usage from some sectors from macro sites YY1290, YY0104, YY1755 that point towards the picocells area
-	DL_PICO & UL_PICO figures are usage from the picocells introduced in the area
-	Together this forms the area we want to study

other_cells_data_no_sector.xlsx
-	data_ul & data_dl figures are usage from macros sites in the city (you need to exclude macro sites YY1290, YY0104, YY1755 if you are looking for sites that are not part of the picocell area)
