from optparse import OptionParser

def main():
    parser = OptionParser("python txtconvert.py [options] infile outfile")
    parser.add_option("-u", "--unix", action="store_true", dest="type",\
                      help="Convert from OSX/Linux/Unix style ('\\n')")
    parser.add_option("-w", "--windows", action="store_false", dest="type",\
                      help="Convert from Windows ('\\r\\n')")

    (options, args) = parser.parse_args()

    if len(args) == 0:
        parser.print_help()
        return 0
    if len(args) != 2:
        print "Please specify infile and outfile"
        parser.print_help()
        return 0

    infile = open(args[0])
    outfile = open(args[1], 'w')
    if options.type == True: #convert from Unix
        for ln in infile:
            ln = ln.replace('\n', '\r\n')
            outfile.write(ln)

    elif options.type == False: #convert from windows
        for ln in infile:
            ln = ln.replace('\r\n', '\n')
            outfile.write(ln)

if __name__ == "__main__":
    main()
