#!/bin/bash

## Installing Node Exporter
cd /home/ansible/
echo ----- Installing Prometheus Node Exporter ------
wget https://github.com/prometheus/node_exporter/releases/download/v1.2.2/node_exporter-1.2.2.linux-amd64.tar.gz
tar xvf node_exporter-1.2.2.linux-amd64.tar.gz
sudo cp node_exporter-1.2.2.linux-amd64/node_exporter /usr/local/bin
sudo cp prometheus-grafana/node-exporter.service /etc/systemd/system/node-exporter.service
sudo systemctl enable node_exporter
sudo systemctl start node-exporter