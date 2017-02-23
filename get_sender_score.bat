@echo off
setlocal enabledelayedexpansion

REM variable to hold date and time
set date_time=%date:~6,4%-%date:~3,2%-%date:~0,2%_%time:~0,2%-%time:~3,2%-%time:~6,2%

REM variable to hold results_file
set results_file="output/sender_scores_%date_time%.csv"

REM echo started date and time
echo ^> Started: %date% %time%

REM for each line in ips.txt file
for /f "delims=" %%a in (input/client_ips.txt) do (
	REM variable to hold client and ip address
	set client_ip=%%a

	for /f "tokens=1,2 delims=," %%a in ("!client_ip!") do (
		REM variable to hold client
		set client=%%a
		REM variable to hold ip address
		set ip=%%b
	)

	REM for each part of ip address separated by dots
	for /f "tokens=1,2,3,4 delims=." %%a IN ("!ip!") do (
		REM variable to hold the reverse ip address
		set reverse_ip=%%d.%%c.%%b.%%a

		REM for ip address, run nslookup
		for /f "skip=4 tokens=2" %%a in ('"nslookup !reverse_ip!.score.senderscore.com 2>nul"') do (
			REM variable to hold returned sender score ip address
			set sender_score_ip=%%a

			REM for each part of returned sender score ip address separated by dots
			for /f "tokens=1,2,3,4 delims=." %%a IN ("!sender_score_ip!") do (
				REM variable to hold sender score
				set sender_score=%%d
				REM write the ip address and its sender score to results file
				echo !client!,!ip!,!sender_score! >> %results_file%
			)
		)
	)
)

REM echo ended date and time
echo ^> Ended: %date% %time%
REM echo results file destination
echo ^> Sender scores saved in %results_file%
