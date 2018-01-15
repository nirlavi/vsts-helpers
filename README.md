# Vsts-Helpers

This is a collection of helper scripts to use with VSTS tasks to add missing functionality for certain use cases.

# Scripts

## VerifyTestsFound
This script goes through all VSTest tasks that have executed in the build and checks that the total tests found is larger than 0. Otherwise it will fail. This script can be added as a powershell task post test execution to make sure tests were actually found (if no tests are found the VSTest tasks do not fail currently)


### Usage

**Authentication:** The script uses the VSTS Rest API and you will need to define a PAT (Personal Access Token) for the script to use. The token should be added as a (secret) Variable to your build definition. 
More information about PATs can be found [here](https://docs.microsoft.com/en-us/vsts/accounts/use-personal-access-tokens-to-authenticate).

**Build Variables** - The script expects the following additional variables to be defined in the build:

 - apiUser - The user associated with the PAT created
 - personalAccessToken - The PAT..

**Powershell Task** - You can then add a (inline) Powershell task after your VSTest tasks.
