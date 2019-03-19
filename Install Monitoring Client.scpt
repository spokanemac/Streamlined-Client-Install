-- Install Latest Monitoring Client.
-- Created 2013.07.29 by Jack-Daniyel Strong.
-- 2013.07.29 - Initial Configuration
-- 2019.03.18 - Subdomain settings

-- Portions (C)opyright 2008-2019 J-D Strong Consulting, Inc.

-- Variable settings:

property MyTitle : "Our Remote Support Installer"
property Subdomain : "ors"
property TimeMachine : 30 -- Days to notify. Default is 7
property ClientGroup : "" -- Optional force into a client group
property debug : false

-- No need to change these settings
property defaults : "/usr/bin/defaults"
property MONITORINGCLIENT : "/Library/MonitoringClient/ClientSettings"
property MONITORINGCLIENTPLUGIN : "/Library/MonitoringClient/PluginSupport/"
property defaults_write : defaults & " write "


-- Start the script (double click)
on run
	my main()
end run

on main()
	try
		
		repeat
			set tTitle to "Client Group or Email"
			set tPrompt to "Please enter a valid client group or email address:"
			set tClientGroup to text returned of (display dialog tPrompt ¬
				default answer ClientGroup buttons {"Cancel", "Continue"} ¬
				default button 2 with title tTitle)
			try
				set ClientGroup to (tClientGroup as text)
				if ((length of ClientGroup) ≥ 10) then
					exit repeat
				end if
			end try
		end repeat
		
		my InstallWatchman()
		
		my AlertDone()
		
		-- Catch any unexpected errors:
	on error ErrorMsg number ErrorNum
		my DisplayErrorMsg(ErrorMsg, ErrorNum)
	end try
end main


-- Install Watchman
on InstallWatchman()
	
	-- Built the command to run
	set cmd to defaults_write & MONITORINGCLIENT & " ClientGroup -string \"" & ClientGroup & "\" && "
	set cmd to cmd & defaults_write & MONITORINGCLIENTPLUGIN & "check_time_machine_settings Days_Until_Warning -int " & TimeMachine & " && "
	set cmd to cmd & "/usr/bin/curl -L1 https://" & Subdomain & ".monitoringclient.com/downloads/MonitoringClient.pkg > /tmp/MonitoringClient.pkg &&"
	set cmd to cmd & " /usr/sbin/installer -target / -pkg /tmp/MonitoringClient.pkg;"
	
	if debug then
		my DisplayInfoMsg(cmd)
	else
		do shell script cmd with administrator privileges
	end if
	
end InstallWatchman

on AlertDone()
	-- get current volume settings
	set curVolume to output volume of (get volume settings)
	set curAlertVolume to alert volume of (get volume settings)
	set isMuted to output muted of (get volume settings)
	-- check for a mute, and unmute
	if isMuted then set volume without output muted
	-- turn it up to 11
	set volume output volume 100
	set volume alert volume 100
	beep 3 -- get attention
	-- CleanUp
	set volume output muted isMuted
	set volume output volume curVolume
	set volume alert volume curAlertVolume
	
	display dialog "Done!" buttons {"OK"} default button 1 with icon note with title MyTitle giving up after 5
end AlertDone

-- Display information to the user:

on DisplayInfoMsg(DisplayInfo)
	tell me
		activate
		display dialog DisplayInfo buttons {"OK"} default button 1 with icon note with title MyTitle
	end tell
end DisplayInfoMsg

-- Display an error message to the user:

on DisplayErrorMsg(ErrorMsg, ErrorNum)
	set Msg to "Sorry, an error occured:" & return & return & ErrorMsg & " (" & ErrorNum & ")"
	tell me
		activate
		display dialog Msg buttons {"OK"} default button 1 with icon stop with title MyTitle
	end tell
end DisplayErrorMsg
