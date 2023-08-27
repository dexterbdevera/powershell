    #Read the text files contents
    $RDPServers = Get-content '.\rdp.txt'
    $SSHServers = Get-content '.\ssh.txt'
    
    #Define two containers variables to hold the list of reachable and unreachable servers.
    $LiveServer = @()
    $DeadServer = @()
    
    
    #Loop over the windows servers list to test each server connectivity
	echo "========================================="
	echo "      RDP/SSH/PING Connectivity Test"
	echo "        Author: Dexter De Vera"
	Write-Output "   Test Started: $(Get-Date)"
	echo "========================================="
	Write-Host ""
	echo "---------- RDP ----------"
    foreach($Server in $RDPServers){
        #Test the connectivity to windows server and store the response "True" or "False" in $nettest Variable
        $netest = Test-NetConnection -ComputerName $Server -Port 3389 | Select-Object -ExpandProperty TcpTestSucceeded
    
        Write-Output "RDP: $($Server) : $($netest)"
    
        if($netest -eq "True")
            #Add to the $Lifeserers list
            { $LiveServer += "$Server"} 
        else 
            #Add to the $DeadServers list
            {$DeadServer += "$Server" } 
       }
    
	Write-Host ""
    
	echo "---------- SSH ----------"
    #Loop over the Linux servers list to test each server connectivity
    foreach($Server in $SSHServers)
        {
        #Test the connectivity to Linux server and store the response "True" or "False" in $nettest Variable
        $netest = Test-NetConnection -ComputerName $Server -Port 22 | Select-Object -ExpandProperty TcpTestSucceeded
    
        Write-Output "SSH: $($Server) : $($netest)"
    
        if($netest -eq "True") { $LiveServer += "$Server"}
        else {$DeadServer += "$Server" }
       }
    Write-Host ""
    echo "---------- PING ----------"
    #Loop over the Linux servers list to test each server connectivity
    foreach($Server in $SSHServers)
        {
        $ip = $Server.Split(" - ")[0]
        #Test the connectivity to Linux server and store the response "True" or "False" in $nettest Variable
        if (Test-Connection  $ip -Count 1 -ErrorAction SilentlyContinue){
            Write-Host -ForegroundColor Green "$ip is up"
            }
        else{
            Write-Host -ForegroundColor Red "$ip is down"
            }
        }
    foreach($Server in $RDPServers)
        {
        $ip = $Server.Split(" - ")[0]
        #Test the connectivity to Windows server and store the response "True" or "False" in $nettest Variable
        if (Test-Connection  $ip -Count 1 -ErrorAction SilentlyContinue){
            Write-Host -ForegroundColor Green "$ip is up"
            }
        else{
            Write-Host -ForegroundColor Red "$ip is down"
            }
        }

    Write-Host ""	   
    echo "Test Completed!"
	echo "========================================="
	echo "             Test Summary "
	Write-Output "   Test Started: $(Get-Date)"
	echo "========================================="
    Write-Host ""
    Write-Host "===== Reachable Servers ====="
    $LiveServer
    Write-Host ""
    Write-Host "===== Not Reachable Servers ====="
    $DeadServer
    Write-Host ""
    Write-Host ""
