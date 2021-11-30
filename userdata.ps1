<powershell>
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
choco install -y golang maven-snapshot nuget.commandline nodejs python3 terraform git dotnetcore-sdk rsync yarn
refreshenv
pip install pipenv

cd C:\Users\Administrator
git clone https://github.com/hashicorp/terraform-cdk.git
cd terraform-cdk
yarn install
</powershell>