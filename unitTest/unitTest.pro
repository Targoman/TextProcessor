################################################################################
#   QBuildSystem
#
#   Copyright(c) 2021 by Targoman Intelligent Processing <http://tip.co.ir>
#
#   Redistribution and use in source and binary forms are allowed under the
#   terms of BSD License 2.0.
################################################################################
# +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-#
HEADERS = UnitTest.h
# +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-#
SOURCES = \
    testNormalizer.cpp \
    testText2IXML.cpp \
    testIXML2Text.cpp \
    testText2RichIXML.cpp \
    testRichIXML2Text.cpp \
    UnitTest.cpp

################################################################################
include(../qmake/unitTestConfigs.pri)
