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

## Data Provided  
Total_UL_DL_PICO_MACRO.xlsx
-	DOWNLOAD & UPLOAD figures are usage from some sectors from macro sites YY1290, YY0104, YY1755 that point towards the picocells area
-	DL_PICO & UL_PICO figures are usage from the picocells introduced in the area
-	Together this forms the area we want to study

other_cells_data_no_sector.xlsx
-	data_ul & data_dl figures are usage from macros sites in the city (you need to exclude macro sites YY1290, YY0104, YY1755 if you are looking for sites that are not part of the picocell area)

## Solution
To determine the impact of the picocell installation the following methods were applied:

### 1) Dynamic Time Warping   
This technique is used to determine what macros from other sites most similarly resemble the impacted macros prior to the picocell installation. The macros chosen to be most similar will form our control group.  
Reference: https://github.com/klarsen1/MarketMatching

### 2) Causal Impact  
This technique builds a Bayesian structural time-series model on the control group (i.e. the non-impacted group) with the impacted group as the response variable using only the pre-impact period for training. Using the model built from the control group, we try and predict the response variable in the post-impact period to determine what the response values would have been had there been no intervention.   
Reference: https://google.github.io/CausalImpact/CausalImpact.html


