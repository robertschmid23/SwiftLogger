# SwiftLogger - **Gh**ost **i**n **m**y **Mac**

SwiftLogger is loosely based on the original Log4J and it's successor Logback.  Despite Log4J presenting an excellent logging framework before Java had it's own, the makers of Java felt, for some reason, that a lobotimized logging framework was what they wanted instead.  Naturally Android and Swift have followed suit with much less powerful logging frameworks which encourage developers to simply avoid logging as much as possible.

In contrast Log4J and SwiftLogger are configurable and can be set to log as much or as little as needed before or, perhaps, during logging.  It can also be wholly deactivated to maximize performance on release.  

Beside configurability, Log4J allows the implementation of custom Loggers for special purposes like logging to a database or to different files.  SwiftLogger doesn't support those ideas yet but could in the future.

To configure SwiftLogger in an app, place a SwiftLogger.config file in the Resources or DeveloperAssets directories.  The format is JSON and looks like;

```json
{
	"threshold": ["WARN", "TIME"],
	"subsystem": "XLogger Subsystem",
	"category": "XLogger Category"
}
```

The values for threshold are one of 

DEBUG, INFO, WARN, ERROR

and one or more of 

SESSION, TIME, DATA_DUMPS

DEBUG, INFO, WARN & ERROR each limit the logging of lower levels so WARN will log WARN & ERROR but not DEBUG or INFO.
SESSION, TIME & DATA_DUMPS serve special functions
OFF overrides all logging and prevents any logging from occurring

To use the default logger simple use the singleton - 

```
Log.debug("This is a debug statement")
```

The output is not simply the message but also shows the file and line where the log statement was made

```
2022-10-07 14:38:16.732975-0500 xctest[13136:190224] [category] Debug Statement (SwiftLoggerTests.swift:9)
```



Admittedly, I hate writing documentation.  More later.
