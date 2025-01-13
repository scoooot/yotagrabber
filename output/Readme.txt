This folder contains the dealer inventory for all Toyota vehicle models in the US (including Alaska, and Hawaii).

Inventory updates typically show up each day at 4am CDT.
Each model's inventory is placed in a .csv file.  A raw pandas parquet file is also created which is 
the raw inventory gotten from the Toyota website for the model before various fitlering is applied, such as only current and 
last year vehicles, certain fields are removed, some field names and content are modified for readability, etc)

A log file InventoryRunlog.txt is also provided which indicates when the inventory search started as well as if the
program could not find all the inventory for a given model as well as how many vehicles were missing for that model in that case.
Note that as each page of vehicle inventory is gotten for a given model, the total records (total number of vehicles for that 
model that will be returned over the total number of pages indicated for that model ) the website returns can change 
on the fly.  So sometimes when we get close to the end of the inventory pages for a model, we may miss a few just newly added 
vehicles.  These will then show up the next time the inventory search is run.


Column definitions that are not obvious or to remove any ambiguity are as follows:
"Base MSRP" -  Is as shown on the cars window sticker and is the Base manufacturer retail price 
"Total MSRP" -  Also referred to as the Total SRP (Suggested Retail Price) as shown on the cars window sticker is the 
                Base MSRP + all the factory and Port installed options/packages + delivery/handling fees  
                (excludes taxes and other fees like Doc fee, registration fees, etc)
"Selling Price" -  is the total price (excluding taxes, fees) = Total MSRP + Dealer installed options + Dealer Markup/Discount
"Selling Price Incomplete" - Indicates if the Selling Price is incomplete. When incomplete the price 
                             does not include the Dealer Markup/Discount as it was unknown.
"Markup" - Dealer installed options plus Dealer Markup/Discount (i.e everything above the Total MSRP)
"TMSRP plus DIO" -  Total MSRP plus Dealer installed options
"Shipping Status" - "Factory to port" -  In production, or on the ship, or sitting at the port
                    "Port to dealer" -  Checked in at the port and in the process of moving from the port to the dealership lot. Usually From and To Date will now appear
                    "At dealer" - The car is at the dealer
                    The above "Shipping Status" defintions were copied and pasted from another developers spreadsheet

For issues or questions contact ghgemmer@gmail.com
See github repository https://github.com/ghgemmer/yotagrabber
for the source code for this forked project.
