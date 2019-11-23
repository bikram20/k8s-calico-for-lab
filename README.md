# k8s-for-lab
Set up kubernetes 1.15.4 with calico 3.10 using packer, terraform, and ansible. 1-click creation/deletion. 

git clone 

### One time use
Build your own AMI using packer

Install packer. Then packer build <>. 

### Modify terraform vars
Use your keypair name in variables.tf.
Use your AMI in variables.tf

### Run
terraform apply
terraform output

### Connect to lab
ssh into any node. kubectl and calicoctl are configured on all nodes.

