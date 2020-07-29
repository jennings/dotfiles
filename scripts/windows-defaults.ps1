# Disable Start Menu suggestions (Windows 10 ver 2004+)
# https://www.howtogeek.com/224159/how-to-disable-bing-in-the-windows-10-start-menu/
reg add HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer /v DisableSearchBoxSuggestions /t REG_DWORD /d 1

# Disable Start Menu suggestions (Windows 10 ver 1910-)
# https://www.howtogeek.com/224159/how-to-disable-bing-in-the-windows-10-start-menu/
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search /v BingSearchEnabled /t REG_DWORD /d 0
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search /v CortanaConsent /t REG_DWORD /d 0
