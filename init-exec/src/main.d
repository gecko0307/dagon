module main;

import std.path: buildPath;
import std.file: getcwd, mkdir, write;

string appD = import("app.d");
string sceneD = import("scene.d");
string settingsConf = import("settings.conf");
string inputConf = import("input.conf");
string enUSLang = import("en_US.lang");

void main(string[] args)
{
    string cwd = getcwd();
    
    string sourceFolder = buildPath(cwd, "source");
    mkdir(sourceFolder);
    
    string appDPath = buildPath(sourceFolder, "app.d");
    write(appDPath, appD);
    
    string sceneDPath = buildPath(sourceFolder, "scene.d");
    write(sceneDPath, sceneD);
    
    string settingsConfPath = buildPath(cwd, "settings.conf");
    write(settingsConfPath, settingsConf);
    
    string inputConfPath = buildPath(cwd, "input.conf");
    write(inputConfPath, inputConf);
    
    string localeFolder = buildPath(cwd, "locale");
    mkdir(localeFolder);
    
    string enUSLangPath = buildPath(localeFolder, "en_US.lang");
    write(enUSLangPath, enUSLang);
}
