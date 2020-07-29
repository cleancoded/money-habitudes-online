# Money Habitudes Online

Money Habitudes Online is a Django web application with an AngularJS frontend. It relies on a Postgresql database and an Nginx server for serving cached and static content.

## Environment

MHO is developed and deployed on CentOS 7 and additionally requires a running docker service and the docker-compose package. Other Linux distributions or operating systems may require tweaks to make this work.

```
$ sudo yum install docker docker-compose
$ sudo systemctl start docker
$ sudo usermod -a -G docker $(logname)
```

After adding yourself to the docker group, you may need to restart your session.

## Database initialization

You need to initialize the database before the first run of MHO.

```
$ bin/init_db.sh
```

## Settings

Copy `moneyhabitudes/settings-example.py` to `moneyhabitudes/settings.py`. It is recommnded to specify the variables at the bottom of the file.

## Starting the debug environment

A single command will run MHO debug environment on http port 8000. Any local changes are applied when the command is re-run.

```
$ bin/debug.sh
```

## Creating a user

You can create user accounts by navigating directly to the [Sign Up page](http://localhost:8000/#/signup).

## Populating with dummy data

You can populate dummy data in dummy accounts using the MHO shell. This will create an admin account with 100 users. You may specify the admin user email address (will either bind to an existing account or create one) as the first string parameter. The password for all created accounts is `test`.

```
$ bin/shell.sh
In [1]: from tools.populate import populate
In [2]: populate('admin@example.com')
```

## Promoting a staff account

Staff members can access the [super administration page](http://localhost:8000/admin/), which provides various global administration capabilities.

Promoting an account to a staff account can only be done through the MHO shell.

```
$ bin/shell.sh
In [1]: from accounts.models import Account
In [2]: a = Account.objects.get(email='admin@example.com')
In [3]: a.user.is_staff = True
In [4]: a.user.save()
```