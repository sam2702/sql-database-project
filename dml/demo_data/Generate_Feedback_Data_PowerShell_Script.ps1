
#Set-ExecutionPolicy RemoteSigned
#Set-ExecutionPolicy Restricted -Scope CurrentUser

# CONFIGURATION
$ServerName   = "DESKTOP-B9QVPPE"
$DatabaseName = "CustomerFeedback"
$InputFile    = "D:\CustomerFeedbackAnalytics\feedback_data.csv"
$LogFile      = "etl_log.txt"


# LOGGING
function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp $Message" | Out-File -Append -FilePath $LogFile
    Write-Host "$timestamp $Message"
}

# LOAD CSV
try {
    Write-Log "Loading file: $InputFile"
    $data = Import-Csv $InputFile
    if ($data.Count -eq 0) { Write-Log "No data found"; exit }
} catch {
    Write-Log "Failed to load file: $_"
    exit
}


# DB CONNECTION
$connectionString = "Server=$ServerName;Database=$DatabaseName;Integrated Security=True;"
$connection = New-Object System.Data.SqlClient.SqlConnection $connectionString
$connection.Open()

# PREPARE INSERT INTO STAGING
$insertCmd = $connection.CreateCommand()
$insertCmd.CommandText = @"
INSERT INTO Staging_Feedbacks (CustomerID, FeedbackText, Rating, CreatedDate, Metadata)
VALUES (@CustomerID, @FeedbackText, @Rating, @CreatedDate, @Metadata)
"@
$null = $insertCmd.Parameters.Add("@CustomerID",   [System.Data.SqlDbType]::Int)
$null = $insertCmd.Parameters.Add("@FeedbackText", [System.Data.SqlDbType]::NVarChar, 1000)
$null = $insertCmd.Parameters.Add("@Rating",       [System.Data.SqlDbType]::Int)
$null = $insertCmd.Parameters.Add("@CreatedDate",  [System.Data.SqlDbType]::DateTime)
$null = $insertCmd.Parameters.Add("@Metadata",     [System.Data.SqlDbType]::NVarChar, 2000)

$rowCount = 0
foreach ($row in $data) {
    $insertCmd.Parameters["@CustomerID"].Value   = [int]$row.CustomerID
    $insertCmd.Parameters["@FeedbackText"].Value = $row.FeedbackText
    $insertCmd.Parameters["@Rating"].Value       = [int]$row.Rating
    $insertCmd.Parameters["@CreatedDate"].Value  = [datetime]$row.CreatedDate
    $insertCmd.Parameters["@Metadata"].Value     = $row.Metadata.ToString()

    try {
        $insertCmd.ExecuteNonQuery() | Out-Null
        $rowCount++
    } catch {
        Write-Log "Insert to staging failed: $_"
    }
}
Write-Log "Loaded $rowCount rows into Staging_Feedbacks"

# Use a LEFT JOIN with the physical table to exclude records that already exist.
$mergeCmd = $connection.CreateCommand()
$mergeCmd.CommandText = @"
INSERT INTO Feedbacks (CustomerID, FeedbackText, Rating, CreatedDate, Metadata)
SELECT s.CustomerID, s.FeedbackText, s.Rating, s.CreatedDate, s.Metadata
FROM Staging_Feedbacks s
LEFT JOIN Feedbacks f
  ON s.CustomerID = f.CustomerID
  AND s.FeedbackText = f.FeedbackText
  AND s.CreatedDate = f.CreatedDate
WHERE f.CustomerID IS NULL;

SELECT @@ROWCOUNT AS InsertedCount;

TRUNCATE TABLE Staging_Feedbacks; -- Clean up for next batch
"@

try {
    $reader = $mergeCmd.ExecuteReader()
    if ($reader.Read()) {
        $insertedCount = $reader["InsertedCount"]
        Write-Log "Deduplication complete. Rows inserted into Feedbacks: $insertedCount"
    }
    $reader.Close()
} catch {
    Write-Log "Merge failed: $_"
}

$connection.Close()

