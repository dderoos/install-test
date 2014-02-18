## add biadmin group and user and set pwd
groupadd -g 168 biadmin
useradd -g biadmin -u 168 biadmin

## comment out the requiretty setting in /etc/sudoers
sed -i 's/Defaults    requiretty/##Defaults    requiretty/' /etc/sudoers

## add root and biadmin nopasswd to /etc/sudoers
sed -i 's/root	ALL=(ALL) 	ALL/root	ALL=(ALL) 	ALL\nroot	ALL=(ALL) 	NOPASSWD: ALL\nbiadmin	ALL=(ALL) 	NOPASSWD: ALL/' /etc/sudoers

## copy ssh keys to biadmin user
mkdir /home/biadmin/.ssh
chown biadmin:biadmin /home/biadmin/.ssh
cp /root/.ssh/* /home/biadmin/.ssh/
chown biadmin:biadmin /home/biadmin/.ssh/*

## generate ssh keys
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >>  ~/.ssh/authorized_keys

sudo -u biadmin ssh-keygen -t rsa -P '' -f /home/biadmin/.ssh/id_rsa
sudo -u biadmin cat ~/.ssh/id_rsa.pub >>  /home/biadmin/.ssh/authorized_keys

## set adequate resources for biadmin
sed -i 's/# End of file/biadmin hard nofile 65536\nbiadmin soft nofile 65536\nbiadmin hard nproc 65536\nbiadmin soft nproc 65536\n# End of file/' /etc/security/limits.conf

## set boottime and runtime port ranges
sed -i '$a # Set ranges for BigInsights Install\n\nkernel.pid_max = 4194303\nnet.ipv4.ip_local_port_range = 1024 64000' /etc/sysctl.conf

## turn off ipv6
echo '# Turn off IPv6 for BigInsights Install' >> /etc/modprobe.conf
echo 'alias net-pf-10 off' >> /etc/modprobe.conf
echo 'alias ipv6 off' >> /etc/modprobe.conf
sed -i '$a net.ipv6.conf.all.disable_ipv6 = 1' /etc/sysctl.conf
sed -i '$a IPV6INIT=no' /etc/sysconfig/network-scripts/ifcfg-eth0
service ip6tables stop
chkconfig ip6tables off
/sbin/reboot

## start or restart time service
sudo service ntpd start
