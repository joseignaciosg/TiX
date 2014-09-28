#!/usr/bin/env python

"""
Copyright (2011) Sebastiaan Mathot
<http://www.cogsci.nl/>

fixindent is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

fixindent is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with fixindent.  If not, see <http://www.gnu.org/licenses/>.
"""

import sys
import optparse

if __name__ == "__main__":

	# Parse command line options
	parser = optparse.OptionParser("usage: fixindent [options]")
	parser.set_defaults(tab = False)
	parser.set_defaults(space = False)
	parser.set_defaults(width = 4)
	parser.set_defaults(clean = False)
	parser.set_defaults(in_file = None)
	parser.set_defaults(out_file = None)	
	parser.add_option("-t", "--tab", action = "store_true", dest = "tab", help = "Use tab-bases indentation and convert spaces to tabs")		
	parser.add_option("-s", "--space", action = "store_true", dest = "space", help = "Use space-based indentation and convert tabs to spaces")
	parser.add_option("-w", "--width", action = "store_true", dest = "width", help = "The number of spaces that make up an indentation")
	parser.add_option("-c", "--clean", action = "store_true", dest = "clean", help = "Strip white spaces and tabs from the end of each line")
	parser.add_option("-i", "--in", action = "store", dest = "in_file", help = "Input file (default = stdin)")
	parser.add_option("-o", "--out", action = "store", dest = "out_file", help = "Output file (defaults = stdout)")	
	options, args = parser.parse_args(sys.argv)
	
	if not options.tab and not options.space:
		parser.error("Please specify either --tab or --space (see -h for help)")	
			
	if options.tab and options.space:
		parser.error("--tab and --space are mutually exclusive (see -h for help)")
		
	# Open the input file (or stdin)
	if options.in_file == None:
		f_in = sys.stdin
	else:
		f_in = open(options.in_file, "r")
		
	# Open the output file (or stdout)
	if options.out_file == None:
		f_out = sys.stdout
	else:
		f_out = open(options.out_file, "w")

	# Walk through all input lines
	for l in f_in:
	
		if options.tab:		
			i = 0
			while l[:options.width] == " " * options.width:		
				l = l[options.width:]
				i += 1
			l = "\t" * i + l
		else:
			i = 0
			while l[0] == "\t":
				l = l[1:]
				i += 1
			l = " " * i * options.width + l				
			
		if options.clean:
			l = l.rstrip(" \t\n") + "\n"

		f_out.write(l)
