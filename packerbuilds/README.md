# Packer images
Designed to generate packer images (AMI) that you can use.

Run packer build <name>.json. This triggers the corresponding AMI (ubuntu) and run a shell script to install required packages. The AMI is available under your AWS account (EC2 -> AMI) as a private AMI. To make that public, just head over to EC2 and change the permission on the AMI. 

If you need to create your AMI in another AWS region, then make sure to update the <name>.json with region and ubuntu base AMI.

You will use the created AMI in your terraform file (variables.tf).



