@cd ./bin/
dmd  ..\src\main.d ..\src\csvparse.d ..\src\indi.d ..\src\exprtree.d
main.exe
@cd ..