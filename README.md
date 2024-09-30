# Introduction to Cairo

On this branch of this repo, we explore the core fundamentals for writing a Cairo program. 

##  Setting Up Development Environment

### 1. Scarb
Cairo can be installed by simply downloading Scarb. Scarb bundles the Cairo compiler and the Cairo language server together in an easy-to-install package so that you can start writing Cairo code right away.

Run the following in your terminal, then follow the onscreen instructions. This will install the latest stable release.

``` =shell
curl --proto '=https' --tlsv1.2 -sSf https://docs.swmansion.com/scarb/install.sh | sh
```


To check if scarb is successfully installed, run either: 
- `scarb --version` - returns the version of scarb
- `which scarb` - returns the path to the scarb bin on your maching 


### Install Scarb via asdf (for macOS and Linux only)
`asdf` is a CLI tool that can manage multiple language runtime versions on a per-project basis. 

Install `asdf`:
- https://asdf-vm.com/guide/getting-started.html

- Run the following command to add the scarb plugin:
- `asdf plugin add scarb`

With scarb installed, you are set to writing Cairo programs. 

To spin up a program, run `scarb new gm_cairo` 

The entry point to our program is housed within the logic of `main` function in `lib.cairo`

To compile your program, run `scarb cairo-run`


