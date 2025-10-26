# Localization

Dagon provides a simple mechanism to localize applications: instead of printing strings directly, get a translation to the current language using `Application.translation.get` function:

```d
string textForOutput = app.translation.get("HelloWorld");
```

Translations - *.lang files - are loaded from `locale` folder. Dagon first loads `locale/en_US.lang` and then non-english translation, if specified.

Example `locale/en_US.lang`:
```
HelloWorld: "Hello, World!";
```

Example `locale/ru_RU.lang`:
```
HelloWorld: "Привет, мир!";
```

By default, locale is queried from the operating system. User can also specify custom locale in `settings.conf`:

```
locale: "fr_FR";
```

If translation is not found, `translation.get` returns the input identifier itself.
