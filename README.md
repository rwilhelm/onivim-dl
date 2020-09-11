onivim-dl
=========

`Onivim 2 Command Line Interface Download Utility`

> Command line interface to authenticate with [Outrun Labs](https://www.outrunlabs.com/) and
> download the stable or nightly early access builds (alpha) of [Onivim 2](https://www.onivim.io/).

## Installation
```
npm install -g onivim-dl
```
or
```
git clone https://git.sr.ht/~rxw/onivim-dl
```

## Setup license key

Pass `LICENSE_KEY` via your environment or put it in
```
~/.config/onivim-dl/licenseKey
```

The file should look like this:
```
LICENSE_KEY=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
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
  -b, --branch    Select branch                     [string] [default: "stable"]
  -p, --platform  Select platform                    [string] [default: "linux"]
  -v, --verbose   Verbose output                                       [boolean]
```
