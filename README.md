# Streamlined-Client-Install
Streamlines the installation of your latest Watchman Monitoring client with a single prompt for group.

This AppleScript is designed to streamline the install process of your monitoring client.

It will prompt for a group name (this can be pre-assigned), then an admin username and password, finally a confirmation that the install succeeded.

If the install fails, generally, this is due to the computer not being on-line.

To create a signed applications, in Script Editor _File_ > _Export…_

Set to _Application_ and optionally choose a signing certificate.



# Settings
Title of the Installer

`property MyTitle : "Our Remote Support Installer"`

Your subdomain

`property Subdomain : "ors"`

Days before Watchman Monitoring notifies you that Time Machine isn't not completing a backup.

`property TimeMachine : 30 -- Days to notify. Default is 7`

Optional Client Group Setting

`property ClientGroup : "" -- Optional force into a client group`

Set to true to receive a dialog with the final command instead of executing the command

`property debug : false`
