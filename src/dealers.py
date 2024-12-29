# Updates the dealer info in teh dealers.csv file

import random
from inputimeout import inputimeout, TimeoutOccurred
import sys
import json
import os.path
import ssl
import requests.exceptions
import requests
import pandas as pd

forceRspFailureTest = 0 # set to > 0 to perform tests related to forcing a response failure to test request retry

def interruptibleSleep(sleepTime):
    wasInterrupted = False
    if sleepTime > 0:
        try:
            x = inputimeout(prompt='', timeout=(sleepTime))  # removed int(sleepTime) to get finer resolution when 1 second or so sleep times
            wasInterrupted = True
            print("Interrupted Sleep")
            if chr(9) in x: # Ctrl I, as Ctrl C does not seem to work even when KeyBoardInterrupt except used
                raise SystemExit #RuntimeError # as termination mechanism as KeyBoardInterrupt does not seem to work
        except TimeoutOccurred:
            pass
    #else:
    #    print("Interruptible Sleep time was 0")
    return wasInterrupted


def updateDealers(dealerFileName, zipCodeFileName):
    print("This program takes the passed csv file and creates a new output csv file with added suffix .updated.csv") 
    print("that contains the contents of the passed csv file and dealer info for any new dealer found, not already in the csv file")
    print("for the set of zipcodes it is passed")
    print("Warning !!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    print("When the set of zipcodes is very large, (possibly 42,000), this program will take a long time to run")
    print("The program takes approx 4 seconds for each zipcode and every 100 zip codes an additional 30 seconds")
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    print("Reading in zipcodes to get dealer info for from file", zipCodeFileName)
    zipCodesToUpdateDealers = []
    with open(zipCodeFileName, "r") as fileh:
        for zip in fileh:
            zip = zip.strip(" \n\r")
            if zip:
                if (len(zip) <= 5) and zip.isdecimal():
                    zipCodesToUpdateDealers.append(zip)
                else:
                    print("Ignoring Invalid zip code '" + zip + "'")
    print("Reading in existing Dealer csv", dealerFileName)
    dealers = pd.read_csv(dealerFileName)
    num = 0
    for zipCode in zipCodesToUpdateDealers:
        zipCodeWithLeadingZeroes = ("0" * (5 - len(zipCode))) + zipCode
        print("Getting dealers for/near zipcode",zipCodeWithLeadingZeroes )
        resp = requests.get(
                "https://www.toyota.com/service/tcom/locateDealer/zipCode/" + zipCodeWithLeadingZeroes,
                timeout=20,
        )
        result = resp.json()
        if (result is not None) and result and ("dealers" in result):
            df = pd.DataFrame.from_dict(result["dealers"])
            df = df[["code", "dealerId", "name", "url", "regionId", "state", "lat", "long"]]
            #print(df)
            dealers = pd.concat([dealers, df])
            dealers.drop_duplicates(subset=["code"], inplace=True)
        else:
            print("Error: Failed getting dealers near zipcode.  Response is not json format or does not contain a 'dealers' field.  ZipCode checked was", zipCodeWithLeadingZeroes)
        num += 1
        if (num % 100) == 0:
            # Since the number of zipCodesToUpdateDealers could be very large,  i.e. 42000, 
            # we periodically update the output csv with what we have so far in case we are terminated
            dealers.to_csv(dealerFileName + ".updated.csv", index=False)
            # delay a longer period of time so we don't swamp the toyota website
            sleepTime = 30
            print("Sleeping", sleepTime)
            interruptibleSleep(sleepTime)
        # delay a bit since the number of zipCodesToUpdateDealers could be very large
        # and we don't want to swamp the toyota website otherwise our connection could be closed/denied or worse
        # we could be blacklisted for some period of time
        interruptibleSleep(4)
    dealers.to_csv(dealerFileName + ".updated.csv", index=False)
if __name__ == "__main__":
    import sys
    # pass dealer file name
    dealerFileName = sys.argv[1:][0]
    zipCodeFileName = sys.argv[1:][1]
    updateDealers(dealerFileName, zipCodeFileName)
