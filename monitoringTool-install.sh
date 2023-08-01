#!/bin/bash

## installation package  versions
prometheus_version=2.42.0
node_exporter_version=1.5.0
blackbox_exporter_version=0.23.0
alertmanager_version=0.25.0
grafana_version=9.4.3


## Installing Prometheus  ---- port 9090
echo ----- Installing Prometheus ------
wget https://github.com/prometheus/prometheus/releases/download/v${prometheus_version}/prometheus-${prometheus_version}.linux-amd64.tar.gz
tar -xvf prometheus-${prometheus_version}.linux-amd64.tar.gz 
cd prometheus-${prometheus_version}.linux-amd64/
sudo cp -r . /usr/local/bin/prometheus
sudo cp /home/ec2-user/blackbox-monitoring/prometheus.service /etc/systemd/system/prometheus.service
sudo systemctl enable prometheus
sudo systemctl start prometheus


## Installing Node Exporter  ---- port 9100
cd /home/ec2-user/
echo ----- Installing Prometheus Node Exporter ------
wget https://github.com/prometheus/node_exporter/releases/download/v${node_exporter_version}/node_exporter-${node_exporter_version}.linux-amd64.tar.gz
tar xvf node_exporter-${node_exporter_version}.linux-amd64.tar.gz
sudo cp node_exporter-${node_exporter_version}.linux-amd64/node_exporter /usr/local/bin
sudo cp blackbox-monitoring/node-exporter.service /etc/systemd/system/node-exporter.service
sudo systemctl enable node-exporter
sudo systemctl start node-exporter


## Installing Black Box Exporter  ---- port 9115
cd /home/ec2-user/
echo ---- Installing Blackbox exporter -----
wget https://github.com/prometheus/blackbox_exporter/releases/download/v${blackbox_exporter_version}/blackbox_exporter-${blackbox_exporter_version}.linux-amd64.tar.gz
tar xvf blackbox_exporter-${blackbox_exporter_version}.linux-amd64.tar.gz
cd blackbox_exporter-${blackbox_exporter_version}.linux-amd64/
sudo cp -r . /usr/local/bin/blackbox
sudo cp /home/ec2-user/blackbox-monitoring/blackbox.yml /usr/local/bin/blackbox
sudo cp /home/ec2-user/blackbox-monitoring/blackbox.service /etc/systemd/system/blackbox.service
sudo systemctl enable blackbox
sudo systemctl start blackbox


## Installing Alert Manager  ---- port 9093
cd /home/ec2-user/
echo ----- Installing Prometheus Alert Manager ------
wget https://github.com/prometheus/alertmanager/releases/download/v${alertmanager_version}/alertmanager-${alertmanager_version}.linux-amd64.tar.gz
tar vxf alertmanager-${alertmanager_version}.linux-amd64.tar.gz
cd alertmanager-${alertmanager_version}.linux-amd64/
sudo cp -r . /usr/local/bin/alertmanager
cd /home/ec2-user/
sudo cp blackbox-monitoring/alertmanager.service  /etc/systemd/system/alertmanager.service
sudo rm /usr/local/bin/alertmanager/alertmanager.yml
sudo cp blackbox-monitoring/alertmanager.yml /usr/local/bin/alertmanager/alertmanager.yml
# /usr/local/bin/alertmanager/amtool check-config /usr/local/bin/alertmanager/alertmanager.yml
sudo systemctl enable alertmanager
sudo systemctl start alertmanager


## include Node-exporter job on prometheus.yml file and creating prometheus_rule.yml file
cd /home/ec2-user/
echo ----- include Node and blackbox exporter job on prometheus.yml file and creating prometheus_rule.yml file -----
sudo cp /home/ec2-user/blackbox-monitoring/prometheus.yml /usr/local/bin/prometheus/prometheus.yml 
sudo cp blackbox-monitoring/prometheus_rules.yml  /usr/local/bin/prometheus/prometheus_rules.yml
sudo systemctl restart prometheus
# ./promtool check rules prometheus_rules.yml


## Installing Grafana Server ---- port 3000
cd /home/ec2-user/
echo ----- Installing grafana -------
wget https://dl.grafana.com/enterprise/release/grafana-enterprise-${grafana_version}-1.x86_64.rpm
sudo yum install grafana-enterprise-${grafana_version}-1.x86_64.rpm -y
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

## Copy monitoring update script to home folder
echo ----- copying monitoring update file to home folder -----
sudo cp -rf /home/ec2-user/blackbox-monitoring/monitoring-update.sh /home/ec2-user/


## Grafana DashBoard
# import 11175 & 1860

## Cleanup
cd /home/ec2-user
rm -rf *tar.gz
