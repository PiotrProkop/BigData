### Preparation of machines

Please ensure that we have a passwordless connection to machines on Linux machine please issue:

```
ssh-keygen # if there is no public ssh key
ssh-copy-id <user>@<IP>
```




###Prepare inventory file

Inventory file contains information about machines in the cluster.

Please take a look at [here](http://docs.ansible.com/ansible/intro_inventory.html).

To check connectivity please run:

```
ansible -m setup -i inventory/cluster -u <user> all
```


### Roles

- hadoop-common - download hadoop and extract it .Preparing environment ( prepare /etc/hosts and bashrc for env)
- hadoop-


### Getting Java playbook

Go into `roles` directory and run:
```
git clone https://github.com/ostrichops/ansible-oracle-java
```

to obtain a role for installing Java

### Running playbook


```
ansible-playbook -i inventory/cluster -u <user> install.yml
```

### Installing Hadoop

For a clean installation please set a variable `format` in `group_vars/all.yaml` to True, example:

```
format: True
```

This will format hdfs and let you to make a clean installation.


### Resizingin LVM

Please create a new partition write :

```
fdisk /dev/sdb
```

Next:
1. Click n to create partition
2. On newly created partition press t to change partition type
3. And change it to 15 that is `Linux LVM`

Next run `partprobe` to re-read partition table

Create PV(physical )volume on new partition:

```
pvcreate /dev/sdb2
```

Extented the VG ( Volume Group) with newly create PV:

```
vgextend cl /dev/sdb2
```

Extend LV ( Logical volume):

```
lvextend -l +1306142 /dev/cl/var 
```

### Change Hadoop version

In file `group_vars/all.yml` insert:
```
hadoop_version: 2.8.1
```

### Disable firewall 

In order to diable firewall run :

```
ansible -m raw -a "systemctl stop firewalld && systemctl disable firewalld" -i inventory/cluster -u root all
```


### Killing processes

In order to kill given service please run :

```
ps auxww | grep <name_of_service> | tr -s " " | cut -d " " -f 2 | xargs -n1 kill -9
```

### Hive on MariaDB

Please use this link:

https://dzone.com/articles/how-configure-mysql-metastore 

### Tweaking Kylin

In order to increase a heap size in Kylin please change a `$KYLIN_HOME/bin/setenv.sh` with:
```
export KYLIN_JVM_SETTINGS=" -Xmx<maximum_memory_allocation>M"
```

### HBase

Hbase requires Zookeeper in order to properly work in case of its failure HBase stops working.
Zookeeper keep its quorum information inside HDFS so to reset its state remove all Zookeeper's data from HDFS.

### Jupyter Notebook

In order to change password first generate hash by running inside python shell:

```
from notebook.auth import passwd
passwd("<password>")
```

Output will be a hashed <password>

Next put it in `$HOME/.jupyter/jupyter_notebook_config.py`

as :
```
c.NotebookApp.password = u'<hashed_password>'
```

Next one has to restart jupyter. By running:

```
systemctl restart jupyter
```

### Stopping client 

To stop client services plsease got to roles/kylin/files and launch script `stop.sh` on a client machine.
Do the same for jupyter.

### Mahout

Installation path is `/usr/local/mahout/apache-mahout-distribution-0.13.0`.

To run sample example go into `/usr/local/mahout/apache-mahout-distribution-0.13.0/examples/bin`

and run:
```
./factorize-movielens-1M.sh ml-1m/ratings.dat
```

### Enabling sudo without password for an user

First type `visudo` and uncomment following line:

```
%wheel  ALL=(ALL)       NOPASSWD: ALL
```

save and exit by typing `:wq`

Next add an user to group wheel

```
usermod -a -G wheel <name_of_user>
```

To check whether it was succesfull try to login to specified user and type:
```
sudo su
```

### UML deployment diagrams

Diagram below represents a hardware connections between physical nodes and their specification:

![Hardware specification](/docs/Specification.png)


Logical connection between HDFS, YARN, MapReduce and Spark clients are represented as:

![YARN&HDFS](/docs/Computational.png)

Hive and HBase can be modeled as:

![Hive and HBase](/docs/Hive.png)


