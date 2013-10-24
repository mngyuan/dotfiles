# lol

# changes some html links to google spreadsheet formulas

from collections import OrderedDict

s = """<p class="p1"><span class="s1"><a href="http://internet-browser-review.toptenreviews.com/">2013 Internet Browser Software Product Comparisons</a></span></p>
<p class="p1"><span class="s1"><a href="http://www.workroom-productions.com/papers/PVoNT_paper.pdf">A Positive View of Negative Testing</a></span></p>
<p class="p1"><span class="s1">A Reader <a href="http://trailridgeconsulting.com/files/user-story-primer.pdf">Story</a> Primer</span></p>
<p class="p1"><span class="s1"><a href="http://en.wikipedia.org/wiki/Comparison_of_web_browsers">Comparison of web browsers</a></span></p>
<p class="p1"><span class="s1"><a href="http://cm.techwell.com/sites/default/files/articles/XDD2136filelistfilename1_0.pdf">How to Write Better Test Cases</a></span></p>
<p class="p1"><span class="s1"><a href="http://www.sqatester.com/methodology/PositiveandNegativeTesting.htm">Methodology and Techniques – Positive and Negative Testing</a></span></p>
<p class="p1"><span class="s1"><a href="http://en.wikipedia.org/wiki/Regression_testing">Regression</a> Testing</span></p>
<p class="p1"><span class="s1"><a href="http://docs.seleniumhq.org/docs/">Selenium documentation</a></span></p>
<p class="p1"><span class="s1"><a href="http://en.wikipedia.org/wiki/Software_bug">Software</a> Bug</span></p>
<p class="p1"><span class="s1"><a href="http://help.utest.com/testers/crash-courses/functional/test-case-writing-creation-101">Test Case Writing (Creation) 101</a></span></p>
<p class="p1"><span class="s1"><a href="http://c2.com/cgi/wiki?UserStoryAndUseCaseComparison">User Story and Use Case Comparison</a></span></p>
<p class="p1"><span class="s1"><a href="http://www.w3schools.com/sql/default.asp">W3schools</a> - SQL</span></p>
<p class="p1"><span class="s1"><a href="http://en.wikipedia.org/wiki/Use_case">What is a Use Case</a></span></p>
<p class="p1"><span class="s1"><a href="http://www.kaner.com/pdfs/GoodTest.pdf">What is a Good Test Case?</a></span></p>
<p class="p1"><span class="s1"><a href="http://users.csc.calpoly.edu/~grade_cstaley/General/TestingAndBender/TestingHowTo.htm">Writing Effective Test Cases</a></span></p>
"""

linkd = OrderedDict()
# redundant vars ftw
atag = '<a href="'
while 1:
    urlstart = s.find(atag)+len(atag)
    if s.find(atag) == -1:
        break

    urlend = s.find('">', urlstart)
    namestart = urlend + len('">')
    nameend = s.find("</a>", urlend)

    linkd[s[namestart:nameend]] = s[urlstart:urlend]
    s = s[nameend:]

spreadsheetoutput = ""

for text,url in linkd.items():
    spreadsheetoutput += '=hyperlink("%s";"%s")\n'%(url, text)

print(spreadsheetoutput)