#! /usr/bin/env python
# $Id$

import sys
import os.path
from pylib import *

SetupEnvironment()
DoPackage(sys.argv)

print("%s: Success." % os.path.basename(sys.argv[0]))
