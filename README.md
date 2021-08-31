# Hashicraft

These are the steps to deploy a Minecraft Server into a Nomad + Consul cluster in AWS us-west-2 using Terraform, Nomad, Consul, Packer, Vault and Waypoint. Vagrant is installed with AWS CLI, Consul, Nomad, Terraform, Packer, Vault, and Waypoint for CLI usage.

This is running Minecraft version 1.15.2

This create 4 ec2 instances in AWS. 3 Nomad Servers (t2.micro) and 1 Nomad Client (m5.large) these can be changed in `/hashicraft_ami/terraform-aws-nomad/variables.tf`

Guides used:

```
   Offical HashiCorp Documentation
   https://github.com/hashicorp/terraform-aws-nomad/blob/master/core-concepts.md#deploy-nomad-and-consul-in-the-same-cluster
   https://burkey.dev/post/learning-nomad-scheduling-minecraft/
   Google
```

1. Clone the repo
2. Change to the `hashicraft` directory
3. `vagrant up` to intialize your environment
4. `vagrant ssh` to ssh into the vagrant env
5. Files in your project directory can be found in `/vagrant/`
6. `cd /vagrant/`
7. Change terraform backend to your own backend in `/hashicraft_ami/terraform-aws-nomad/`, can be found in the `main.tf` file.
8. Configure your AWS and HCP credentials in your CLI, as well as TF Cloud if using it. 
``` 
   Required variables in TF cloud

   AWS_ACCESS_KEY_ID
   AWS_SECRET_ACCESS_KEY
   HCP_CLIENT_ID
   HCP_CLIENT_SECRET
   
```
9. `CD /hashicraft_ami/terraform-aws-nomad/examples/nomad_consul_ami/`
10. `packer build nomad-consul.json`
11. Take the AMI ID output from packer and put into `/hashicraft_ami/terraform-aws-nomad/variables.tf` AMI variable
12. Change the key-pair value in the `variables.tf` to your own
13. In the `/hashicraft_ami/` dir run `terraform plan` then `terraform apply`
14. Once the instances are up and running, confirm the cluster is running by:
   be in the `/terraform-aws-nomad/` dir
   run `./examples/nomad-examples-helper/nomad-examples-helper.sh`
   example output:
   ```Your Nomad servers are running at the following IP addresses:

    54.203.239.182
    54.244.66.24
    35.155.216.69

    Some commands for you to try:

    nomad server members -address=http://54.203.239.182:4646
    nomad node status -address=http://54.203.239.182:4646
    nomad run -address=http://54.203.239.182:4646 /vagrant/hashicraft_ami/terraform-aws-nomad/examples/nomad-examples-helper/example.nomad
    nomad status -address=http://54.203.239.182:4646 example
   ```
15. SSH into your Nomad Server
16. Run `waypoint install -platform=nomad -nomad-dc=us-west-2a -accept-tos`
17. Take note of the port in the output, example:
```Advertise Address: 10.0.103.117:30496```
18. Run `waypoint user token` and take note of the token
19. Get the Public IP of your Nomad Client. Connect to the UI with `https://<public ip of nomad client>:9702 `
20. Authenticate with the token from the previous step
21. In the UI find the invite command in the top right to create a CLI command
22. Modify the command to look like this:
    ``` 
       sudo waypoint context create \
       -server-addr=<public ip of nomad client>:<port from earlier steps> \
       -server-auth-token=<token generated by UI> \
       -server-require-auth=true \
       -server-tls-skip-verify \
       -set-default default ```
23. Run the above command in your local environment
24. Run `waypoint context verify` to verify your CLI has been configured to the remote waypoint server
25. Go to the `/hashicraft_src` dir
26. Run `waypoint init`
27. Run `waypoint up`
28. Connect to the minecraft server using the Nomad Client's public IP
29. Clean up, run `terraform destroy` in `/hashicraft_ami/terraform-aws-nomad/` dir
