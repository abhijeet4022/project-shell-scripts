# project-shell-scripts
Repository for shell scripts used to automate OS tasks in the project.


# Pre-Requisites
1. Launch 10 VMs in AWS, one for each component. Use CentOS 8 for practice.
2. Purchase a domain for the application.
3. Create a public hosted zone in Route 53 using the domain.
   * Update the domain registrar's NS (Name Servers) with the NS provided by Route 53.
4. If a domain is not available, use a private hosted zone.
5. Create A records for each VM (component) with their private IPs.
   * Replace the existing A records in the scripts with the newly created ones.

# AWS AMI
"ami-0b4f379183e5706b9"
