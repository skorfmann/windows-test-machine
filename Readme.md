

## Prerequisites

```
brew install --cask microsoft-remote-desktop
```

[Install Session Manager Plugin](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html)


## Usage

Assumes valid credentials for AWS in ENV

```
terraform apply -auto-approve
./scripts/proxy
```

Other terminal to connect to instance via RDP

```
./scripts/connect
```