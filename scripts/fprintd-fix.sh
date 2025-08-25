#!/usr/bin/env bash

echo "killing fprintd processes...☠️"
sudo killall fprintd

echo
echo *──────────────────────────────***──────────────────────────────*
echo

echo "Starting fprintd service...🚀"
sudo systemctl start fprintd

echo
echo *──────────────────────────────***──────────────────────────────*
echo

echo "Enrolling fingerprint ⏳"
fprintd-enroll

echo
echo *──────────────────────────────***──────────────────────────────*
echo

echo "Verifying ℹ️"
fprintd-verify

echo
echo *──────────────────────────────***──────────────────────────────*
echo

echo "Done ✅."
