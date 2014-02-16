## add biadmin group and user and set pwd
groupadd -g 168 biadmin
useradd -g biadmin -u 168 biadmin

## comment out the requiretty setting in /etc/sudoers
sed -i 's/Defaults    requiretty/##Defaults    requiretty/' /etc/sudoers

## add root and biadmin nopasswd to /etc/sudoers
sed -i 's/root	ALL=(ALL) 	ALL/root	ALL=(ALL) 	ALL\nroot	ALL=(ALL) 	NOPASSWD: ALL\nbiadmin	ALL=(ALL) 	NOPASSWD: ALL/' /etc/sudoers

## copy ssh keys to biadmin user
cp /root/.ssh/* /home/biadmin/.ssh
chown biadmin:biadmin /home/biadmin/.ssh/*

