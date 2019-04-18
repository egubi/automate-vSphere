#!/bin/bash


# Execute terraform
cd /home/master/Projects/terravSphere
echo "===> START TERRAFORM SETUP <==="
terraform plan -var-file=~/Projects/terravSphere/Swarm/swarm.tfvars -var-file=~/Projects/terravSphere/DR.tfvars -state=~/Projects/terravSphere/Swarm/swarm.tfstate
terraform apply -var-file=~/Projects/terravSphere/Swarm/swarm.tfvars -var-file=~/Projects/terravSphere/DR.tfvars -state=~/Projects/terravSphere/Swarm/swarm.tfstate
# build ansible inventory 
echo "===> START BUILD ANSIBLE INVENTORY <==="
python ~/Projects/executor/buildAnsibleInventory.py "/home/master/Projects/terravSphere/Swarm/swarm.tfvars"

# finalize build with ansible-playbook
# setup ssh agent for private key
echo "===> START ANSIBLE POST CONFIG <==="
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
# start ansible
cd ~/Projects/host-Config/
ansible-playbook -i ~/Projects/host-Config/inventory/inventory-swarm --private-key=/home/master/.ssh/id_rsa terra-final.yml
# ansible-playbook -i ~/Projects/host-Config/inventory/inventory-swarm --private-key=/home/master/.ssh/id_rsa terra-final.yml
