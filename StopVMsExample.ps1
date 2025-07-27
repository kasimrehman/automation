Import-module 'az.accounts'
Import-module 'az.compute'

Connect-AzAccount -Identity


$tag = "Environment"
$tagVale = "Prod"

# Function to stop the servers
function Stop-Vms {
    param (
        $vms
    )
    foreach ($vm in $vms) {
        try {
            # Stop the VM
            $vm | stop-AzVM -ErrorAction Stop -Force -NoWait
        }
        catch {
            $ErrorMessage = $_.Exception.message
            Write-Error ("Error starting the VM: " + $ErrorMessage)
            Break
        }
    }

}  

# Get the servers
try {
    $vms = (get-azvm -ErrorAction Stop | Where-Object { $_.tags[$tag] -eq $tagVale })
}
catch {
    $ErrorMessage = $_.Exception.message
    Write-Error ("Error returning the VMs: " + $ErrorMessage)
    Break
}

Write-output "Stopping the following servers:"
Write-output $vms.Name
stop-vms $vms
