$connectionString = "Server=.;Database=master;integrated security=true;"
$sqlConnection = New-Object System.Data.SqlClient.SqlConnection
$sqlConnection.ConnectionString = $connectionString

$command = $sqlConnection.CreateCommand()
$command.CommandType = [System.Data.CommandType]'Text'

$sqlConnection.Open()

$databaseName = "SomeDatabase"

Write-Host "Running the if not exists then create for $databaseName"
$command.CommandText = "IF NOT EXISTS (select Name from sys.databases where Name = '$databaseName')
        create database [$databaseName]"            
$command.ExecuteNonQuery()

Write-Host "Successfully created the database $databaseName"
$sqlConnection.Close()