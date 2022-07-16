# Oracle Cloud General

## Network Access

NOTES:

- You also need to configure public gateway rules to allow ingress traffic
- Allow inbound traffic for a specific port. You also need to setup the firewall rules in the Oracle Cloud Console.

```bash
sudo iptables -I INPUT -s 0.0.0.0/0 -p tcp --dport 8888 -j ACCEPT
sudo iptables -I INPUT -s 0.0.0.0/0 -p tcp --dport 80 -j ACCEPT
sudo iptables -I INPUT -s 0.0.0.0/0 -p tcp --dport 443 -j ACCEPT
sudo iptables-save
sudo apt-get update
sudo apt-get install iptables-persistent -y
sudo netfilter-persistent save
sudo netfilter-persistent reload
```

<details><summary>Enable Tracfic For All Ports</summary>

</br>

```
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -F
sudo netfilter-persistent save
```

</p></details>

## Scripts

<details><summary>BBR Script</summary>

</br>

```bash
wget -N --no-check-certificate "https://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/tcp.sh" && chmod +x tcp.sh && ./tcp.sh
```

</details>

<details><summary>V2ray Agent Installation</summary>

</br>

```bash
wget -P /root -N --no-check-certificate "https://raw.githubusercontent.com/mack-a/v2ray-agent/master/install.sh" && chmod 700 /root/install.sh && /root/install.sh
```

</details>

<details><summary>Enable SSH with Password</summary>

</br>

```bash
#!/bin/bash

echo root:<Your Password> | sudo chpasswd root
sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config;
sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config;
sudo service sshd restart
```

</p></details>

<details><summary>Speedtest</summary>

</br>

```bash
wget -qO- bench.sh | bash

# OR (CN)

bash <(curl -Lso- https://git.io/superspeed)

# OR (Lemon)

wget -qO- http://ilemonra.in/LemonBenchIntl | bash -s fast

# OR (Superbench)

wget -qO- git.io/superbench.sh | bash
```

</p></details>

<details><summary>Beenchmark test</summary>

</br>

```bash
wget -qO- --no-check-certificate https://raw.githubusercontent.com/oooldking/script/master/superbench.sh | bash
```

</p></details>

## Useful Links

- [Arm-based cloud computing is the next big thing: Introducing Arm on Oracle Cloud Infrastructure](https://blogs.oracle.com/cloud-infrastructure/arm-based-cloud-computing-is-the-next-big-thing-introducing-arm-on-oci)
- [Build your first Arm app using Kubernetes and Oracle Cloud Infrastructure](https://docs.oracle.com/en/learn/arm_oke_cluster_oci/index.html)
- [Deploy Java applications on Ampere A1 on Oracle Cloud Infrastructure](https://docs.oracle.com/en/learn/java_app_ampere_oci/index.html)
- [Oracle launches Arm instances, support for Arm-based app development](https://www.zdnet.com/article/oracle-launches-arm-instances-support-for-arm-based-app-development/)
- [Details of the Always Free Resources](https://docs.oracle.com/en-us/iaas/Content/FreeTier/resourceref.htm)
