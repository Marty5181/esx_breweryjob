# fxserver-esx_breweryjob
FXServer ESX Brewery Job

If you want to modify or add somethings to the script please contact us or mention us
[REQUIREMENTS]

	* Auto mode
	* esx_service => https://github.com/FXServer-ESX/fxserver-esx_service
  
	* Player management (billing and boss actions)
	* esx_society => https://github.com/FXServer-ESX/fxserver-esx_society
	* esx_billing => https://github.com/FXServer-ESX/fxserver-esx_billing

[INSTALLATION]

1) CD in your resources/[esx] folder
2) Copy the repository
3) Import fr_esx_breweryjob.sql OR en_esx_breweryjob.sql in your database (not the both)

4) Add this in your server.cfg :

```
start esx_breweryjob
```

5) If you want player management you have to set Config.EnablePlayerManagement on true in config.lua
# esx_breweryjob

