# Vagrant::Tools

Vagrant cli configuration management tool. The missing tool for vagrant that allows you to control all your vagrant instances. Use cli command: `vgls` to list all vagrant configs (all Vagrantfiles), and `vgctl [target] [vgcmd]` to control configurations from outside the Vagrantfile dir.

**Example**

```bash
$ vgls
some-project (/Users/dblommesteijn/Programming/some-project)
- testing (vmid: cee72fc1-f647-4a2a-be48-04b4c1adeb2d)
- deployment (vmid: d46784f8-5a76-49eb-a511-1ab6c50d777d)
$ vgctl some-project status
Current machine states:

testing                   poweroff (virtualbox)
deployment                poweroff (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
$ vgctl some-project up testing
... starting the vm
$ vgctl some-project ssh testing
... interactive ssh shell
$ vgctl some-project destroy testing
... destroying vm [y/N]
```

## Roadmap

* Version (0.0.1)

  * Initial project
  * List all vagrant configurations
  * Add basic controls for up/ halt/ destroy etc.

* Version (0.1.0)

  * Enable `vagrant ssh` interactive shell

* Version (0.1.1)

  * Filter show only active
  * Changed formatting of target and command
  * Add option to switch to .config path `vgctl target-box shell`
  * Filter show only zombies

* Current/ Master

  * Fix indexing new Vagrantfile configuration https://github.com/dblommesteijn/vagrant-tools/issues/1


## Installation

Install the latest version from the git repository, or install it via RubyGems

#### From Source

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

#### RubyGems

**Get the package from RubyGems**

```bash
gem install vagrant-tools
```


## Usage

**Run commands**

```bash
# list all vagrant configs
vgls
# control vagrant
vgctl
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
vgls -p $HOME/path/to/your/repos
vgctl -p $HOME/path/to/your/repos
```

Target or list vagrant config relative to a given config

*NOTE: duplicate config names will get a _n offset*

```bash
vgls my-test-box
vgctl my-test-box
```

Refresh cache, by default cache is stored at `$HOME/.vagrant-tools/settings.json`

```bash
# vgls and vgctl are equivalent
vgls -x
vgctl -x
```

Run a vagrant command (-c prepends `vagrant ` to all commands)

```bash
vgctl my-test-box list-commands
# runs `vagrant list-commands` in the path of `my-test-box`
# ... etc
```

Show only active instances

```bash
vgls -a
```

Show detached instances (running without .config)

```bash
vgls -z
```

Launch a shell targeted at the 'cwd' relative to the target

```bash
vgctl my-text-box shell
# launches a shell: pwd => $HOME/path/to/your/repos/my-text-box
```

Print help message

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
vgctl my-test-box up
vgctl my-test-box ssh
```

Destroy a running VM

```bash
# list running configs
vgls -a
# execute `vagrant destroy` on path of `my-test-box`
vgctl my-test-box destory
```

