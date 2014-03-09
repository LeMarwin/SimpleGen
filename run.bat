@cd ./bin/
dmd  ..\src\main.d ..\src\csvparse.d ..\src\indi.d ..\src\exprtree.d ..\src\population.d
main.exe
@cd ..