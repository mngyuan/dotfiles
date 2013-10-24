# grade calculator with weighted
from collections import OrderedDict
from decimal import * # for no float errors/clean values, like 0.95 instead of 0.94999999999979999

# grade file, tabdelimited, will look as follows:
# assignmentname    weight/100  score/maxscore
# where name is a string, weight is a string of an integer 1-100,
# and score/maxscore is a string of ints or floats
# ex:
# midterm #1    20  78/100
# final exam    20  NA
#
# would be the first midterm, worth 20% of the final grade, with a score of 78%.
# NA indicates not taken yet.



# file to use
# replace with optparse pls
GRADEBOOKFILE = "philo2.txt"


class GradeItem:
    """For entries in the gradebook
    self.name a string
    self.weight a Decimal float 0<1
    self.value a string
    self.decvalue a Decimal float 0<1"""
    def __init__(self, name, weight, value):
        self.name = name
        self.weight = Decimal(int(weight)/Decimal(100))
        self.value = value #in 39/40 form
        # dangerous use of the eval function
        if value != "NA":
            value = value.split('/')
            self.decvalue = Decimal(value[0]) / Decimal(value[1])
        else:
            self.decvalue = value

    def __str__(self):
        if GradeItem.useBoth == True:
            return self.name + '\t' + str(self.weight*100) + '\t' + self.value + '\t' + \
                   str(self.decvalue) + '\n'
        elif GradeItem.useDec == False:
            return self.name + '\t' + str(self.weight*100) + '\t' + self.value + '\n'
        else:
            return self.name + '\t' + str(self.weight*100) + '\t' + str(self.decvalue) + '\n'         

    useDec = True
    useBoth = True

class GradeBook:
    def __init__(self, gradefile, course="Class"):
        self.gdict = OrderedDict()
        self.course = course
        self.readGrades(gradefile)
        self.gradeTD = 0

    def readGrades(self, gfileloc):
        with open(gfileloc, "r") as gfile:
            # rewrite the dictionary to start clean
            self.gdict = OrderedDict()
            for ln in gfile:
                ln = ln.strip('\n')
                ln = ln.split('\t')
                self.gdict[ln[0]] = GradeItem(ln[0], ln[1], ln[2])
        print("Grades from ", gfileloc, "read.")

    def calc_gradeToDate(self):
        maxGradeTD = Decimal(0) # total % of grade accounted for, TD (to date)
        scoreTD = Decimal(0)
        for g in self.gdict.values():
            if g.decvalue != "NA": #exclude what hasn't been taken
                scoreTD += g.decvalue*g.weight
                maxGradeTD += g.weight
        self.gradeTD = scoreTD/maxGradeTD
        return self.gradeTD

    def countNAs(self):
        # helper function to find how many grades missing
        NAcount = 0
        for v in self.gdict.values():
            if v.decvalue == "NA":
                NAcount += 1
        return NAcount

    def calc_neededGrade(self, gname = None, desiredg = 0.9):
        # implementation overview
        #
        #if gname == None
        #   if gradebook has one NA
        #       calculates grade needed on this NA grade to keep desiredg
        #   elif gradebook has count(NA) > 1
        #       sum weights of NA's together and find needed grade for this polygrade
        #if gname given:
        #       assume avg work on all other NA's
        #       calculate needed grade on gname

        
        # to keep your current average all you have to do is score your current avg
        # even with weighted avgs!

        if gname != None:
            try:
                g = self.gdict[gname]
            except KeyError:
                print("Not a valid assignment name")
                return -1
            else:
                self.calc_gradeToDate()
                # we're going to edit in grade values that won't change the grade
                copyd = self.gdict.copy()
                for k, v in copyd.items():
                    if v.decvalue == "NA":
                        if copyd[k] is not copyd[gname]: #hm.
                            copyd[k].decvalue = self.gradeTD

                return self.calc_neededGrade_helper(g, copyd, desiredg)
        else:
            if self.countNAs() > 1:
                polyw = 0
                for v in self.gdict.values():
                    print(v.decvalue)
                    if v.decvalue == "NA":
                        polyw += v.weight
                polyg = GradeItem("PolyG needed grade", polyw, "NA")
                return self.calc_neededGrade_helper(polyg, self.gdict, desiredg)

    def calc_neededGrade_helper(self, neededg, graded, desiredg): #gradeD, the grade dict
        # do the actual math here
        # given the weight of the needed grade, the grades, and the overall grade desired
        neededGrade = Decimal(str(desiredg))
        for g in graded.values():
            if g.decvalue != "NA":
                neededGrade = neededGrade - g.decvalue * g.weight
        neededGrade = neededGrade/neededg.weight
        return neededGrade


    def __str__(self):
        rval = ""
        for g in self.gdict.values():
            rval += str(g)
        return rval

def main():
    GradeItem.useDec = False
    GradeItem.useBoth = True
    myGradebook = GradeBook(GRADEBOOKFILE)
    print(myGradebook)
    print("Current grade is: ", myGradebook.calc_gradeToDate())
    print("Grade needed on final exam for a 0.8: ", myGradebook.calc_neededGrade("final exam", 0.88))
    #print("Grade needed on missing assignments for a 0.9: ", \
    #      myGradebook.calc_neededGrade())
    #print(myGradebook.countNAs())

if __name__ == "__main__":
    main()
