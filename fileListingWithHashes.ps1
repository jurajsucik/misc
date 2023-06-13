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
        $md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
        $hash = [System.BitConverter]::ToString($md5.ComputeHash([System.IO.File]::ReadAllBytes($file.FullName)))

        # Create a custom object to store the file path, name, and MD5 hash
        $result = New-Object -TypeName PSObject -Property @{
            FilePath = $file.DirectoryName
            FileName = $file.Name
            MD5Hash  = $hash
        }

        # Add the custom object to the results array
        $results += $result
    }
}