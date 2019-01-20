<# 2.1  Exercise
1. Run PowerShell. Type exit and press the Enter key. What happens?
Answer: Powershell quits

2. Run PowerShell ISE. Click on the Help menu. Click on Update Windows PowerShell Help.
You will notice in the window below a command update-help runs and then usually produces an error.
This is normal on the University of Edinburgh Supported Windows Desktop.

3. Read the red error text. Can you determine why the command failed?
If u don't run as admin, u get tons of failures.
As admin, you only get the below errors.

update-help : Failed to update Help for the module(s) 'HostNetworkingService, WindowsUpdateProvider' with UI culture(s) {en-US} : Unable to retrieve the HelpInfo XML 
file for UI culture en-US. Make sure the HelpInfoUri property in the module manifest is valid or check your network connection and then try the command again.
At line:1 char:1
+ update-help
+ ~~~~~~~~~~~
    + CategoryInfo          : ResourceUnavailable: (:) [Update-Help], Exception
    + FullyQualifiedErrorId : UnableToRetrieveHelpInfoXml,Microsoft.PowerShell.Commands.UpdateHelpCommand


#>