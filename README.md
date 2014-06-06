# Vagrant::Tools

Vagrant configuration management tool (via cli).

By using cli commands: `vgls` you can list all .vagrant configs on your system.
Use `vgctl -t config -c (vagrant command)` to run vagrant commands from any path (working dir) on your system.


## Roadmap

* Version (0.0.1)

  * Initial project
  * List all vagrant configurations
  * Add basic controls for up/ halt/ destroy etc.

* Version (0.0.2)

  * Filter only active/ inactive
  * Enable `vagrant ssh`
  * Add option to switch to .config path


## Installation

**Clone the git repository to your local machine.**

```bash
git clone https://github.com/dblommesteijn/vagrant-tools
```

**Install binaries to your system**

```bash
cd vagrant-tools
rake install
# vgls and vgctl will be available system wide
```

**Run commands**

```bash
# list all vagrant configs
vgls
# control vagrant
vgctl
```

## Usage

List all vagrant configurations

```bash
vgls
```

Verbose, this will output operations to STDOUT

```bash
vgls -v
vgctl -v
```

Change target configuration (find operation), base from where .vagrant configs are discovered:

`find "/home/user/path/to/your/repos" -type d -name ".vagrant"`

*NOTE: this will force cache refresh*

```bash
vgls -p `$HOME`/path/to/your/repos
vgctl -p `$HOME`/path/to/your/repos
```

Target or list vagrant config relative to a given config

*NOTE: duplicate config names will get a _n offset*

```bash
vgls -t my-test-box
vgctl -t my-test-box
```

Refresh cache, by default cache is stored at `$HOME/.vagrant-tools/settings.json`

```bash
# vgls and vgctl are equivalent
vgls -x
vgctl -x
```

Run a vagrant command (-c prepends `vagrant ` to all commands)

```bash
vgctl -t my-test-box -c up
vgctl -t my-test-box -c halt
vgctl -t my-test-box -c destroy
# prompt [y/N]
vgctl -t my-test-box -c status
```

Print help file

```bash
vgls -h
vgctl -h
```

### Workflow

Listing all vagrant configs, and starting VM

```bash
# list all configs
vgls
# execute `vagrant up` on path of `my-test-box`
vgctl -t my-test-box -c up
# TODO: no interactive shell working (`vagrant ssh is not working yet`)
```

Destroy a running VM

```bash
# list all configs
vgls
# execute `vagrant destroy` on path of `my-test-box`
vgctl -t my-test-box -c destory
# answer custom prompt [y/N]
```

