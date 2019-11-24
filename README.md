# k8s-for-lab
Set up kubernetes 1.15.4 with calico 3.10 using packer, terraform, and ansible. 1-click creation/deletion. 

git clone 

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
