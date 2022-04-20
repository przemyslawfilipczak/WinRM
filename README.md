# WinRM

Hi there!
This script is part of the automatic implementation of WinRM configuration in AD.

This is the solution to the "HTTPS listener" configuration problem. 
The problem is the command parameters that must be executed in CMD - in this script the parameters are downloaded automatically and "personalized" for each computer in the AD domain.

The remaining stages related to the comprehensive implementation of WinRM, such as opening port 5986, automatic creation of a computer certificate by the appropriate template etc. are not included in the publication.

The following graphic describes the script process:

<img src="https://github.com/przemyslawfilipczak/WinRM/blob/main/src/winrm.png?raw=true" alt="Process" title="Process">
