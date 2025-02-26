#!/bin/bash

# Get system information
os=$(uname -s)
ram=$(free -m | awk '/^Mem:/{print $2}')
cpu_cores=$(nproc)

# Suggest values based on system information
suggested_max_children=$((cpu_cores * 2))
suggested_max_requests=500
suggested_idle_timeout="60s"

if [ "$ram" -lt 2048 ]; then
    suggested_max_children=5
elif [ "$ram" -lt 4096 ]; then
    suggested_max_children=10
elif [ "$ram" -lt 8192 ]; then
    suggested_max_children=20
elif [ "$ram" -lt 16384 ]; then
    suggested_max_children=40
elif [ "$ram" -lt 32768 ]; then
    suggested_max_children=80
elif [ "$ram" -lt 65536 ]; then
    suggested_max_children=160
elif [ "$ram" -lt 131072 ]; then
    suggested_max_children=320
else
    suggested_max_children=640
fi

# Prompt the user for values with suggestions
read -p "Enter the new value for pm_max_children (suggested: $suggested_max_children, enter 0 to skip): " max_children
read -p "Enter the new value for pm_max_requests (suggested: $suggested_max_requests, enter 0 to skip): " max_requests
read -p "Enter the new value for pm_process_idle_timeout (suggested: $suggested_idle_timeout, enter 0 to skip): " idle_timeout

# Use suggested values if user input is empty
max_children=${max_children:-$suggested_max_children}
max_requests=${max_requests:-$suggested_max_requests}
idle_timeout=${idle_timeout:-$suggested_idle_timeout}

# Loop through all files and replace the lines
for file in /var/cpanel/userdata/*/*.php-fpm.yaml; do
    if [ "$max_children" -ne 0 ]; then
        if grep -q "pm_max_children:" "$file"; then
            sed -i "s/pm_max_children:.*/pm_max_children: $max_children/" "$file"
        else
            echo "pm_max_children: $max_children" >> "$file"
        fi
    fi
    if [ "$max_requests" -ne 0 ]; then
        if grep -q "pm_max_requests:" "$file"; then
            sed -i "s/pm_max_requests:.*/pm_max_requests: $max_requests/" "$file"
        else
            echo "pm_max_requests: $max_requests" >> "$file"
        fi
    fi
    if [ "$idle_timeout" -ne 0 ]; then
        if grep -q "pm_process_idle_timeout:" "$file"; then
            sed -i "s/pm_process_idle_timeout:.*/pm_process_idle_timeout: $idle_timeout/" "$file"
        else
            echo "pm_process_idle_timeout: $idle_timeout" >> "$file"
        fi
    fi

    echo "Edited file: $file"

done

# Change the global settings file
if [ "$max_children" -ne 0 ]; then
    if grep -q "pm_max_children:" "/var/cpanel/ApachePHPFPM/system_pool_defaults.yaml"; then
        sed -i "s/pm_max_children:.*/pm_max_children: $max_children/" "/var/cpanel/ApachePHPFPM/system_pool_defaults.yaml"
    else
        echo "pm_max_children: $max_children" >> "/var/cpanel/ApachePHPFPM/system_pool_defaults.yaml"
    fi
fi
if [ "$max_requests" -ne 0 ]; then
    if grep -q "pm_max_requests:" "/var/cpanel/ApachePHPFPM/system_pool_defaults.yaml"; then
        sed -i "s/pm_max_requests:.*/pm_max_requests: $max_requests/" "/var/cpanel/ApachePHPFPM/system_pool_defaults.yaml"
    else
        echo "pm_max_requests: $max_requests" >> "/var/cpanel/ApachePHPFPM/system_pool_defaults.yaml"
    fi
fi
if [ "$idle_timeout" -ne 0 ]; then
    if grep -q "pm_process_idle_timeout:" "/var/cpanel/ApachePHPFPM/system_pool_defaults.yaml"; then
        sed -i "s/pm_process_idle_timeout:.*/pm_process_idle_timeout: $idle_timeout/" "/var/cpanel/ApachePHPFPM/system_pool_defaults.yaml"
    else
        echo "pm_process_idle_timeout: $idle_timeout" >> "/var/cpanel/ApachePHPFPM/system_pool_defaults.yaml"
    fi
fi

echo "Edited file: /var/cpanel/ApachePHPFPM/system_pool_defaults.yaml"

# Restart php-fpm
echo "Restarting FPM..."

/scripts/restartsrv_cpanel_php_fpm

echo "FPM restarted, all done!"
