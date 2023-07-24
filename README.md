# Monitoring CPU Usage

Monitor CPU percentage of an ec2 instance every minute and send top 5 process names to a email if CPU usage exceeds 70%

## Setting up the ubuntu environment

```
sudo apt update
sudo apt install sysstat
sudo apt install ssmtp
sudo apt install mailutils
```

## Setting up ssmtp

```
sudo vim /etc/ssmtp/ssmtp.conf 
```

Paste these below followings. 

```
mailhub=smtp.gmail.com:587
AuthUser=your_gmail@gmail.com
AuthPass=your_gmail_password_for_ssmtp
UseSTARTTLS=YES
```

**Note**: Please replace `your_gmail@gmail.com` to your email and `your_gmail_password_for_ssmtp` to your gmail password for ssmtp

You can set gmail password for ssmtp in google account settings

![image-20230721114058534](README.assets/image-20230721114058534.png)

![image-20230721114136753](README.assets/image-20230721114136753.png)

Then click `Get started` button

![image-20230721114317839](README.assets/image-20230721114317839.png)

When you add ssmtp to here, you will get the password for ssmtp



Test it with below simple echo cmd 

```
echo “your text” | ssmtp your_receiver@gmail.com
```

## Create shell

Then, Create folder and file 

```
sudo su mkdir SCRIPTS 
touch CpuAlert 
chmod +x CpuAlert.sh 
vi CpuAlert.sh
```

Copy paste the CpuAlert.sh files from this repo and replace your desired destination mail ID (line 6) and Percentage threshold (line 3).

## Execute

```
sh -x CpuAlert.sh
```

Now , whenever the file is executed, it will check the CPU usage and if it exceeds more than 70, it will send the top 5 process to the destination mail through SMTP.

Now, we have to enable CRONTAB for scheduling to run the command for every 1 minute.

```
crontab -e
```

```
_/1 _ \* \* \* /bin/bash /home/user_name/SCRIPTS/CpuAlert.sh
```

# Monitoring CPU and RAM Usage

Monitor CPU and RAM percentage of an ec2 instance every minute and send top 5 process names to a email if CPU or RAM usage exceeds 70%

The setting step is same as `monitoring cpu usage`, You just need to use CpuRamAlert.sh instead of CpuAlert.sh.

# Saving CPU and RAM usage to local file

Monitor CPU and RAM percentage of an ec2 instance every minute and save top 5 process names to local file if CPU or RAM usage exceeds 70%

## Setting up the ubuntu environment

```
sudo apt update
sudo apt install sysstat
```

## Create shell

Then, Create folder and file 

```
sudo su mkdir SCRIPTS 
touch CpuRamToLocal 
chmod +x CpuRamToLocal.sh 
vi CpuRamToLocal.sh
```

Copy paste the CpuRamToLocal.sh files from this repo and replace your destination folder path (line 3) and Percentage threshold (line 18).

The default path is `/tmp/logs`, and the default percentage threshold is `70%`

## Execute

```
sh -x CpuRamToLocal.sh
```

Now , whenever the file is executed, it will check the CPU usage and RAM usage, if one of both exceeds more than 70, it will save the top 5 process to the destination log file.

Now, we have to enable CRONTAB for scheduling to run the command for every 1 minute.

```
crontab -e
```

```
_/1 _ \* \* \* /bin/bash /home/user_name/SCRIPTS/CpuRamToLocal.sh
```

