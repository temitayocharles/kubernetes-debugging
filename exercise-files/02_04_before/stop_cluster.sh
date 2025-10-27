#!/usr/bin/env bash
set -x
jobs -l
kind delete cluster --name kind
