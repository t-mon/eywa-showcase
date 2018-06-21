QT += charts qml quick quickcontrols2
CONFIG += c++11

HEADERS += \
    engine.h \
    datamanager.h \
    houshold.h \
    dataseries.h \
    logmessage.h \
    dataiteration.h \
    dataiterations.h \
    logentry.h

SOURCES += \
    main.cpp \
    engine.cpp \
    datamanager.cpp \
    houshold.cpp \
    dataseries.cpp \
    logmessage.cpp \
    dataiteration.cpp \
    dataiterations.cpp \
    logentry.cpp

RESOURCES += qml.qrc icons.qrc data.qrc

OTHER_FILES += data/*

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target


