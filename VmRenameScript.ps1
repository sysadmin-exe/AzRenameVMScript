#declare resource group and machine names as variable
$ResourceGroupName = 'web_rg'
$CurrentMachineName = @('machine1', 'machine2')
$newVMName = @('orderwebapp1', 'orderwebapp2', 'orderwebapp3', 'orderwebapp4')

foreach ($i in $VirtualMachineName) {
    #get the xml config for the migrated VMs and store in a folder
    Get-AzVM -ResourceGroupName $ResourceGroupName -Name $i | Export-Clixml /home/sysadmin/vmBkp/$i.xml -Depth 5
    #remove/delete the migreated VMs leaving the NIC and OS disk
    Remove-AzVM -ResourceGroupName $ResourceGroupName -Name $i -Force
}

#add the config to a variable that wiil be used to call the current VMs that are to be changed
$oldVM1 = Import-Clixml /home/sysadmin/vmBkp/machine1.xml
$oldVM2 = Import-Clixml /home/sysadmin/vmBkp/machine2.xml
$oldVM3 = Import-Clixml /home/sysadmin/vmBkp/machine3.xml
$oldVM4 = Import-Clixml /home/sysadmin/vmBkp/machine4.xml

#create config for new VM with the corrent name using the details in xml config above
$newVM1 = New-AzVMConfig -VMName orderwebapp1 -VMSize $oldVM1.HardwareProfile.VmSize -Tags $oldVM1.Tags
Set-AzVMOSDisk -VM $newVM1 -CreateOption Attach -ManagedDiskId $oldVM1.StorageProfile.OsDisk.ManagedDisk.Id -Name $oldVM1.StorageProfile.OsDisk.Name -Windows
$oldVM1.NetworkProfile.NetworkInterfaces | % {Add-AzVMNetworkInterface -VM $newVM1 -Id $_.Id}
$oldVM1.StorageProfile.DataDisks | % {Add-AzVMDataDisk -VM $newVM1 -Name $_.Name -ManagedDiskId $_.ManagedDisk.Id -Caching $_.Caching -Lun $_.Lun -DiskSizeInGB $_.DiskSizeGB -CreateOption Attach}

$newVM2 = New-AzVMConfig -VMName orderwebapp2 -VMSize $oldVM2.HardwareProfile.VmSize -Tags $oldVM2.Tags
Set-AzVMOSDisk -VM $newVM2 -CreateOption Attach -ManagedDiskId $oldVM2.StorageProfile.OsDisk.ManagedDisk.Id -Name $oldVM2.StorageProfile.OsDisk.Name -Windows
$oldVM2.NetworkProfile.NetworkInterfaces | % {Add-AzVMNetworkInterface -VM $newVM2 -Id $_.Id}
$oldVM2.StorageProfile.DataDisks | % {Add-AzVMDataDisk -VM $newVM2 -Name $_.Name -ManagedDiskId $_.ManagedDisk.Id -Caching $_.Caching -Lun $_.Lun -DiskSizeInGB $_.DiskSizeGB -CreateOption Attach}

$newVM3 = New-AzVMConfig -VMName orderwebapp3 -VMSize $oldVM3.HardwareProfile.VmSize -Tags $oldVM3.Tags
Set-AzVMOSDisk -VM $newVM3 -CreateOption Attach -ManagedDiskId $oldVM3.StorageProfile.OsDisk.ManagedDisk.Id -Name $oldVM3.StorageProfile.OsDisk.Name -Windows
$oldVM3.NetworkProfile.NetworkInterfaces | % {Add-AzVMNetworkInterface -VM $newVM3 -Id $_.Id}
$oldVM3.StorageProfile.DataDisks | % {Add-AzVMDataDisk -VM $newVM3 -Name $_.Name -ManagedDiskId $_.ManagedDisk.Id -Caching $_.Caching -Lun $_.Lun -DiskSizeInGB $_.DiskSizeGB -CreateOption Attach}

$newVM4 = New-AzVMConfig -VMName orderwebapp4 -VMSize $oldVM4.HardwareProfile.VmSize -Tags $oldVM4.Tags
Set-AzVMOSDisk -VM $newVM4 -CreateOption Attach -ManagedDiskId $oldVM4.StorageProfile.OsDisk.ManagedDisk.Id -Name $oldVM4.StorageProfile.OsDisk.Name -Windows
$oldVM4.NetworkProfile.NetworkInterfaces | % {Add-AzVMNetworkInterface -VM $newVM4 -Id $_.Id}
$oldVM4.StorageProfile.DataDisks | % {Add-AzVMDataDisk -VM $newVM4 -Name $_.Name -ManagedDiskId $_.ManagedDisk.Id -Caching $_.Caching -Lun $_.Lun -DiskSizeInGB $_.DiskSizeGB -CreateOption Attach}

#create newly name VMs with the config an they will have the same NIC and storage as the migrated VMs
New-AzVM -ResourceGroupName $ResourceGroupName -Location $oldVM1.Location -VM $newVM1
New-AzVM -ResourceGroupName $ResourceGroupName -Location $oldVM2.Location -VM $newVM2
New-AzVM -ResourceGroupName $ResourceGroupName -Location $oldVM3.Location -VM $newVM3
New-AzVM -ResourceGroupName $ResourceGroupName -Location $oldVM4.Location -VM $newVM4