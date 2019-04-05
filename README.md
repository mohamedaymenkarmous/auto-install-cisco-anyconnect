# auto-install-cisco-anyconnect
Automatically installing Cisco Anyconnect Secure Mobility Client on Windows [7/10]

## Prerequisite
First of all, you should download download ``anyconnect-win-4.5.05030-predeploy-k9.zip`` package from [This link : Cisco Anyconnect Secure Mobility Client - Release 4.5.05030 (for example)](https://software.cisco.com/download/home/286281283/type/282364313/release/4.5.05030?i=!pp)

Then, download this project and put its files with `anyconnect-win-*` files.

If you are using `Network Access Manager (NAM) package`, put your `configuration.xml` file inside `Profiles\nam\` directory.

## Local installation
If you are going to install Cisco Anyconnect Secure Mobility Client from local machine, you should execute `0-EXECUTE-AS-ADMIN-LOCAL.bat` as Administrator.
This will execute the following steps:

1- Install ``anyconnect-win-4.5.02036-core-vpn-predeploy-k9.msi`` and create a log file inside `tmp\1-anyconnect-win-4.5.02036-core-vpn-predeploy-k9.log`

2- Install ``anyconnect-win-4.5.02036-nam-predeploy-k9.msi`` and create a log file inside `tmp\2-anyconnect-win-4.5.02036-nam-predeploy-k9.log`

3- Install ``anyconnect-win-4.5.02036-iseposture-predeploy-k9.msi`` and create a log file inside `tmp\3-anyconnect-win-4.5.02036-iseposture-predeploy-k9.log`

4- Install ``anyconnect-win-4.5.02036-dart-predeploy-k9.msi`` and create a log file inside `tmp\4-anyconnect-win-4.5.02036-dart-predeploy-k9.log`

5- Since `Network Access Manager (NAM) package` is installed, its configuration file `Profiles\nam\configuration.xml` will be copied inside `C:\ProgramData\Cisco\Cisco AnyConnect Secure Mobility Client\Network Access Manager\newConfigFiles\`.

6- Copying translation directory (to customize Client messages) from `Profiles\custom\fr-fr` to `C:\ProgramData\Cisco\Cisco AnyConnect Secure Mobility Client\l10n\`

7- Putting a custom Logo for your company by copying it from `Profiles\custom\company_logo.png` to `%PROGRAMFILES(X86)%\Cisco\Cisco AnyConnect Secure Mobility Client\res\`

8- Since `Network Access Manager (NAM) package` is installed, by default Single Logon feature will be enforced ([for more information please see 'Single Sign On “Single User” Enforcement' section](https://www.cisco.com/c/en/us/td/docs/security/vpn_client/anyconnect/anyconnect45/administration/guide/b_AnyConnect_Administrator_Guide_4-5/configure_nam.html) which is not advantageous for some company that allows multiple users to open their sessions on the same computer. This is why this feature should be disabled (maybe) from Windows Registry (regedit).

9- Since `Network Access Manager (NAM) package` is installed, for windows 10 operating system there is [a workaround](https://quickview.cloudapps.cisco.com/quickview/bug/CSCuw01496) that should be applied so that authentication will be successfull. This workaround will be applied from Windows Registry (regedit).

All these steps can be modified. This is an example of an automatic installation. You can add and delete whatever you want.


## Remote installation
If you have a shared directory from which you are going to install Cisco Anyconnect Secure Mobility Client remotely, you should  edit `0-EXECUTE-AS-ADMIN-REMOTE.bat` and then run it as Administrator.

### Modifications
First of all, you should specify the remote host address from which you are going to install the client by replacing `<REMOTE_HOST>` with your remote hostname or IP address (from line 27 and 28).
Then, replace `<REMOTE_DIRECTORY>` with the real path that contains the installation files (from line 27 and 28).
Example: `\\192.168.1.100\anyconnect_auto_setup`

### Installation
This will execute the following steps:

1- Switch the current location to `%TEMP%`

2- Removes the old working directory (if it exists) and creates it again `Anyconnect-install-dir`.

3- Switch the current location to `%TEMP%\Anyconnect-install-dir` as a workind directory.

4- Copy `\\<REMOTE_HOST>\<REMOTE_DIRECTORY>` content inside `%TEMP%\Anyconnect-install-dir`.

5- Run `0-EXECUTE-AS-ADMIN-LOCAL.bat` and executes the `Local installation` steps.

