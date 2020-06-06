from subprocess import call
from random import randint
from os import remove
from subprocess import Popen, PIPE

def useTpWithFile(nameFile, placeWhereIsLocated = "../src/./tp1", useStdout = True):
    p = Popen([placeWhereIsLocated, "-i", nameFile], stdout=PIPE, stderr=PIPE)
    output, err = p.communicate()
    rc = p.returncode
    return output if useStdout else err

def checkOutput(returnedString, nameOfFile, keepTheName = False):
    theSame = True
    if (not str(returnedString) == returnedString):
        returnedString = returnedString.decode('ascii')
    arrayWithAnswers = returnedString.split('\n')
    with open(nameOfFile + ('Answer' if not keepTheName else ""), 'r') as answer:
        i = 0
        for line in answer:
            if line.rstrip('\n') != arrayWithAnswers[i]:
                print(line + "!=" + arrayWithAnswers[i])
                theSame = False
                break
            i += 1
    return theSame

def addRandomNumbers(n, minNumber = -10000):
    array = []
    for i in range(n):
        array.append(randint(minNumber, 10000))
    return array

def writeFiles(toTestFile, arrayOfArrays, iterationTimes = 1):
    with open(toTestFile, "w") as f:
        for i in range(iterationTimes):
            for array in arrayOfArrays:
                f.write(' '.join(map(str, array)) + "\n" if i != iterationTimes else "")
    with open(toTestFile + "Answer", "w") as f:
        for i in range(iterationTimes):
            for array in arrayOfArrays:
                f.write(' '.join(map(str, sorted(array))) + "\n" if i != iterationTimes else "")

def createTestFile(fileName, linesPerArray, differentAmountArrays, maximumAmountOfNumbers, randomizeMax = False, minNumber = -10000):
    arrayOfArrays = []
    for i in range(differentAmountArrays):
        arrayOfArrays.append(addRandomNumbers(maximumAmountOfNumbers if not randomizeMax else randint(0, maximumAmountOfNumbers), minNumber))
    writeFiles(fileName, arrayOfArrays, linesPerArray)

def testValue(nameFile, linesPerArray, differentAmountArrays, maximumAmountOfNumber, randomize = False, filePlace = None):
    createTestFile(nameFile, linesPerArray, differentAmountArrays, maximumAmountOfNumber, randomize)
    result = useTpWithFile(nameFile, filePlace) if filePlace else useTpWithFile(nameFile)
    isTheSame = checkOutput(result, nameFile)
    if (isTheSame):
        remove(nameFile)
        remove(nameFile + "Answer")
    return isTheSame

def testNormalCases(file):
    if not testValue("nullTestCase", 0, 0, 0, filePlace = file):
        return False
    if not testValue("smallTestCase", 5, 2, 100, filePlace = file):
        return False
    if not testValue("BigTestCase", 1, 100, 2000, True, filePlace = file):
        return False
    if not testValue("allRandom", randint(1, 3), randint(0, 20), randint(20, 500), True, filePlace = file):
        return False
    print("All normal tests ran correctly")
    return True

def useTpToTestMessages(action, placeWhereIsLocated, useStdout = True):
    p = Popen([placeWhereIsLocated, action], stdout=PIPE, stderr=PIPE)
    output, err = p.communicate()
    rc = p.returncode
    return output if useStdout else err

def testMessages(file):
    processCorrect = True
    if not file:
        file = "../src/./tp1"
    if not len(useTpToTestMessages("-h", file)) > 20: #The message here is long, so for performance we will check this way
        print("Error when using ./tp1 -h")
        processCorrect = False
    if (useTpToTestMessages("-V", file).decode('ascii') == ""):
        print("Error when using ./tp1 -v")
        processCorrect = False
    if (len(useTpToTestMessages("Anything", file, useStdout = False)) == 0):
        print("Error when it should be throwing an error");
        processCorrect = False
    return processCorrect

def testWeirdCase(file):
    with open("testWeirdCase", 'w') as f:
        f.write("3              bowhehrk 3 4 a 5we2323 ahwigaofgawbhdgawiugdal")
        f.write("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n finish?")
    if useTpWithFile("testWeirdCase", file, useStdout = False) != b'':
        remove("testWeirdCase")
        return True
    return False

def testTP1(file = None):
    print("Testing usual cases")
    if not testNormalCases(file):
        print("Failed in a test, check the created file to know which")
        return False
    print("Testing messages")
    if not testMessages(file):
        return False
    print("Testing invalid cases")
    if not testWeirdCase(file):
        print("Unknown error while parsing a border case")
        return False
    print("All tests ran correctly")
    return True

#For when testing on mips
testTP1('./tp1')
