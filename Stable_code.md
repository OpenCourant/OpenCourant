# OpenCourant Stable Code

This section describes how to access the stable version of OpenCourant.
Review the [How to Contribute](Contributing.md) section to create a clone of OpenCourant.

## Stable code in OpenCourant

* The Stable code in OpenCourant is set with a **git tag**
* The Tag is in the main branch of OpenCourant.
* It is named

      latest-YYYYMMDD

## To obtain a stable version of the code

### Download from the release area

Source code can be downloaded from the [Releases area on GitHub](https://github.com/OpenCourant/OpenCourant/releases)

![image](/doc/stable_release.png)

### Obtain the stable release from a clone of the OpenCourant repository

Command line calls permit gathering the tags from OpenCourant:

#### On Linux in the clone

  To gather all tags from OpenCourant
  
      git fetch --tags origin main

  To work on the latest stable version

      export latest_tag=`git tag --sort=-version:refname  |head -1`
      git checkout $latest_tag
      
#### On Windows in the clone with cmd commands

  To gather all tags from OpenCourant

      git fetch --tags origin main
      git tag --sort=-version:refname > tags.txt
      set /p latest-tag=<tags.txt
      git checkout %latest-tag%

### Obtain the stable release from your fork of the OpenCourant repository

Command line calls permit gathering the tags from OpenCourant when the clone is from a fork:

#### On Linux in the fork clone

  To gather all tags from OpenCourant:
  
      git fetch --tags upstream main

  To work on the latest stable version:

      export latest_tag=`git tag --sort=-version:refname  |head -1`
      git checkout $latest_tag
      
#### On Windows in the fork clone with cmd commands

  To gather all tags from OpenCourant:

      git fetch --tags upstream main

  To work on the latest stable version:

      git tag --sort=-version:refname > tags.txt
      set /p latest-tag=<tags.txt
      git checkout %latest-tag%
