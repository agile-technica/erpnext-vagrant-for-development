#!/usr/bin/env bash
cd /mounted-space/app/frappe-bench/  && bench clear-cache  && bench update --build && bench migrate
