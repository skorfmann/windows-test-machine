# Create a Windows test instance
## Prerequisites

```
brew install --cask microsoft-remote-desktop
```

[Install Session Manager Plugin](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html)

## Usage

Assumes valid credentials for AWS and the proper AWS_DEFAULT_REGION set in ENV

```
# on first run
terraform init

terraform apply -auto-approve
```

It might take a few minutes until the instance is reachable via SSM / SSH. Also, the [userdata](./userdata.ps1) script runs async and takes a few minutes to install all dependencies. So, even if it's connecting, you might have to wait for a minute or two until everything got installed.

The userdata is using the EC2 v2 launch config format - see [here](https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/ec2launch-v2-settings.html#ec2launch-v2-task-configuration) for docs.

### With Remote Desktop

```
./scripts/proxy
```

In another terminal: connect to instance via RDP

```
./scripts/connect
```

This will open the Remote Desktop with the correct data. The password will be automatically copied to the clipboard and is ready to paste.

### With VS Code Remote SSH

The EC2 instance is configured to run an OpenSSH server (see userdata).

Install the [VS Code plugin](https://code.visualstudio.com/docs/remote/ssh) for Remote SSH connection.

Edit your `~/.ssh/config` and add

```
Host i-* mi-*
    ProxyCommand sh -c "/full/path/to/project/scripts/ssh-proxy %r %h %p"%
```

Adapt the [./scripts/ssh-proxy](./scripts/ssh-proxy) file and make sure the variables are set correct

```
export AWS_PROFILE=yourProfile
export AWS_DEFAULT_REGION=theRegion
ONE_TIME_KEY_FILE_NAME="/path/to/generated/ssh-key.pem"
```

Set `ONE_TIME_KEY_FILE_NAME` to the generated key when running `terraform apply`.

Grab the `InstanceId` from the terraform output and create a new connection as SSH target: `ssh Administrator@<InstanceId>` (e.g. `ssh Administrator@i-0dc1d63983c73e394`).

## Improvements

This could all work in a more automated fashion, but it works for now. Things I'd like to improve:

- Better experience around setting up the local SSH config
- Merge proxy / connect into a single command
- Enhance userdata to run multiple powershell scripts sequentially. Didn't get this to work, since more than one script was blocking the other one on execution. Probably needs more elaborate Powershell scripting.

