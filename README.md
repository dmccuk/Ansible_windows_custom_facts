## Ansible windows custom facts

### Get facts from Windows servers
In this video I want to show you, as a Linux admin, how to get facts from a windows wserver.


To set the scene, you're a ```Linux admin``` who works with Ansible. You already collect facts, including custom facts from Linux servers, but you've been asked to extend this to a small number of Windows servers. Apart from the usual facts collected by the setup module, we also need to know the versions of installed software so we can get a picture across our estate. You maybe don't know how to write powershell but you know it can't be that hard...

This is what I'm going to show you today:

  * I already have Ansible able to manage a windows server. If you don't, check out my other video on gtting that setup: https://youtu.be/aPN18jLRkJI or for SSH connectivity use: https://youtu.be/RESB6ksAlj0
  * I'm going to show you how to collect facts from a windows server using the setup module.
  * Next I'll add a custom facts to collect the ```apache``` version installed. If it's not installed, we add ```not installed``` into setup.

If you find this useful, please subscribe and like my work!

Lets get started...


### Clone the repo
Clone this repo and setup you Ansible configuration to connect to the Windows server. I'm doing this over SSH:22.


### Setup the Windows server for SSH
To be able to confirm this and follow along, you need to have a working setup. Follow the video link above and follow my steps to get Ansible managing windows servers.

I'll quickly cover the commands needed on Windows here and the ansible setup required.

Windows server commands:

````
Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH*'

Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0

**--------------
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

Alternatively use this command to install:
dism /Online /Add-Capability /CapabilityName:OpenSSH.Server~~~~0.0.1.0
**------------

Start-Service sshd

Set-Service -Name sshd -StartupType 'Automatic'

if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
    Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
    New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
} else {
    Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
}
````

#### Create the hosts.ini file:

````
[ec2-user@ip-172-31-16-55 windows]$ vi hosts.ini
[win]
IP_ADDRESS

[win:vars]
ansible_user=Administrator
ansible_password="PASSWORD"
ansible_connection=ssh
ansible_shell_type=cmd
ansible_ssh_common_args=-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
ansible_ssh_retries=3
ansible_become_method=runas
````

#### Confirm connectivity via Ansible to Windows

````
$ ansible win  -m win_ping
````

You shoud get back a green pong!

#### Powershell
Manually run the powershell command to see it in action.

Inside files/local.ps1, you will find the command I'm running. Run them on the command line to see what they do.

#### Run Ansible to collect the fact
Now run ansible to send over the local.ps1 file to Windows and run it, collecting the custom fact along with it.


#### Check the fact
On the linux server, I've copied the server facts file from the windows server back over to the linux server. Now we can use JQ to pull out the custom fact we just created.

````
$  cat /tmp/facts/EC2AMAZ-SN1IBVJ.yaml | jq  -r '.ansible_facts.ansible_local.local.local_facts'
{
  "apache_name": "2.2.25",
  "apache": "2.2.25        ",
  "other": "Other_not_installed"
}
````

### Next steps
Now you've got this overview and example of collecting specific information to use in custom facts, you can extend this almost any piece of information available on the Windows server.



