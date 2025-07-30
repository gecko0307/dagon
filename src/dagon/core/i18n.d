module dagon.core.i18n;

import dlib.core.memory;
import dlib.core.ownership;
import dlib.text.str;

import dagon.core.application;
import dagon.core.config;
import dagon.core.logger;

class Translation: Owner
{
    Configuration dictionary;
    
    this(Application app, Owner owner)
    {
        super(owner);
        dictionary = New!Configuration(app.vfs, this);
    }
    
    void load(string locale)
    {
        string dirSeparator = "/";
        version(Windows)
            dirSeparator = "\\";
        String localeFilename = "locale";
        localeFilename ~= dirSeparator;
        localeFilename ~= locale;
        localeFilename ~= ".lang";
        
        if (!dictionary.fromFile(localeFilename))
        {
            logWarning("i18n: no \"", localeFilename, "\" found");
        }
        else
        {
            logInfo("i18n: loaded ", localeFilename);
        }
        
        localeFilename.free();
    }
    
    string get(string s)
    {
        auto tr = s in dictionary.props;
        if (tr)
            return tr.toString;
        else
            return s;
    }
    
    alias opCall = get;
}
