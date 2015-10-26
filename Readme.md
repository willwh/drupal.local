drupal.local
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

Now you can navigate to http://drupal.local and play with Drupal 8 RC2.
