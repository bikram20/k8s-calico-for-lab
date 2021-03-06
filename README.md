# k8s-calico-for-lab
Set up kubernetes 1.15.4 with calico 3.10 using packer, terraform, and ansible. 1-click creation/deletion. 

https://medium.com/@bikramgupta/diy-kubernetes-clusters-for-lab-5d470fcd06c7


### One time use
Build your own AMI using packer

Install packer. 
packer build ubuntu-us-west-2.json

If using another region, then customize the json accordingly. 

### Modify terraform vars
Use your keypair name in variables.tf.
Use your AMI in variables.tf

If using us-west-2, you can use the AMI configured in variables.tf

### Run
terraform init

terraform apply

terraform output

### Connect to lab
ssh into any node. kubectl and calicoctl are configured on all nodes.

if you enabled ttyd, then you can access terminal via http (not https for now). Disabled in terraform.tfvars

### If you want to clean up and restart again without having to re-install the lab
ssh into master node (10.0.0.10). In the .k8s folder, you will find kube-cluster.yaml and kube-remove.yaml. The later will reset the lab to pre-kubernetes, clean state.

ansible-playbook -i inventory --private-key <key>.pem kube-remove.yaml
ansible-playbook -i inventory --private-key <key>.pem kube-cluster.yaml

You end up saving about 5min.
