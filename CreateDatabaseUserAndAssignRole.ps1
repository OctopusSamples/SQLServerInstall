$createSqlLogin = "SomeUser"
$createSqlDefaultDatabase = "SomeDatabase"
$createRoleName = "db_owner"
$connectionString = "Server=.;Database=$createSqlDefaultDatabase;integrated security=true;"
$sqlConnection = New-Object System.Data.SqlClient.SqlConnection
$sqlConnection.ConnectionString = $connectionString

$command = $sqlConnection.CreateCommand()
$command.CommandType = [System.Data.CommandType]'Text'

$sqlConnection.Open()

Write-Host "Running the if not exists then create for $createSqlLogin"
$command.CommandText = "If Not Exists (select 1 from sysusers where name = '$createSqlLogin')
	CREATE USER [$createSqlLogin] FOR LOGIN [$createSqlLogin] WITH DEFAULT_SCHEMA=[dbo]"            
$command.ExecuteNonQuery()

Write-Host "Running the script to add the user $createSqlLogin to the role $createRoleName"
$command.CommandText = "ALTER ROLE [$createRoleName] ADD MEMBER [$createSqlLogin]"            
$command.ExecuteNonQuery()

Write-Host "Successfully created the account $createSqlLogin"
$sqlConnection.Close()