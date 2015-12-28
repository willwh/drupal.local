drupal.local
===================

[![Join the chat at https://gitter.im/willwh/drupal.local](https://badges.gitter.im/willwh/drupal.local.svg)](https://gitter.im/willwh/drupal.local?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

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
drush dl drupal-8 --drupal-project-rename=docroot
```

If you don't have Drush installed, you can simply unpack an archive of the Drupal 8 source to `drupal.local/docroot`

This should give you a directory structure like so, where [] denotes a directory:

```
drupal.local
    - Vagrantfile (Vagrant configuration file)
    - [docroot] (drupal source files)
    - [.puppet] (puppet manifest file & puppet modules)
 ```

I would highly recommend if plan to use this style of setup in your project, don't clone this repo, just grab an archive - and then commit it all (including Drupal source) to your own repository.

Finally to start everything up, from the root of the repository:

```
vagrant up
```

To ssh in to your VM, to use drush or mysql type:

```
vagrant ssh
```

You will be at your project root directory: /var/www/drupal.local/docroot

Now you can navigate to http://drupal.local and play with Drupal 8.

Speeding Things Up!
-------------------

[NFS](https://docs.vagrantup.com/v2/synced-folders/nfs.html) synced folders can greatly speed up your VM.

If you have NFS installed on your system, edit the Vagrantfile's SYNC="" property like so:

```
SYNC="nfs"
```

