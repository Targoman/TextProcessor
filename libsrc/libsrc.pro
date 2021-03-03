################################################################################
#   QBuildSystem
#
#   Copyright(c) 2021 by Targoman Intelligent Processing <http://tip.co.ir>
#
#   Redistribution and use in source and binary forms are allowed under the
#   terms of BSD License 2.0.
################################################################################
DIST_HEADERS += \
    libTargomanTextProcessor/TextProcessor.h \
    libTargomanTextProcessor/TextProcessor_c.h \

# +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-#
PRIVATE_HEADERS += \
    libTargomanTextProcessor/Private/Normalizer.h \
    libTargomanTextProcessor/Private/Unicode.hpp \
    libTargomanTextProcessor/Private/IXMLWriter.h \
    libTargomanTextProcessor/Private/SpellCorrector.h \
    libTargomanTextProcessor/Private/Configs.h \
    libTargomanTextProcessor/Private/SpellCorrectors/PersianSpellCorrector.h

# +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-#
SOURCES += libID.cpp \
    libTargomanTextProcessor/Private/Normalizer.cpp \
    libTargomanTextProcessor/TextProcessor.cpp \
    libTargomanTextProcessor/TextProcessor_c.cpp \
    libTargomanTextProcessor/Private/IXMLWriter.cpp \
    libTargomanTextProcessor/Private/SpellCorrector.cpp \
    libTargomanTextProcessor/Private/Configs.cpp \
    libTargomanTextProcessor/Private/SpellCorrectors/PersianSpellCorrector.cpp

OTHER_FILES += \
    conf/Abbreviations.tbl \
    conf/Normalization.conf \
    conf/PersianVerbStepPresent.tbl \
    conf/PersianVerbStemPast.tbl \
    conf/PersianStartWithNa.tbl \
    conf/PersianStartWithBi_Ba.tbl \
    conf/PersianSpace2ZWNJ.tbl \
    conf/PersianNouns.tbl \
    conf/PersianAutoCorrectTerms.tbl \
    conf/PersianHamzeOrMadAllowed.tbl \
    conf/SpellCorrectors/Persian/VerbStemPast.tbl \
    conf/SpellCorrectors/Persian/StartWithNa.tbl \
    conf/SpellCorrectors/Persian/StartWithBi_Ba.tbl \
    conf/SpellCorrectors/Persian/Space2ZWNJ.tbl \
    conf/SpellCorrectors/Persian/Nouns.tbl \
    conf/SpellCorrectors/Persian/HamzeOrMadAllowed.tbl \
    conf/SpellCorrectors/Persian/AutoCorrectTerms.tbl \
    conf/SpellCorrectors/Persian/Adjectives.tbl \
    conf/SpellCorrectors/Persian/VerbStemPast.tbl \
    conf/SpellCorrectors/Persian/StartWithNa.tbl \
    conf/SpellCorrectors/Persian/StartWithBi_Ba.tbl \
    conf/SpellCorrectors/Persian/Space2ZWNJ.tbl \
    conf/SpellCorrectors/Persian/Nouns.tbl \
    conf/SpellCorrectors/Persian/HamzeOrMadAllowed.tbl \
    conf/SpellCorrectors/Persian/AutoCorrectTerms.tbl \
    conf/SpellCorrectors/Persian/Adjectives.tbl \
    conf/SpellCorrectors/Persian/VerbStemPresent.tbl \
    conf/SpellCorrectors/Persian/StartWith_Na.tbl \
    conf/SpellCorrectors/Persian/StartWith_Bi_Ba.tbl \
    conf/SpellCorrectors/Persian/NeedHeYe.txt

################################################################################
include($$QBUILD_PATH/templates/libConfigs.pri)
