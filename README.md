# yotagrabber

Forked version of major/yotagrabber (major/yotagrabber gets inventory data from Toyota's GraphQL endpoints and
periodically updates and posts csv data files on all the toyota models with that inventory data)

Contains updates due to Toyota website changes and graphql field changes.

Additionally, added higher level search program searchForVehicles.py that can notify the user via any combination of sound, email, text
whenever changes in the inventory data occur for a specified match criteria.  This allows a user to be alerted whenever what
they are looking for has changed and then look at the attached log file to view the changes.  That program uses a config YAML file that can specify how often to search, 
sound file options, texting options, email options, how changes are reported, log file options, etc.  

searchForVehicles.py runs the vehicles.py update_vehicles() method to collect an inventory of all vehicles in the US for a desired model
and then runs a specified match criteria against that looking for specific vehicles.  Whenever any inventory changes occur for
that match criteria the program notifies the user via any user specified combination of sound, email, text.


I do not currently run the github workflow to update and post the model inventory csv data files at this time.
I have been trying to get that github workflow to run for this but it seems like the main problem is that
github is having problems communicating with the toyota website by either being blocked sometimes, or getting connection failures/forced closures, or continuous response timeouts.
Possibly the website has been in the past seeing too much traffic from github and is throttling it or blocking it sometimes.
I don't seem to have these problems when running these updates on my desktop for just a few vehicle models. 
To that end I have a power shell script, Get-ToyotaInventory.ps1 that when scheduled as a job does the same thing as the github workflow
(short of the adding the resulting found inventory to the git repository yet) and runs from the desktop.
See Invocation.txt as to how to invoke the various programs.

