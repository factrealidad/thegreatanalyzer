@echo off
rem Starts The Great Analyzer with a console window, so any error messages stay visible.
cd /d "%~dp0"
"%~dp0runtime\bin\java.exe" -Xmx3g -Dfile.encoding=UTF-8 --enable-native-access=javafx.graphics --sun-misc-unsafe-memory-access=allow --module-path "%~dp0app" -m vic2sgea/org.victoria2.tools.vic2sgea.gui.Main
pause
