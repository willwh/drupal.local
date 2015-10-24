lullabot-puppet-example
===================


An example repo to describe usage of VirtualBox, Vagrant & local Puppet provisioning, to provide a development environment for Drupal 8 that runs in a virtual machine on your host system.

----------

Requirements
-------------

Install the following applications:

> [VirtualBox](https://www.virtualbox.org/) - Virtualization software
> [Vagrant](https://www.vagrantup.com/) - Tool for building development environments

Check out this repository:

```
git clone https://github.com/willwh/drupal.local
cd drupal.local
```

For ease of use, the lullabot-puppet repository has been included as a Git submodule. To get the latest do the following:

```
git submodule init
git submodule update
```

If you fork this repository, or create your own in a similar fashion, I would suggest just committing the modules you wish to use, directly to your repository, as opposed to adding the whole repository as a submodule.

Take a look at the commit log to follow along and see how this is all built up.

For the purposes of this demo, I have not included the Drupal 8 source, but you need to do that to be able to test this out!

Make sure you are in the drupal.local directory:

```
drush dl drupal-8 --drupal-project-rename=docroot
```

This should give you a directory structure like so, where [] denotes a directory:

```
drupal.local
    - Vagrantfile (Vagrant configuration file)
        - [docroot] (drupal source files)
        - [.puppet] (puppet manifest file & puppet modules)
 ```

I would highly recommend if plan to use this style of setup in your project, don't clone this repo, just grab an archive - and then commit it all (including Drupal source) to your own repository.
