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
    $logfile = $DirectoryToRunIn + "\output\InventoryRun.log"
    Start-Transcript -path $logfile
    cd $DirectoryToRunIn
    Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
    .$PythonVENVPowershellActivateScript
    # break out of this for testing by uncommenting the following
    # Return
    $timeout = 60*3
    # Get a list of all the current models first
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
    # TODO: Now commit this to the repository Or possibly instead place on google drive (no history).
    if ( 1 -eq 0) {
        git config user.name "Greg Gemmer"
        git config user.email "ghgemmer@gmail.com"
        git add output
        $timestamp = Get-Date
        git commit -m "Updating models list: $timestamp"
        git status
        git pull --rebase
        git push
    }
    
    Stop-Transcript
}

Get-VehicleInventoryForModels -DirectoryToRunIn $args[0] -PythonVENVPowershellActivateScript $args[1]