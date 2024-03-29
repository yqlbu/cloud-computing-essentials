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
sudo ip6tables -P INPUT ACCEPT
sudo ip6tables -P FORWARD ACCEPT
sudo ip6tables -P OUTPUT ACCEPT
sudo ip6tables -F
sudo netfilter-persistent save
```

</p></details>

<details><summary>Set Up UFW</summary>
</br>

```
sudo systemctl disable firewalld --now
sudo apt install ufw
sudo systemctl enable ufw --now

sudo ufw limit 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
sudo ufw status
```
  
</details>

## Enable BBR

```bash
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p

# verify
sysctl net.ipv4.tcp_available_congestion_control
# successful console ouput
# net.ipv4.tcp_available_congestion_control = reno cubic bbr
lsmod | grep bbr
# successful console ouput
tcp_bbr 24576 1
```

## Scripts

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
curl -so- 86.re/bench.sh | bash

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
