#!/bin/bash
puppet strings generate manifests/init.pp manifests/s3_mount.pp --format markdown -o REFERENCE.MD
