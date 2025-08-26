@echo off
echo =======================================================
echo  Step 1: Finding the latest source data...
echo =======================================================
python set_latest_source.py

echo.
echo =======================================================
echo  Step 2: Preparing dbt environment...
echo =======================================================
for /f "tokens=*" %%a in (latest_source_path.env) do set "%%a"

echo.
echo =======================================================
echo  Step 3: Running the dbt project...
echo =======================================================
cd datamarts_dbt
dbt run
cd ..

echo.
echo =======================================================
echo  Pipeline run complete.
echo =======================================================
pause