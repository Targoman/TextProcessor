# TextProcessor

A C++/Qt library for text normalization, Persian spelling and spacing correction, entity tagging, and tokenization/detokenization, developed for machine translation and other NLP tasks.

TextProcessor provides the processing library used by [E4MT](https://github.com/Targoman/E4MT). Use this repository to integrate processing into a C++ application; use E4MT for its command-line application and server modes. A Python wrapper for E4MT is available in [E4MTPy](https://github.com/Targoman/E4MTPy).

## Table of contents

- [Motivation](#motivation)
- [Features](#features)
- [Setup](#setup)
- [Sample codes](#sample-codes)
- [Configuration and language data](#configuration-and-language-data)
- [Troubleshooting](#troubleshooting)
- [License](#license)

## Motivation

Persian text can represent the same word in several ways. Arabic and Persian character variants, Unicode presentation forms, and inconsistent use of spaces and the zero-width non-joiner (ZWNJ, `U+200C`) all contribute to this variation. For example, authors may separate a verb prefix or suffix with a space, use a ZWNJ, or join it directly to the stem.

These differences complicate matching and tokenization and can increase the number of distinct written forms in a corpus. TextProcessor combines character normalization with Persian lexical tables and inflection rules to make text preparation more consistent. Its entity tagging also helps preserve structures such as URLs, email addresses, and numbers while processing punctuation and sentence boundaries.

The motivation and processing methods are also described in the [E4MT README](https://github.com/Targoman/E4MT#readme) and the [paper referenced by E4MT](https://ieeexplore.ieee.org/document/9960087).

## Features

- **Character normalization:** maps supported character variants and presentation forms according to the normalizer and its configurable rules; also normalizes whitespace.
- **Persian spelling and spacing correction:** uses dictionaries, verb stems, and inflection rules to correct known spelling variants and handle compound words, prefixes, suffixes, and ZWNJ placement. Coverage depends on the supplied rules and lexical tables.
- **Entity tagging:** produces the library's IXML representation, with tags for structures such as numbers, URLs, email addresses, abbreviations, dates, times, and list markers. This is pattern-based tagging of a limited set of entities.
- **Tokenization and detokenization:** converts between IXML and text, with controls for token spacing, digit and punctuation forms, and sentence breaks. Detokenization does not restore every detail of the original input after normalization.
- **Native integration:** exposes a Qt/C++ API and exported C-linkage functions for use by language bindings.

Tokenization here prepares text and punctuation for NLP workflows. A language model still needs its own tokenizer to produce model-specific token IDs.

## Setup

### 1. Clone the repository and its dependencies

```bash
git clone --recurse-submodules https://github.com/Targoman/TextProcessor.git
cd TextProcessor
```

For an existing checkout, run these commands from its root:

```bash
git submodule sync --recursive
git submodule update --init --recursive
git submodule status --recursive
```

The direct dependencies are [ISO639](https://github.com/Targoman/ISO639), [TargomanCommon](https://github.com/Targoman/TargomanCommon), and [QBuildSystem](https://github.com/Targoman/QBuildSystem). Recursive initialization also retrieves their nested dependencies. Downloading a source ZIP does not populate submodules.

If initialization reports `not our ref`, resolve the [unavailable submodule commit](#unavailable-submodule-commit) before building.

### 2. Install build dependencies

The Linux build uses a C++ compiler, GNU Make, CMake for applicable dependencies, Bash, Python, and **Qt 5** development tools. Install Qt Core, Network, and Test development files, along with zlib. The package examples also include libxml2, following E4MT's setup.

For Ubuntu/Debian:

```bash
sudo apt update
sudo apt install -y build-essential git cmake python3 python-is-python3 \
    qt5-qmake qtbase5-dev zlib1g-dev libxml2-dev
```

For openSUSE Leap 15.x:

```bash
sudo zypper install -y gcc-c++ make git cmake which python3 \
    libqt5-qtbase-devel libQt5Core-devel libQt5Network-devel \
    libQt5Test-devel zlib-devel libxml2-devel
```

Check the selected tools:

```bash
qmake -v
python --version
```

`qmake` must report Qt 5. If your distribution calls it `qmake-qt5`, use that command in the build steps below and keep it on `PATH` for dependency builds. Some QBuildSystem revisions invoke both `python3` and `python`; make sure `python` also resolves to Python 3.

### 3. Build

Run qmake from the repository root. QBuildSystem places compiled objects and outputs under `out/` and builds the required submodule dependencies.

For a release build without the optional QJsonRPC dependency:

```bash
qmake TargomanTextProcessor.pro CONFIG+=release QJsonRPC=0
make -j"$(nproc)"
```

For a debug build, use:

```bash
qmake TargomanTextProcessor.pro CONFIG+=debug QJsonRPC=0
make -j"$(nproc)"
```

Use `QJsonRPC=1` consistently when building an application that needs the optional QJsonRPC integration. E4MT documents the application and server options; building TextProcessor itself produces a library and test executables.

The standard QBuildSystem output layout is:

| Path | Contents |
| --- | --- |
| `out/lib64/` | Shared libraries on x86-64, including `libTargomanTextProcessor.so` |
| `out/lib/` | Shared libraries on architectures using the `lib` layout |
| `out/include/` | Exported headers |
| `out/conf/` | Configuration files copied by the library's post-build step |
| `out/test/` | Developer test executable |
| `out/unitTest/` | Qt unit-test executable |

For local execution, add the build's library directories to the loader path without removing existing entries:

```bash
export LD_LIBRARY_PATH="$PWD/out/lib64:$PWD/out/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
```

The project includes Qt unit tests:

```bash
./out/unitTest/unitst_TargomanTextProcessor
```

Their configuration paths are relative to the executable and expect the standard repository/output layout. The program under `test/` contains developer examples; it is not the E4MT command-line interface.

## Sample codes

### C++: initialize, normalize, and tokenize Persian text

The public interface is in [`TextProcessor.h`](libsrc/libTargomanTextProcessor/TextProcessor.h). Initialize the processor once with the configuration directory before processing text. This example accepts that directory as its first argument, such as `/path/to/TextProcessor/libsrc/conf`.

```cpp
#include <QCoreApplication>
#include <QDebug>
#include <QDir>
#include <QVariant>
#include "libTargomanTextProcessor/TextProcessor.h"

int main(int argc, char *argv[])
{
    QCoreApplication app(argc, argv);
    if (argc != 2) {
        qCritical() << "Usage:" << argv[0] << "/path/to/TextProcessor/libsrc/conf";
        return 1;
    }

    using Targoman::NLPLibs::TargomanTextProcessor;

    QDir confDir(QString::fromLocal8Bit(argv[1]));
    TargomanTextProcessor::stuConfigs configs;
    configs.NormalizationFile = confDir.absoluteFilePath("Normalization.conf");
    configs.AbbreviationsFile = confDir.absoluteFilePath("Abbreviations.tbl");
    configs.SpellCorrectorBaseConfigPath = confDir.absoluteFilePath("SpellCorrectors");

    QVariantHash persian;
    persian.insert("Active", true);
    configs.SpellCorrectorLanguageBasedConfigs.insert("fa", persian);

    auto &processor = TargomanTextProcessor::instance();
    processor.init(configs);

    const QString input = QString::fromUtf8("من می روم و كتاب ها را می خوانم.");

    // An empty language selects character normalization without spell correction.
    const QString normalized = processor.normalizeText(input, false, QString());

    // Explicitly disable interactive mode for batch processing.
    bool spellCorrected = false;
    const QString ixml = processor.text2IXML(
        input, spellCorrected, "fa", 0,
        false,  // interactive
        true    // useSpellCorrector
    );

    const QString tokens = processor.ixml2Text(ixml, false);
    const QString detokenized = processor.ixml2Text(ixml, true);

    qInfo().noquote() << "Character normalization:" << normalized;
    qInfo().noquote() << "IXML:" << ixml;
    qInfo().noquote() << "Tokens:" << tokens;
    qInfo().noquote() << "Detokenized text:" << detokenized;
    return 0;
}
```

Compile your application with Qt 5, the exported headers, and the TextProcessor and TargomanCommon libraries. For example, save the source above as `example.cpp` and this file as `example.pro` in a separate application directory:

```qmake
QT += core network
QT -= gui
CONFIG += console c++17
CONFIG -= app_bundle
TEMPLATE = app
TARGET = example
SOURCES += example.cpp

# Set this to the absolute path of your built TextProcessor checkout.
TEXTPROCESSOR_ROOT = /path/to/TextProcessor
INCLUDEPATH += $$TEXTPROCESSOR_ROOT/out/include
LIBS += -L$$TEXTPROCESSOR_ROOT/out/lib64 \
        -L$$TEXTPROCESSOR_ROOT/out/lib \
        -lTargomanTextProcessor -lTargomanCommon -lz
```

Build and run it after setting the loader path to the TextProcessor build's library directories:

```bash
qmake example.pro
make -j"$(nproc)"
./example /path/to/TextProcessor/libsrc/conf
```

`normalizeText` with a nonempty language also invokes the language-aware processing path. For explicit control over interactive mode and spelling correction, use `text2IXML` as above and then `ixml2Text`.

### Command-line processing and Python

For file input/output and application modes, follow the [E4MT setup and examples](https://github.com/Targoman/E4MT#setup). Its `E4MT` executable is built from the E4MT repository.

For Python integration, see [E4MTPy](https://github.com/Targoman/E4MTPy). Developers implementing bindings can inspect [`TextProcessor_c.h`](libsrc/libTargomanTextProcessor/TextProcessor_c.h) and its [implementation](libsrc/libTargomanTextProcessor/TextProcessor_c.cpp); verify argument signatures and buffer handling against the revision being integrated.

## Configuration and language data

The shared library needs its runtime data as well as its compiled dependencies:

| File or directory | Purpose |
| --- | --- |
| [`libsrc/conf/Normalization.conf`](libsrc/conf/Normalization.conf) | Character normalization rules |
| [`libsrc/conf/Abbreviations.tbl`](libsrc/conf/Abbreviations.tbl) | Abbreviations used during tagging and punctuation handling |
| [`libsrc/conf/SpellCorrectors/Persian/`](libsrc/conf/SpellCorrectors/Persian) | Persian dictionaries, verb stems, spelling corrections, and spacing rules |

Set `SpellCorrectorBaseConfigPath` to the parent `SpellCorrectors` directory, and activate Persian through `SpellCorrectorLanguageBasedConfigs["fa"]["Active"]`. Supplying `"fa"` on processing calls selects the Persian language path. Configuration is initialized once per process; later calls to `init` do not reload different tables.

Keep the runtime data with your deployment and use explicit paths. Copying only the `.so` file is insufficient. For reproducible corpus processing, record the source revision, submodule revisions, configuration files, and enabled processing options.

## Troubleshooting

### Unavailable submodule commit

An error such as:

```text
fatal: remote error: upload-pack: not our ref e29d342e210d750bb91c4cc77eae8e83aa8c0ec3
```

means the configured remote cannot supply a commit recorded by the parent repository. First synchronize the URLs and retry:

```bash
git submodule sync --recursive
git submodule update --init --recursive
```

If the error persists, the reproducible fix is to restore the missing commit from a clone or backup that contains it, or update the parent repository to a verified replacement commit. Re-cloning alone does not repair an unavailable commit.

If you deliberately choose to test the current upstream version of QBuildSystem as a replacement, update only that submodule:

```bash
git submodule update --init --remote --checkout -- 3rdParty/QBuildSystem
git add 3rdParty/QBuildSystem
git submodule update --init --recursive
```

This changes the dependency version and does not guarantee build compatibility. Staging the new reference makes subsequent updates use it instead of requesting the unavailable commit. Review and test the replacement before committing it. Applying `--remote` to every submodule would also change unrelated dependency versions.

### Submodule directories contain only `.git`

Inspect the affected working trees:

```bash
git -C 3rdParty/QBuildSystem status --short
git -C 3rdParty/TargomanCommon status --short
```

If there are no local edits to preserve, force a checkout of the recorded commits:

```bash
git submodule update --init --recursive --checkout --force -- \
    3rdParty/QBuildSystem 3rdParty/TargomanCommon
```

`--force` overwrites local changes in the selected submodules and their nested submodules. It cannot recover a commit that the remote does not have.

### Missing build or runtime files

- **`Cannot find ... projectConfigs.pri`:** check that `3rdParty/QBuildSystem/templates/` contains the qmake templates.
- **Qt 6 selected:** put the Qt 5 qmake executable on `PATH`; the dependency builder expects Qt 5.
- **`python: command not found`:** ensure `python` invokes Python 3 as required by QBuildSystem's post-build script.
- **Shared library cannot be loaded:** set `LD_LIBRARY_PATH` to the appropriate `out/lib64` and `out/lib` directories, including dependencies.
- **Normalization or spelling data cannot be loaded:** check all three configuration paths and retain the `SpellCorrectors/Persian` directory structure.

## License

TextProcessor is published under the terms of the [GNU Lesser General Public License v3](LICENSE). See individual dependencies for their licenses.
