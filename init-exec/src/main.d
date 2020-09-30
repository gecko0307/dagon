module main;

import std.path: buildPath;
import std.file: getcwd, mkdir, write;

string appD = import("app.d");
string sceneD = import("scene.d");

void main(string[] args)
{
	string sourceFolder = buildPath(getcwd(), "source");
	mkdir(sourceFolder);
	
	string appDPath = buildPath(sourceFolder, "app.d");
	write(appDPath, appD);
    
    string sceneDPath = buildPath(sourceFolder, "scene.d");
    write(sceneDPath, sceneD);
}
