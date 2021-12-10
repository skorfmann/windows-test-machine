version: 1.0
tasks:
- task: executeScript
  inputs:
  - frequency: once
    type: powershell
    runAs: admin
    content: |-
      iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
      choco install -y golang maven-snapshot nuget.commandline nodejs python3 terraform git dotnetcore-sdk rsync yarn vscode
- task: enableOpenSsh
#
# Didn't get the following to work to run sequentially. Parallel execution didn't work either, since the script was blocked by the first one
# - task: executeScript
#   inputs:
#   - frequency: once
#     type: powershell
#     runAs: admin
#     content: |-
#       pip install pipenv
#       $homeDir = 'C:\Users\Administrator'
#       $outputDir = 'C:\Users\Administrator\terraform-cdk'
#       cd $homeDir
#       git clone https://github.com/hashicorp/terraform-cdk.git
#       cd $outputDir
#       yarn install