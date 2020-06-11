# Vieillot.fr website 

## Requirements

  * PHP 7.1.3 or higher;
  * PDO-SQLite PHP extension enabled;
  * and the [usual Symfony application requirements][1].
  * Virtualbox version 6.00 and Guest Additions 6.0.0 too

## Create environnement 
The local environments for recette and production are created by Vagrant. 
To create the environment:
```bash
$ vagrant up
```
To log in the recette env:
```bash
$ vagrant ssh recette
```
To log in the production env :
```bash
$ vagrant ssh production
```

## Installation

First, remove vendor folder:

```bash
rm -rf /vagrant/vendor
```

Install dependencies : 

```bash
$ composer install -n
```

## Launch server

## Local way

```bash
$ php bin/console server:start
```

## Listen all (to see on host)

```bash
$ php bin/console server:start 0.0.0.0:8000
```

## Tests

Execute this command to run tests:

```bash
$ ./bin/phpunit
```

[1]: https://symfony.com/doc/current/reference/requirements.html
