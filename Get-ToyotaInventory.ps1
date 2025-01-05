# Gets list of Toyota models, current inventory for each model in the US
# and commits all this to git

function Get-VehicleModels {
    # Gets a list of all models (fields modelCode, Title) and writes it to the json file output/models.json
    poetry run update_models
}

function Get-VehicleInventoryForModels {
    param (
        $DirectoryToRunIn,
        $PythonVENVPowershellActivateScript
    )
    # Use the following to log all console output as it is consistent in doing this over the inconsistent Start-Transcript
    # Note that the console output is redirected to the log file so you want see it as it is running unless
    # you use some linux like tail function, like the power shell 
    # Get-Content -Path filename -Tail 0 -Wait in another window to output the logfile contents as it is appended.
    $logfile = $DirectoryToRunIn + "\output\InventoryRunlog.txt"
    Get-VehicleInventoryForModelsA -DirectoryToRunIn $DirectoryToRunIn -PythonVENVPowershellActivateScript $PythonVENVPowershellActivateScript  *>> $logfile
}


function Get-VehicleInventoryForModelsA {
    param (
        $DirectoryToRunIn,
        $PythonVENVPowershellActivateScript
    )
    cd $DirectoryToRunIn
    $env:PYTHONUNBUFFERED = 1
    Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
    .$PythonVENVPowershellActivateScript
    # break out of this for testing by uncommenting the following
    # Return
    $timeout = 60*3
    # Get a list of all the current models first
    $curDate = Get-Date
    Write-Host "Started Power Shell Inventory search at" $curDate
    Write-Host "Getting list of Vehicle Models"
    Get-VehicleModels
    if ($LASTEXITCODE -eq 0) {     
        $models = Get-Content -Raw -Path "output/models.json" | ConvertFrom-Json
        Write-Host "Sleeping $timeout seconds before next operation"
        Start-Sleep -Seconds $timeout
        
        Write-Host "Getting list of Vehicle Inventory"
        foreach ($model in $models) {
            # set environment variable that update_vehicles uses
            $env:MODEL = $model.modelCode
            # Update that models inventory
            Write-Host "Getting inventory for $env:MODEL "
            poetry run update_vehicles
            if ($LASTEXITCODE -ne 0) { 
                Write-Host "Error: Failed to get inventory for model $MODEL"
            }    
            Write-Host "Sleeping $timeout seconds before next operation"
            Start-Sleep -Seconds $timeout
        }
        
    }
    else
    {
        Write-Host "Error: Failed to get list of Vehicle Models"
        Write-Host "Sleeping $timeout seconds before next operation"
        Start-Sleep -Seconds $timeout
    }
    if ( 1 -eq 0) {
        # TODO: Upload the inventory files to google drive.
        py upload-files.py "..\output"  "Vehicle_Inventory"  "..\inventory_credentials.json"
    }
    
}

Get-VehicleInventoryForModels -DirectoryToRunIn $args[0] -PythonVENVPowershellActivateScript $args[1]