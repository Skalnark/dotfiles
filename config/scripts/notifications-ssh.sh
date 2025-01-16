#!/bin/sh

ssh -i $HOME/Documents/rds-ssh-tunnel.pem ubuntu@rds-ssh-tunnel.orbee.io -L 5430:orb-services-1.dbs.us-west-2.orbee.io:5432 -N
