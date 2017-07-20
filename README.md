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


### Running playbook



```
ansible-playbook -i inventory/cluster -u <user> bigdata.yml
```


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

### Disable firewall 

In order to diable firewall run :

```
ansible -m raw -a "systemctl stop firewalld && systemctl disable firewalld" -i inventory/cluster -u root all
```
