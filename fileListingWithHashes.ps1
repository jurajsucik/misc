# Get all drives except C drive
$drives = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Root -ne "C:\" }

# Initialize an empty array to store the results
$results = @()

# Iterate through each drive
foreach ($drive in $drives) {
    # Get all files in the current drive
    $files = Get-ChildItem -Path $drive.Root -Recurse -File -ErrorAction SilentlyContinue

    # Iterate through each file
    foreach ($file in $files) {
        # Calculate MD5 hash for the current file
        $hashObj = Get-FileHash -Path $file.FullName -Algorithm MD5  

        # Create a custom object to store the file path, name, and MD5 hash
        $result = New-Object -TypeName PSObject -Property @{
            FilePath = $file.DirectoryName
            FileName = $file.Name
            MD5Hash  = $hashObj.Hash  
        }

        # Add the custom object to the results array
        $results += $result
    }
}

# Export the results to a CSV file
$results | Export-Csv -Path "MD5HashResults.csv" -NoTypeInformation