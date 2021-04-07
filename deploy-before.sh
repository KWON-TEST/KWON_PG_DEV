if [ -d /home/ec2-user/build ]; then
    sudo rm -rf /home/ec2-user/build/
fi
sudo mkdir -vp /home/ec2-user/build/
sudo mkdir -vp /home/ec2-user/build/logs
sudo chown ec2-user:ec2-user /home/ec2-user/build/logs