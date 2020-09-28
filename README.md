# This contains the PowerShell script to Rename VMs

Since VMs cannot be renamed after creation, the approach used here was to first get the migrated VM into
.xml file then deleted leaving the OS disk and NIC. 
Then the VM is recreated with the required name and migrated disk and NIC are attached.

