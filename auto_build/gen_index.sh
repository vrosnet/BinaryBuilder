#!/bin/bash

if [ "$#" -lt 3 ]; then echo Usage: $0 path version timestamp; exit; fi

path=$1
version=$2
timestamp=$3
index=index.html

cd $path

echo '<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head><title>Stereo Pipeline daily build</title></head>
<body>
' > $index

echo "<h2>Ames Stereo Pipeline version $version, build: $timestamp</h2>" >> $index
echo '<ul>' >> $index
tags="OSX x86_64-Linux-GLIBC-2.5 i686-Linux-GLIBC-2.5 x86_64-Linux-GLIBC-2.17"
for tag in $tags; do
  for f in $(ls *$version*$timestamp*$tag*bz2 2>/dev/null); do
      size="$(ls -lh $f | awk '{print $5}')B"
      if [ "$(echo $f | grep -i OSX)" != "" ]; then
          echo "<li><a href=\"$f\">Mac OS X 10.6+</a> ($size)</li>" >> $index
      fi
      if [ "$(echo $f | grep -i x86_64-Linux-GLIBC-2.5)" != "" ]; then
          echo "<li><a href=\"$f\">Linux-64bit</a> ($size)</li>" >> $index
      fi
      if [ "$(echo $f | grep -i i686-Linux-GLIBC-2.5)" != "" ]; then
          echo "<li><a href=\"$f\">Linux-32bit</a> ($size)</li>" >> $index
      fi
      if [ "$(echo $f | grep -i x86_64-Linux-GLIBC-2.17)" != "" ]; then
          echo "<li><a href=\"$f\">Linux-64bit for GLIBC2.17 and newer for additional performance</a> ($size)</li>" >> $index
      fi
  done
done

f="asp_book.pdf"
if [ -f "$f" ]; then
    size="$(ls -lh $f | awk '{print $5}')B"
    echo "<li><a href=\"$f\">Documentation</a> ($size)</li>" >> $index
fi

f="StereoPipelinePythonModules.tgz"
if [ -f "$f" ]; then
    size="$(ls -lh $f | awk '{print $5}')B"
    echo "<li><a href=\"$f\">Optional Python Modules</a> ($size)</li>" >> $index
fi

echo '</ul>
Contact: stereo-pipeline-owner [at] lists [dot] nasa [dot] gov<br>
<a href="http://ti.arc.nasa.gov/tech/asr/intelligent-robotics/ngt/stereo/">About Ames Stereo Pipeline</a>
</body>
</hml>
' >> $index
