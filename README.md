# yotagrabber

Forked version of major/yotagrabber (major/yotagrabber gets inventory data from Toyota's GraphQL endpoints and
periodically updates and posts csv data files on all the toyota models with that inventory data)

Contains updates due to Toyota website changes and graphql field changes.

Additionally, added higher level search program searchForVehicles.py that can notify the user via any combination of sound, email, text
whenever changes in the inventory data occur for a specified match criteria.  This allows a user to be alerted whenever what
they are looking for has changed and then look at the attached log file to view the changes.  That program uses a config YAML file that can specify how often to search, 
sound file options, texting options, email options, as well as how changes are reported, and log file options.  

searchForVehicles.py runs the vehicles.py update_vehicles() method to collect an inventory of all vehicles in the US for a desired model
and then runs a specified match criteria against that looking for specific vehicles.  Whenever any inventory changes occur for
that match criteria the program notifies the user via any user specified combination of sound, email, text.
Currently the user specifies the match criteria in the code by overriding the searchForVehicles.py userMatchCriteria.filterDataFrame
method although eventually that criteria would be specified in the config file.

I do not currently run the scripts to update and post the model csv data files at this time.

