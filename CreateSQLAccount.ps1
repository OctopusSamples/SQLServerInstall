$connectionString = "Server=.;Database=master;integrated security=true;"
$sqlConnection = New-Object System.Data.SqlClient.SqlConnection
$sqlConnection.ConnectionString = $connectionString

$command = $sqlConnection.CreateCommand()
$command.CommandType = [System.Data.CommandType]'Text'

$sqlConnection.Open()

$createSqlLogin = "SomeUser"
$createSqlPassword = ""
$createSqlDefaultDatabase = "SomeDatabase"
Write-Host "Running the if not exists then create user command on the server for $createSqlLogin"

if ([string]::IsNullOrWhiteSpace($createSqlPassword) -eq $true) {
	Write-Host "The password sent in was empty, creating account as domain login"
    $command.CommandText = "IF NOT EXISTS(SELECT 1 FROM sys.server_principals WHERE name = '$createSqlLogin')
	CREATE LOGIN [$createSqlLogin] FROM WINDOWS, default_database=[$createSqlDefaultDatabase]"            
}
else {
	Write-Host "A password was sent in, creating account as SQL Login"
	$escapedPassword = $createSqlPassword.Replace("'", "''")
	$command.CommandText = "IF NOT EXISTS(SELECT 1 FROM sys.server_principals WHERE name = '$createSqlLogin')
	CREATE LOGIN [$createSqlLogin] with Password='$escapedPassword', default_database=[$createSqlDefaultDatabase]"   
}
$command.ExecuteNonQuery()

Write-Host "Successfully created the account $createSqlLogin"
$sqlConnection.Close()