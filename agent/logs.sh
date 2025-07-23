#!/bin/bash

journalctl -u agent.service -n 50 --no-pager
