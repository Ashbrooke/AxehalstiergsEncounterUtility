:: ===================================================================
:: Startup ===========================================================
:: ===================================================================
@ECHO OFF
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
SET me=%~n0
SET parent=%~dp0
SET Version=1.0b
SET IniValidation=FALSE
SET Players=0
:: Default File Save Names
SET logfile=aeulog.txt
SET inifile=aeuini.cmd
SET campfile=aeucamp.cmd
SET combfile=aeucomb.txt

:: ===================================================================
:: Logging
:: ===================================================================
IF EXIST %logfile% GOTO :LogFound
>%logfile% ECHO %me%: Log created on %date% at %time%
GOTO :Initilization
:LogFound
>>%logfile% ECHO %me%: Log found on %date% at %time%

:: ===================================================================
:: Initilization
:: ===================================================================
:Initilization
IF EXIST %inifile% GOTO :AutoLoadIni
:: Auto create the default initilization
>>%logfile% ECHO %me%: Creating a new default initilization file...
>%inifile% ECHO @ECHO OFF
>>%inifile% ECHO SET IniValidation=TRUE
>>%inifile% ECHO SET Version=%Version%
>>%inifile% ECHO SET DefaultCampaign=%campfile%
>>%inifile% ECHO SET Players=0
>>%logfile% ECHO %me%: Default initilization file created.
GOTO :IniComplete

:AutoLoadIni
>>%logfile% ECHO %me%: Loading Default Initilization: %inifile%
GOTO :IniComplete

:Save
>>%logfile% ECHO %me%: Saving %inifile%...
>%inifile% ECHO @ECHO OFF
>>%inifile% ECHO SET IniValidation=%IniValidation%
>>%inifile% ECHO SET Version=%Version%
>>%inifile% ECHO SET Players=%Players%
FOR /L %%G IN (1,1,%Players%) DO (
	>>%inifile% ECHO SET Player%%G=!Player%%G!
	>>%inifile% ECHO SET Player%%G_MaxHealth=!Player%%G_MaxHealth!
	>>%inifile% ECHO SET Player%%G_CurHealth=!Player%%G_CurHealth!
    >>%inifile% ECHO SET Player%%G_Rounds=!Player%%G_Rounds!
    >>%inifile% ECHO SET Player%%G_Damage=!Player%%G_Damage!
    >>%inifile% ECHO SET Player%%G_Healing=!Player%%G_Healing!
)
>>%logfile% ECHO %me%: Initilization saved to %inifile%.
GOTO :IniComplete

:: ===================================================================
:: Initilization Complete
:: ===================================================================
:IniComplete
::More validation necessary
SET IniValidation=FALSE
CALL %inifile%
IF NOT %IniValidation% == TRUE GOTO :IniValidationError
>>%logfile% ECHO %me%: Initilization %inifile% loaded.
>>%logfile% ECHO %me%: Running version %Version%
GOTO :Menu

:IniValidationError
>>%logfile% ECHO %me%: The initilization file %inifile% did not validate.
>>%logfile% ECHO %me%: Closed due to invalid initilization.
EXIT /B 1

:: ===================================================================
:: Main Menu =========================================================
:: ===================================================================
:Menu
CLS
ECHO --------------------------------------------------------------------------------
ECHO ------------------------------ Main Menu ---------------------------------------
ECHO.
ECHO              Current Initilization: %inifile%
ECHO                1. Load file
ECHO                2. Export file
ECHO.
ECHO              Current Players: %Players% 
ECHO                3. Add Player 
ECHO                4. Remove Player
ECHO                5. List Players
ECHO.
ECHO              Navigation
ECHO                E. Proceed to Encounter
ECHO                Q. Quit
ECHO.
ECHO --------------------------------------------------------------------------------
SET MenuChoice=invalid
SET /P MenuChoice=
IF %MenuChoice% == 1 GOTO :MENU1
IF %MenuChoice% == 2 GOTO :MENU2
IF %MenuChoice% == 3 GOTO :MENU3
IF %MenuChoice% == 4 GOTO :MENU4
IF %MenuChoice% == 5 GOTO :MENU5
IF %MenuChoice% == e GOTO :EncMenuStart
If %MenuChoice% == E GOTO :EncMenuStart
IF %MenuChoice% == Q GOTO :QUIT
IF %MenuChoice% == q GOTO :QUIT
ECHO That wasn't a valid command, try again.
TIMEOUT 3
GOTO :Menu

:: ===================================================================
:: Load
:MENU1
CLS
ECHO ----------------------------------------
ECHO ---- Load Initilization
ECHO.
ECHO Name of file:
SET Findinifile="No Entry"
SET /P Findinifile=
IF NOT EXIST %Findinifile% (
	>>%logfile% ECHO %me%: Tried to load initilization %Findinifile%, but it doesn't exist.
	ECHO Sorry, %Findinifile% doesn't exist.
	TIMEOUT 3
	GOTO :Menu
) ELSE (
	>>%logfile% ECHO %me%: Trying to load %Findinifile% as an initilization file.
	SET inifile=%Findinifile%
	SET IniValidation=FALSE
	GOTO :IniComplete
)

:: ===================================================================
:: Export
:MENU2
CLS
ECHO ----------------------------------------
ECHO ---- Export Initilization
ECHO.
ECHO Export as:
SET ExportIni=export
SET /P ExportIni=
SET ExportIni=%ExportIni%.cmd
TYPE %inifile%>%ExportIni%
>>%logfile% ECHO %me%: Initilization exported as %ExportIni%
ECHO Initilization exported as %ExportIni%
TIMEOUT 3
GOTO :Menu

:: ===================================================================
:: Add Player
:MENU3
CLS
ECHO ----------------------------------------
ECHO ---- Current Players
ECHO.
FOR /L %%G IN (1,1,%Players%) DO (
	ECHO %%G. !Player%%G!
)
ECHO.
ECHO ----------------------------------------
ECHO ---- Create Player
ECHO.
SET /A Players+=1
ECHO Player Name:
SET Player%Players%=Player%Players%
SET /P Player%Players%=
ECHO.
ECHO Max Health:
SET Player%Players%_MaxHealth=0
SET /P Player%Players%_MaxHealth=
SET Player%Players%_CurHealth=!Player%Players%_MaxHealth!
SET Player%Players%_Rounds=1
SET Player%Players%_Damage=0
SET Player%Players%_Healing=0
>>%logfile% ECHO %me%: Player%Players% added: !Player%Players%! with !Player%Players%_MaxHealth!HP
ECHO Player%Players% added: !Player%Players%! with !Player%Players%_MaxHealth!HP
ECHO Current Players: %Players%
TIMEOUT 3
GOTO :Save

:: ===================================================================
:: Remove Player
:MENU4
CLS
IF %Players% == 0 (
	ECHO There are no players to remove!
	TIMEOUT 3
	GOTO :Menu
)
ECHO ----------------------------------------
ECHO ---- Current Players
ECHO.
FOR /L %%G IN (1,1,%Players%) DO (
	ECHO %%G. !Player%%G!
)
ECHO Q. Return to Main Menu
ECHO.
ECHO ----------------------------------------
ECHO ---- Remove Player
ECHO.
ECHO Which player would you like to remove?
SET DelPlayer=0
SET /P DelPlayer=
IF %DelPlayer% == q GOTO :Menu
IF %DelPlayer% == Q GOTO :Menu 
IF %DelPlayer% GTR %Players% (
	ECHO You didn't choose a valid option.
	TIMEOUT 3
	GOTO :MENU4
)
IF 0 GTR %DelPlayer% (
	ECHO You didn't choose a valid option.
	TIMEOUT 3
	GOTO :MENU4
)
SET DelPlayerName=!Player%DelPLayer%!
IF %DelPlayer% == %Players% GOTO :RemEndLoop
SET count=%DelPlayer%
:RemPlayerLoop
SET /A countnext=!count!+1
SET Player!count!=!player%countnext%!
SET Player!count!_MaxHealth=!player%countnext%_MaxHealth!
SET Player!count!_CurHealth=!player%countnext%_CurHealth!
SET /A count=%count%+1
IF NOT !count! == !Players! GOTO :RemPlayerLoop
:RemEndLoop
SET /A Players=%Players% - 1
>>%logfile% ECHO %me%: Player%DelPlayer% deleted: %DelPlayerName%
ECHO %DelPlayerName% has been deleted.
TIMEOUT 3
GOTO :Save

:: ===================================================================
:: List Players
:MENU5
CLS
ECHO ----------------------------------------
ECHO ---- Current Players
ECHO.
FOR /L %%G IN (1,1,%Players%) DO (
	SET "DName=!Player%%G!                "
	SET "DHealth=    !Player%%G_MaxHealth!"
	ECHO     %%G. !DName:~0,16! !DHealth:~-4! HP
)
ECHO.
ECHO ----------------------------------------
PAUSE
GOTO :Menu

:: ===================================================================
:: Encounter
:: ===================================================================
:EncMenuStart
IF EXIST %campfile% GOTO :LoadCamp
>%campfile% ECHO @ECHO OFF
>>%campfile% ECHO SET Encounters=0
>>%logfile% ECHO %me%: Default campaign file created: %campfile%
:LoadCamp
>>%logfile% ECHO %me%: Loading campaign: %campfile%
CALL %campfile%
>>%logfile% ECHO %me%: Campaign loaded: %campfile%
GOTO :EncMenu

:: ===================================================================
:: SaveEncounter
:SaveEncounter
>>%logfile% ECHO %me%: Saving campaign: %campfile%
>%campfile% ECHO @ECHO OFF
>>%campfile% ECHO SET Encounters=%Encounters%
FOR /L %%G IN (1,1,%Encounters%) DO (
	>>%campfile% ECHO SET Encounter%%G_Name=!Encounter%%G_Name!
	>>%campfile% ECHO SET Encounter%%G_Enemies=!Encounter%%G_Enemies!
	FOR /L %%H IN (1,1,!Encounter%%G_Enemies!) DO (
		>>%campfile% ECHO SET Encounter%%G_Enemy%%H=!Encounter%%G_Enemy%%H!
		>>%campfile% ECHO SET Encounter%%G_Enemy%%H_MaxHealth=!Encounter%%G_Enemy%%H_MaxHealth!
		>>%campfile% ECHO SET Encounter%%G_Enemy%%H_CurHealth=!Encounter%%G_Enemy%%H_CurHealth!
	)
)
>>%logfile% ECHO %me%: Campaign saved: %campfile%
GOTO :EncMenu

:: ===================================================================
:: Encounter Menu ====================================================
:: ===================================================================
:EncMenu
CLS
ECHO ----------------------------------------
ECHO ----------- Encounter Menu -------------
ECHO.
ECHO     Encounters: %Encounters%
ECHO       1. Edit Encounters
ECHO       2. Add Encounter
ECHO       3. Remove Encounter
ECHO.
ECHO     Loaded Campaign: %campfile%
ECHO       4. Load Campaign
ECHO       5. Export Campaign
ECHO.
ECHO     Navigation:
ECHO       E. Start Encounter
ECHO       M. Return to Main Menu
ECHO       Q. Quit
ECHO.
ECHO ----------------------------------------
SET MenuChoice=invalid
SET /P MenuChoice=
IF %MenuChoice% == 1 GOTO :EncMenu1
IF %MenuChoice% == 2 GOTO :EncMenu2
IF %MenuChoice% == 3 GOTO :EncMenu3
IF %MenuChoice% == 4 GOTO :EncMenu4
IF %MenuChoice% == 5 GOTO :EncMenu5
IF %MenuChoice% == e GOTO :StartEncounter
IF %MenuChoice% == E GOTO :StartEncounter
IF %MenuChoice% == m GOTO :Menu
If %MenuChoice% == M GOTO :Menu
IF %MenuChoice% == Q GOTO :QUIT
IF %MenuChoice% == q GOTO :QUIT
ECHO That wasn't a valid command, try again.
TIMEOUT 3
GOTO EncMenu

:: ===================================================================
:: Edit Encounters
:EncMenu1
IF %Encounters% == 0 (
	ECHO There are no encounters to edit.
	TIMEOUT 3
	GOTO :EncMenu
)
CLS
ECHO ----------------------------------------
ECHO ---- Edit Encounters
ECHO.
FOR /L %%G IN (1,1,%Encounters%) DO (
	ECHO      %%G. !Encounter%%G_Name!
)
ECHO.
ECHO ----------------------------------------
ECHO Select an encounter to edit:
SET EncSel=0
SET /P EncSel=
IF %EncSel% GTR %Encounters% (
	ECHO That's not a valid input
	TIMEOUT 3
	GOTO :EncMenu1
)
IF 0 == %EncSel% (
	ECHO That's not a valid input
	TIMEOUT 3
	GOTO :EncMenu1
)
:EncMenu1Edit
CLS
ECHO ----------------------------------------
ECHO ---- Edit Encounters
ECHO.
ECHO     Edit Encounter %EncSel%: !Encounter%EncSel%_Name!
ECHO       1. Add Enemy (!Encounter%EncSel%_Enemies!)
ECHO       2. Remove Enemy
ECHO       Q. Return to Encounter menu
ECHO.
ECHO ----------------------------------------
SET MenuChoice=0
SET /P MenuChoice=
IF %MenuChoice% == 1 GOTO :EncMenu1Add
IF %MenuChoice% == 2 GOTO :EncMenu1Remove
IF %MenuChoice% == Q GOTO :EncMenu
IF %MenuChoice% == q GOTO :EncMenu
ECHO That's not a valid input
GOTO :EncMenu1Edit

:: ===================================================================
:: Add Enemy
:EncMenu1Add
CLS
ECHO ----------------------------------------
ECHO ---- Current Enemies
ECHO.
IF 0 == !Encounter%EncSel%_Enemies! (
	ECHO This encounter has no enemies.
) ELSE (
	FOR /L %%G IN (1,1,!Encounter%EncSel%_Enemies!) DO (
		ECHO %%G. !Encounter%EncSel%_Enemy%%G! !Encounter%EncSel%_Enemy%%G_MaxHealth! HP
	)
)
ECHO.
ECHO ----------------------------------------
ECHO ---- Create Enemy
ECHO.
SET /A Encounter%EncSel%_Enemies+=1
ECHO Enemy Name:
SET TempName=Unnamed
SET /P TempName=
SET Encounter%EncSel%_Enemy!Encounter%EncSel%_Enemies!=%TempName%
ECHO.
ECHO Enemy Health:
SET TempHealth=0
SET /P TempHealth=
SET Encounter%EncSel%_Enemy!Encounter%EncSel%_Enemies!_MaxHealth=%TempHealth%
SET Encounter%EncSel%_Enemy!Encounter%EncSel%_Enemies!_CurHealth=%TempHealth%
>>%logfile% ECHO %me%: Enemy added: %TempName% with %TempHealth% HP was added to Encounter %EncSel%: !Encounter%EncSel%_Name!
ECHO.
ECHO %TempName% added to !Encounter%EncSel%_Name!
TIMEOUT 3
GOTO :SaveEncounter

:: ===================================================================
:: Remove Enemy
:EncMenu1Remove
IF 0 == !Encounter%EncSel%_Enemies! (
	ECHO There are no enemies to remove.
	TIMEOUT 3
	GOTO :EncMenu
)
CLS
ECHO ----------------------------------------
ECHO ---- Current Enemies
ECHO.
FOR /L %%G IN (1,1,!Encounter%EncSel%_Enemies!) DO (
	ECHO %%G. !Encounter%EncSel%_Enemy%%G! !Encounter%EncSel%_Enemy%%G_MaxHealth! HP
)
ECHO Q. Return to Encounter Menu
ECHO.
ECHO ----------------------------------------
ECHO ---- Remove Enemy
ECHO.
ECHO Which enemy would you like to remove?
SET DelEnemy=0
SET /P DelEnemy=
IF %DelEnemy% == q GOTO :EncMenu
IF %DelEnemy% == Q GOTO :EncMenu 
IF %DelEnemy% GTR !Encounter%EncSel%_Enemies! (
	ECHO You didn't choose a valid option.
	TIMEOUT 3
	GOTO :EncMenu1Remove
)
IF 0 GTR %DelEnemy% (
	ECHO You didn't choose a valid option.
	TIMEOUT 3
	GOTO :EncMenu1Remove
)
SET DelEnemyName=!Encounter%EncSel%_Enemy%DelEnemy%!
IF %DelEnemy% == !Encounter%EncSel%_Enemies! GOTO :RemEnemyEndLoop
SET count=%DelEnemy%
:RemEnemyLoop
SET /A countnext=!count!+1
SET Encounter%EncSel%_Enemy!count!=!Encounter%EncSel%_Enemy%countnext%!
SET Encounter%EncSel%_Enemy!count!_MaxHealth=!Encounter%EncSel%_Enemy%countnext%_MaxHealth!
SET Encounter%EncSel%_Enemy!count!_CurHealth=!Encounter%EncSel%_Enemy%countnext%_CurHealth!
SET /A count=%count%+1
IF NOT !count! == !Encounter%EncSel%_Enemies! GOTO :RemEnemyLoop
:RemEnemyEndLoop
SET /A Encounter%EncSel%_Enemies-=1
>>%logfile% ECHO %me%: Enemy %DelEnemy% deleted: %DelEnemyName%
ECHO %DelEnemyName% has been deleted.
TIMEOUT 3
GOTO :SaveEncounter

:: ===================================================================
:: Add Encounter
:EncMenu2
CLS
ECHO ----------------------------------------
ECHO ---- Add Encounter
ECHO.
SET /A Encounters=%Encounters%+1
SET Encounter%Encounters%_Enemies=0
ECHO Encounter Name:
SET Encounter%Encounters%_Name=Unnamed
SET /P Encounter%Encounters%_Name=
ECHO Added Encounter %Encounters% - !Encounter%Encounters%_Name!
TIMEOUT 3
GOTO :SaveEncounter

:: ===================================================================
:: Remove Encounter
:EncMenu3
IF 0 == %Encounters% (
	ECHO There are no encounters to remove.
	TIMEOUT 3
	GOTO :EncMenu
)
CLS
ECHO ----------------------------------------
ECHO ---- Current Encounters
ECHO.
FOR /L %%G IN (1,1,%Encounters%) DO (
	ECHO %%G. !Encounter%%G_Name! - !Encounter%%G_Enemies! Enemies
)
ECHO Q. Return to Encounter Menu
ECHO.
ECHO ----------------------------------------
ECHO ---- Remove Encounter
ECHO.
ECHO Which encounter would you like to remove?
SET DelEnc=0
SET /P DelEnc=
IF %DelEnc% == 0 (
	ECHO Please select an option.
	TIMEOUT 3
	GOTO :EncMenu3
)
IF %DelEnc% == q GOTO :EncMenu
IF %DelEnc% == Q GOTO :EncMenu 
IF %DelEnc% GTR %Encounters% (
	ECHO You didn't choose a valid option.
	TIMEOUT 3
	GOTO :EncMenu3
)
IF 0 GTR %DelEnc% (
	ECHO You didn't choose a valid option.
	TIMEOUT 3
	GOTO :EncMenu3
)
SET DelEncName=!Encounter%EncSel%_Name!
IF %DelEnc% == %Encounters% GOTO :RemEncEndLoop
SET count=%DelEnc%
:RemEncLoop
SET /A countnext=!count!+1
SET Encounter!count!_Name=!Encounter%countnext%_Name!
SET Encounter!count!_Enemies=!Encounter%countnext%_Enemies!
SET /A count=%count%+1
IF NOT !count! == %Encounters% GOTO :RemEncLoop
:RemEncEndLoop
SET /A Encounters-=1
>>%logfile% ECHO %me%: Encounter %DelEnc% deleted: %DelEncName%
ECHO Encounter %DelEnc%: %DelEncName% has been deleted.
TIMEOUT 3
GOTO :SaveEncounter

:: ===================================================================
:: Load Campaign
:EncMenu4
CLS
ECHO ----------------------------------------
ECHO ---- Load Campaign
ECHO.
ECHO Name of file:

SET Findcampfile="No Entry"
SET /P Findcampfile=
IF NOT EXIST %Findcampfile% (
	>>%logfile% ECHO %me%: Tried to load campaign %Findcampfile%, but it doesn't exist.
	ECHO Sorry, %Findinifile% doesn't exist.
	TIMEOUT 3
	GOTO :Menu
) ELSE (
	>>%logfile% ECHO %me%: Trying to load %Findcampfile% as an initilization file.
	SET campfile=%Findcampfile%
	GOTO :LoadCamp
)

:: ===================================================================
:: Export Campaign
:EncMenu5
CLS
ECHO ----------------------------------------
ECHO ---- Export Campaign
ECHO.
ECHO Export as:
SET ExportCamp=export
SET /P ExportCamp=
SET ExportCamp=%ExportCamp%.cmd
TYPE %campfile%>%ExportCamp%
>>%logfile% ECHO %me%: Campaign exported as %ExportCamp%
ECHO Campaign exported as %ExportCamp%
TIMEOUT 3
GOTO :EncMenu

:: ===================================================================
:: Start Encounter:: =================================================
:: ===================================================================
:StartEncounter
CLS
ECHO ----------------------------------------
ECHO ---- Current Encounters
ECHO.
FOR /L %%G IN (1,1,%Encounters%) DO (
	ECHO        %%G. !Encounter%%G_Name! - !Encounter%%G_Enemies! Enemies
)
ECHO.
ECHO     Combat Log: %combfile%
ECHO        L. Change Combat log file
ECHO        Q. Return to Encounter Menu
ECHO.

ECHO ----------------------------------------
ECHO ---- Encounter Launcher
ECHO Choose an encounter to launch:
SET MenuChoice=0
SET /P MenuChoice=
IF %MenuChoice% == l GOTO :ChangeCombLog
IF %MenuChoice% == L GOTO :ChangeCombLog
IF %MenuChoice% == q GOTO :EncMenu
IF %MenuChoice% == Q GOTO :EncMenu
IF %MenuChoice% GTR %Encounters% (
	ECHO That's not a valid input.
	TIMEOUT3
	GOTO :StartEncounter
)
IF %MenuChoice% LEQ 0 (
	ECHO That's not a valid input.
	TIMEOUT3
	GOTO :StartEncounter
)
SET EncNum=%MenuChoice%
GOTO :Encounter

:: ===================================================================
:: Change Campaign Log
:ChangeCombLog
CLS
ECHO ----------------------------------------
ECHO ---- Current Combat Log: %combfile%
ECHO.
ECHO Name of log file:
SET newcombfile=aeucomb.txt
SET /P newcombfile=
IF EXIST %newcombfile% (
	SET combfile=%newcombfile%
) ELSE (
	SET combfile=%newcombfile%.txt
)
>>%logfile% ECHO %me%: Combat log file changed to: %combfile%
ECHO Combat log file changed to: %combfile%
TIMEOUT 3
GOTO :StartEncounter

:: ===================================================================
:: Encounter
:Encounter
IF NOT EXIST %combfile% (
	>%combfile% ECHO Combat log created: %combfile%
	>>%logfile% ECHO Combat log created: %combfile%
)
>>%combfile% ECHO New encounter started: %date% at %time%
>>%logfile% ECHO New encounter started: %date% at %time%
>>%combfile% ECHO Running: Encounter %EncNum%: !Encounter%EncNum%_Name!

:: ===================================================================
:: Initiative
:Initiative
CLS
ECHO ----------------------------------------
ECHO ---- Initiative
ECHO.
>>%combfile% ECHO Starting initiative for %Players% Players and !Encounter%EncNum%_Enemies! Enemies
SET /A Entities=%Players%+!Encounter%EncNum%_Enemies!
FOR /L %%G IN (1,1,%Players%) DO (
	ECHO Initiative roll for Player %%G: !Player%%G!
	SET EID_%%G=0
	SET /P EID_%%G=
	SET Entity%%G_ID=%%G
	SET Entity%%G_Hostility=Friend
	>>%combfile% ECHO !Player%%G! rolled an initiative of !EID_%%G!
)
FOR /L %%G IN (1,1,!Encounter%EncNum%_Enemies!) DO (
	ECHO Initiative roll for enemy %%G: !Encounter%EncNum%_Enemy%%G!
	SET /A EnemyIndex=%Players%+%%G
	SET EID_!EnemyIndex!=0
	SET /P EID_!EnemyIndex!=
	SET Entity!EnemyIndex!_ID=!EnemyIndex!
	SET Entity!EnemyIndex!_Hostility=Foe
	>>%combfile% ECHO !Encounter%EncNum%_Enemy%%G! rolled an initiative of !EID_%%G!
)
:InitiativeSort
SET Swaps=0
SET EID_tmp=0
SET count=2
:SortPass
	SET /A countprev=count-1
	IF !EID_%count%! GTR !EID_%countprev%! (
		SET EID_tmp=!EID_%count%!
		SET EID_%count%=!EID_%countprev%!
		SET EID_%countprev%=!EID_tmp!
		SET Entity_tmp=!Entity%count%_ID!
		SET Entity%count%_ID=!Entity%countprev%_ID!
		SET Entity%countprev%_ID=!Entity_tmp!
		SET Entity_Hostility_tmp=!Entity%count%_Hostility!
		SET Entity%count%_Hostility=!Entity%countprev%_Hostility!
		SET Entity%countprev%_Hostility=!Entity_Hostility_tmp!
		SET /A Swaps+=1
	)
	IF NOT %count% == %Entities% (
		SET /A count+=1
		GOTO :SortPass
	)
	IF NOT %Swaps% == 0 GOTO :InitiativeSort
SET count=1
:Construct
SET PEID=!Entity%count%_ID!
SET /A REID=!Entity%count%_ID!-%Players%
IF !Entity%count%_Hostility! == Friend (
	SET Entity%count%=!Player%PEID%!
	SET Entity%count%_Health=!Player%PEID%_CurHealth!
    SET Entity%count%_Rounds=!Player%PEID%_Rounds!
    SET Entity%count%_Damage=!Player%PEID%_Damage!
    SET Entity%count%_Healing=!Player%PEID%_Healing!
) ELSE IF !Entity%count%_Hostility! == Foe (
	SET Entity%count%=!Encounter%EncNum%_Enemy%REID%!
	SET Entity%count%_Health=!Encounter%EncNum%_Enemy%REID%_CurHealth!
    SET Entity%count%_Rounds=1
    SET Entity%count%_Damage=0
    SET Entity%count%_Healing=0
) ELSE (
	>>%logfile% ECHO %me%: FATAL: Entity%count% has no hostility setting.
	EXIT /B 1
)
IF NOT %count% == %Entities% (
	SET /A count+=1
	GOTO :Construct
)
:: Entity# = Name, # is ini slot
:: Entity#_Health = Current Health
:: Entity#_IniRoll = Initiative roll EID_# --
:: Entity#_Hostility = Friend or Foe --
:: Entity#_ID = Player/Enemy ID --
:IniOrder
CLS
ECHO ----------------------------------------
ECHO ---- Sorted Order
ECHO.
FOR /L %%G IN (1,1,%Entities%) DO (
	ECHO     %%G. !EID_%%G! ID: !Entity%%G_ID! Hostility: !Entity%%G_Hostility! Name:!Entity%%G! Health: !Entity%%G_Health!
)
ECHO.
ECHO ----------------------------------------
ECHO     1-%Entities%. Swap Enemies
ECHO     A. Approve initiative order
SET MenuChoice=a
SET /P MenuChoice=
IF %MenuChoice% == a GOTO :CombatPrep
IF %MenuChoice% == A GOTO :CombatPrep
IF %MenuChoice% GTR %Entities% (
	ECHO Not a valid input.
	TIMEOUT 3
	GOTO :IniOrder
)
IF %MenuChoice% LSS 0 (
	ECHO Not a valid input.
	TIMEOUT 3
	GOTO :IniOrder
)
:SwapEntities
SET count=%MenuChoice%
ECHO Who would you like to swap !Entity%count%! with?
SET /P countprev=
IF %countprev% GTR %Entities% (
	ECHO Not a valid input.
	TIMEOUT 3
	GOTO :SwapEntities
)
IF %countprev% LSS 0 (
	ECHO Not a valid input.
	TIMEOUT 3
	GOTO :SwapEntities
)

		SET EID_tmp=!EID_%count%!
		SET EID_%count%=!EID_%countprev%!
		SET EID_%countprev%=!EID_tmp!
		SET Entity_tmp=!Entity%count%_ID!
		SET Entity%count%_ID=!Entity%countprev%_ID!
		SET Entity%countprev%_ID=!Entity_tmp!
		SET Entity_Hostility_tmp=!Entity%count%_Hostility!
		SET Entity%count%_Hostility=!Entity%countprev%_Hostility!
		SET Entity%countprev%_Hostility=!Entity_Hostility_tmp!

		SET count=1
GOTO :Construct



:CombatPrep
FOR /L %%G IN (1,1,%Entities%) DO (
	>>%combfile% ECHO     %%G. !Entity%%G! !EID_%%G!
)
>>%combfile% ECHO Initiative order approved.
SET round=1
SET turn=1

:Combat
SET /A EntityDPR=!Entity%turn%_Damage! / !Entity%turn%_Rounds!
SET /A EntityHPR=!Entity%turn%_Healing! / !Entity%turn%_Rounds!


SET "DPlayer=!Entity%turn%! ---------------------"
SET "DHealth=-- !Entity%turn%_Health!"
SET "Dround= %round%"
CLS
ECHO -------------- Round !Dround:~-2! ----------------
ECHO ----------------------------------------
ECHO ---- !DPlayer:~,22!---!DHealth:~-3!HP ---- 
ECHO ----------------------------------------
ECHO.
ECHO     1. Attack
ECHO     2. Heal
ECHO     3. End Turn
ECHO.
ECHO ----------------------------------------
ECHO Rounds: !Entity%turn%_Rounds!
ECHO Damage: !Entity%turn%_Damage!
ECHO Healing: !Entity%turn%_Healing!
ECHO DPR: %EntityDPR%
ECHO HPR: %EntityHPR%
SET MenuChoice=0
SET /P MenuChoice=
IF "%MenuChoice%" == "0" (
	ECHO Thats not a valid option.
	TIMEOUT 3
	GOTO :Combat
)
IF %MenuChoice% == 1 GOTO :Attack
IF %MenuChoice% == 2 GOTO :Heal
IF %MenuChoice% == 3 GOTO :EndTurn
ECHO That's not a valid input.
TIMEOUT 3
GOTO :Combat


:Attack
CLS
ECHO -------------- Round !Dround:~-2! ----------------
ECHO ----------------------------------------
ECHO ---- !DPlayer:~,22!---!DHealth:~-3!HP ---- 
ECHO ----------------------------------------
ECHO ---- Choose a player to attack
ECHO.

FOR /L %%G IN (1,1,%Entities%) DO (
	IF NOT !Entity%turn%_Hostility! == !Entity%%G_Hostility! (
		ECHO     %%G. !EID_%%G! ID: !Entity%%G_ID! Hostility: !Entity%%G_Hostility! Name:!Entity%%G! Health: !Entity%%G_Health!
	)
)
ECHO.
ECHO ----------------------------------------
SET AttackPlayer=0
SET /P AttackPlayer=
IF %AttackPlayer% LEQ 0 (
	ECHO That's not a valid player.
	TIMEOUT 3
	GOTO :Combat
) ELSE IF %AttackPlayer% GTR %Entities% (
	ECHO That's not a valid player.
	TIMEOUT 3
	GOTO :Combat
)
IF !Entity%AttackPlayer%_Hostility! == !Entity%turn%_Hostility! (
	ECHO Are you sure you want to attack an ally?
)


ECHO ---- How much damage was dealt?
SET DDealt=0
SET /P DDealt=

SET /A Entity%AttackPlayer%_Health-=%DDealt%
ECHO.
ECHO ----------------------------------------
ECHO %DDealt% damage was dealt to !Entity%AttackPlayer%!. They now have !Entity%AttackPlayer%_Health!
SET /A Entity%turn%_Damage+=%DDealt%
PAUSE

GOTO :Combat


:Heal
CLS
ECHO -------------- Round !Dround:~-2! ----------------
ECHO ----------------------------------------
ECHO ---- !DPlayer:~,22!---!DHealth:~-3!HP ---- 
ECHO ----------------------------------------
ECHO ---- Choose a player to heal
ECHO.

FOR /L %%G IN (1,1,%Entities%) DO (
	ECHO     %%G. !EID_%%G! ID: !Entity%%G_ID! Hostility: !Entity%%G_Hostility! Name:!Entity%%G! Health: !Entity%%G_Health!
)
ECHO.
ECHO ----------------------------------------
SET HealPlayer=0
SET /P HealPlayer=
IF %HealPlayer% LEQ 0 (
	ECHO That's not a valid player.
	TIMEOUT 3
	GOTO :Combat
) ELSE IF %HealPlayer% GTR %Entities% (
	ECHO That's not a valid player.
	TIMEOUT 3
	GOTO :Combat
)
IF NOT !Entity%HealPlayer%_Hostility! == !Entity%turn%_Hostility! (
	ECHO Are you sure you want to heal an enemy?
)


ECHO ---- How much healing was done?
SET HDone=0
SET /P HDone=

SET /A Entity%HealPlayer%_Health+=%HDone%
ECHO.
ECHO ----------------------------------------
ECHO %HDone% healing was dealt to !Entity%HealPlayer%!. They now have !Entity%HealPlayer%_Health!
SET /A Entity%turn%_Healing+=%HDone%
PAUSE

GOTO :Combat



:EndTurn

SET AlivePlayers=0
SET AliveEnemies=0

SET /A Entity%turn%_Rounds+=1

FOR /L %%G IN (1,1,!Entities!) DO (

	IF !Entity%%G_Health! GTR 0 (
		IF !Entity%%G_Hostility! == Friend (
			SET /A AlivePlayers+=1
		) ELSE IF !Entity%%G_Hostility! == Foe (
			SET /A AliveEnemies+=1
		)
	)
)

IF %AlivePlayers% == 0 (
	ECHO Enemies win!
	GOTO :EndCombat
) ELSE IF %AliveEnemies% == 0 (
	ECHO Players win!
	GOTO :EndCombat
)



IF %turn% == %Entities% (
	SET turn=1
	SET /A round+=1
) ELSE (
	SET /A turn+=1
)
GOTO :Combat


:CombatMenu
CLS
ECHO ----------------------------------------
ECHO ------------ Combat Menu ---------------
ECHO.



::FOR /L %%G IN (1,1,%Players%) DO (
::	SET "DName=!Player%%G!                "
::	SET "DHealth=    !Player%%G_MaxHealth!"
::	ECHO     %%G. !DName:~0,16! !DHealth:~-4! HP
::)


:EndCombat



ECHO Combat is over!
FOR /L %%G IN (1,1,!Entities!) DO (
    SET /A EDPR=!Entity%%G_Damage!/!Entity%%G_Rounds!
    SET /A EHPR=!Entity%%G_Healing!/!Entity%%G_Rounds!
    ECHO !Entity%%G!: !Entity%%G_Damage!Dmg, !Entity%%G_Healing!Hls, !EDPR!DPR, !EHPR!HPR
)



PAUSE











:QUIT
>>%logfile% ECHO %me%: Closing due to user request.
EXIT /B 0




:: TO DO
:: Do Files really need creating?
:: Make temp saves before clobbering files
:: reorganize menues
:: Make Save a function called so it can be done anytime
:: List only enemies in attack, and friends in heal