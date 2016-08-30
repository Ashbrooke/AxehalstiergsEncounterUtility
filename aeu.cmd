:: ===================================================================
:: Startup ===========================================================
:: ===================================================================
@ECHO OFF
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
SET me=%~n0
SET parent=%~dp0
SET Version=1.1b
SET IniValidation=FALSE
SET Players=0
:: Default File Save Names
SET logfile=aeulog.log
SET inifile=aeuini.sav

SET CurMenu=MainMenu
MODE CON:COLS=82 LINES=24


CALL :SplashScreen

:Main
CALL :%CurMenu%
SET UserInput=NoInput
SET /P UserInput=

GOTO :Settings

:Exit
EXIT /B 0

:: ===================================================================
:: Modules   =========================================================
:: ===================================================================

:LaunchEncounter

:LoadExport

:Editor

:Settings
CALL :Module Settings
PAUSE
GOTO :Main


:Quit
GOTO :Exit

:MainMenu



:: ===================================================================
:: Main Menu =========================================================
:: ===================================================================
:MainMenu
CLS
ECHO --------------------------------------------------------------------------------
ECHO ------------------------------ Main Menu ---------------------------------------
ECHO.
ECHO                        1. Launch Encounter
ECHO                        2. Load/Export
ECHO                        3. Editor
ECHO                        4. Settings
ECHO                        Q. Quit
ECHO.
ECHO --------------------------------------------------------------------------------
ECHO ---- STATUS/LOADED FILES HERE
ECHO --------------------------------------------------------------------------------
>NUL TIMEOUT /T 0
EXIT /B 0
:Editor
CLS
ECHO --------------------------------------------------------------------------------
ECHO ------------------------------ Editor ------------------------------------------
ECHO.
ECHO                        1. Launch Encounter
ECHO                        2. Main Menu
ECHO                        3. Load/Export
ECHO                        Q. Quit
ECHO.
ECHO --------------------------------------------------------------------------------
ECHO ---- STATUS/LOADED FILES HERE
ECHO --------------------------------------------------------------------------------
>NUL TIMEOUT /T 0
EXIT /B 0

:: ===================================================================
:: Module Screen =====================================================
:: ===================================================================
:Module
CLS
ECHO --------------------------------------------------------------------------------
ECHO ----  %1
ECHO.
EXIT /B 0

:: ===================================================================
:: Splash Screen =====================================================
:: ===================================================================
:SplashScreen
SET frame=1
:Frame
IF %frame% == 1 (
	SET a=.
	SET e=.
	SET u=.
	SET ab=Axehalstierg's
	SET eb=Encounter
	SET ub=Utility
) ELSE IF %frame% == 2 (
	SET a=+
) ELSE IF %frame% == 3 (
	SET a=#
	SET ab=Axehalstierg's
	SET e=+
) ELSE IF %frame% == 4 (
	SET e=#
	SET eb=Encounter
	SET u=+
) ELSE IF %frame% == 5 (
	SET u=#
	SET ub=Utility
)


CLS
ECHO.
ECHO    %a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%      %e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%  %u%%u%%u%%u%%u%%u%%u%           %u%%u%%u%%u%%u%%u%%u%
ECHO  %a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%  %e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%  %u%%u%%u%%u%%u%%u%%u%%u%         %u%%u%%u%%u%%u%%u%%u%%u%
ECHO  %a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%  %e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%  %u%%u%%u%%u%%u%%u%%u%%u%         %u%%u%%u%%u%%u%%u%%u%%u%
ECHO  %a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%  %e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%    %u%%u%%u%%u%%u%%u%%u%%u%         %u%%u%%u%%u%%u%%u%%u%%u%
ECHO  %a%%a%%a%%a%%a%%a%%a%%a%         %a%%a%%a%%a%%a%%a%%a%%a%  %e%%e%%e%%e%%e%%e%%e%%e%                    %u%%u%%u%%u%%u%%u%%u%%u%         %u%%u%%u%%u%%u%%u%%u%%u%
ECHO  %a%%a%%a%%a%%a%%a%%a%%a%         %a%%a%%a%%a%%a%%a%%a%%a%  %e%%e%%e%%e%%e%%e%%e%%e%                    %u%%u%%u%%u%%u%%u%%u%%u%         %u%%u%%u%%u%%u%%u%%u%%u%
ECHO  %a%%a%%a%%a%%a%%a%%a%%a%         %a%%a%%a%%a%%a%%a%%a%%a%  %e%%e%%e%%e%%e%%e%%e%%e%                    %u%%u%%u%%u%%u%%u%%u%%u%         %u%%u%%u%%u%%u%%u%%u%%u%
ECHO  %a%%a%%a%%a%%a%%a%%a%%a%         %a%%a%%a%%a%%a%%a%%a%%a%  %e%%e%%e%%e%%e%%e%%e%%e%                    %u%%u%%u%%u%%u%%u%%u%%u%         %u%%u%%u%%u%%u%%u%%u%%u%
ECHO  %a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%  %e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%    %u%%u%%u%%u%%u%%u%%u%%u%         %u%%u%%u%%u%%u%%u%%u%%u%
ECHO  %a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%  %e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%    %u%%u%%u%%u%%u%%u%%u%%u%         %u%%u%%u%%u%%u%%u%%u%%u%
ECHO  %a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%  %e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%      %u%%u%%u%%u%%u%%u%%u%%u%         %u%%u%%u%%u%%u%%u%%u%%u%
ECHO  %a%%a%%a%%a%%a%%a%%a%%a%         %a%%a%%a%%a%%a%%a%%a%%a%  %e%%e%%e%%e%%e%%e%%e%%e%                    %u%%u%%u%%u%%u%%u%%u%%u%         %u%%u%%u%%u%%u%%u%%u%%u%
ECHO  %a%%a%%a%%a%%a%%a%%a%%a%         %a%%a%%a%%a%%a%%a%%a%%a%  %e%%e%%e%%e%%e%%e%%e%%e%                    %u%%u%%u%%u%%u%%u%%u%%u%         %u%%u%%u%%u%%u%%u%%u%%u%
ECHO  %a%%a%%a%%a%%a%%a%%a%%a%         %a%%a%%a%%a%%a%%a%%a%%a%  %e%%e%%e%%e%%e%%e%%e%%e%                    %u%%u%%u%%u%%u%%u%%u%%u%         %u%%u%%u%%u%%u%%u%%u%%u%
ECHO  %a%%a%%a%%a%%a%%a%%a%%a%         %a%%a%%a%%a%%a%%a%%a%%a%  %e%%e%%e%%e%%e%%e%%e%%e%                    %u%%u%%u%%u%%u%%u%%u%%u%         %u%%u%%u%%u%%u%%u%%u%%u%
ECHO  %a%%a%%a%%a%%a%%a%%a%%a%         %a%%a%%a%%a%%a%%a%%a%%a%  %e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%      %u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%
ECHO  %a%%a%%a%%a%%a%%a%%a%%a%         %a%%a%%a%%a%%a%%a%%a%%a%  %e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%    %u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%
ECHO  %a%%a%%a%%a%%a%%a%%a%%a%         %a%%a%%a%%a%%a%%a%%a%%a%  %e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%      %u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%  
ECHO  %a%%a%%a%%a%%a%%a%%a%%a%         %a%%a%%a%%a%%a%%a%%a%%a%  %e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%%e%        %u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%%u%    
ECHO.
ECHO        %ab%              %eb%                    %ub%          
>NUL TIMEOUT /T 1

IF %frame% GEQ 7 (
	EXIT /B 0
)
SET /A frame+=1
GOTO :Frame



