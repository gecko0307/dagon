@echo off
setlocal

pandoc index.md -f markdown -t html5 -s --template=template.html5 --toc --toc-depth=2 --metadata title="Dagon Editor" -o index.html
if errorlevel 1 exit /b %errorlevel%

pandoc viewport.md -f markdown -t html5 -s --template=template.html5 --toc --toc-depth=2 --metadata title="Viewport" --metadata show-breadcrumb=true -o viewport.html
if errorlevel 1 exit /b %errorlevel%

echo Documentation pages generated.
