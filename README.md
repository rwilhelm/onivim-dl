Download Onivim 2
=================

Command line interface to authenticate with [Outrun Labs](https://www.outrunlabs.com/) and download the stable or nightly release of [Onivim 2](https://www.onivim.io/).

## Setup license key

Pass `ONIVIM2_LICENSE_KEY` via your environment or put it in `.env` of the current directory:

```
ONIVIM2_LICENSE_KEY=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

## Usage

```

onivim-dl [command]

Commands:
  onivim-dl license   Validate license key
  onivim-dl cur       Get current version
  onivim-dl account   Get user account info
  onivim-dl head      Get latest commit
  onivim-dl download  Download Onivim

Options:
      --help      Show help                                            [boolean]
      --version   Show version number                                  [boolean]
  -c, --channel   Select channel                    [string] [default: "stable"]
  -p, --platform  Select platform                    [string] [default: "linux"]
  -v, --verbose   Verbose output                                       [boolean]

```
