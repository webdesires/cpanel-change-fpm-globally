# cPanel Change FPM Globally

This script allows you to globally enable or disable PHP-FPM for all domains on a cPanel server. It is useful for system administrators who need to switch FPM settings across multiple accounts efficiently.

## Features
- Enable or disable PHP-FPM for all domains on a WHM/cPanel server.
- Saves time by applying changes globally instead of configuring each domain individually.
- Works with cPanel's API to ensure safe and reliable changes.

## Installation
To download the script, use the following command:

```sh
wget https://raw.githubusercontent.com/webdesires/cpanel-change-fpm-globally/main/cpanel-change-fpm-globally.sh
chmod +x cpanel-change-fpm-globally.sh
```

## Usage
Run the script with the appropriate argument:

```sh
./cpanel-change-fpm-globally.sh enable  # Enable PHP-FPM globally
./cpanel-change-fpm-globally.sh disable # Disable PHP-FPM globally
```

## Requirements
- WHM/cPanel with root access
- Bash shell

## Disclaimer  

This script is provided "as-is," without any warranty. Use at your own risk. The authors are not responsible for any data loss or issues caused by using this script. Always back up your database before running any modification scripts.

## Donations  

If you find this script useful and would like to support its development, consider making a donation:

- PayPal: [Donate via PayPal](https://www.paypal.me/webdesires)  

Your contributions are greatly appreciated!

## License  

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.  
