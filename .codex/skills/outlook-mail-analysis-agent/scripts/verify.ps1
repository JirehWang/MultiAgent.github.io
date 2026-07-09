$ErrorActionPreference = "Stop"
Set-Location -LiteralPath $PSScriptRoot\..

python -m py_compile .\scripts\query-mail-report.py .\scripts\report-mail-kpis.py
python "C:\Users\105221\.codex\skills\.system\skill-creator\scripts\quick_validate.py" .
python .\scripts\query-mail-report.py --help | Out-Null
python .\scripts\report-mail-kpis.py --help | Out-Null
