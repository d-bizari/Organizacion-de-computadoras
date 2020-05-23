from subprocess import call
from random import randint
from os import remove
from contextlib import redirect_stdout
from subprocess import Popen, PIPE

def useTpWithFile(nameFile, placeWhereIsLocated = "../src/./tp1"):
    p = Popen([placeWhereIsLocated, "-i", nameFile], stdout=PIPE, stderr=PIPE)
    output, err = p.communicate()
    rc = p.returncode
    return output

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

def testValue(nameFile, linesPerArray, differentAmountArrays, maximumAmountOfNumber, randomize = False):
    createTestFile(nameFile, linesPerArray, differentAmountArrays, maximumAmountOfNumber, randomize)
    result = useTpWithFile(nameFile)
    #we will make the merge okay, so when that is done, we should change that
    isTheSame = checkOutput(result, nameFile)
    if (isTheSame):
        remove(nameFile)
        remove(nameFile + "Answer")
    return isTheSame

def testNormalCases():
    if not testValue("nullTestCase", 0, 0, 0):
        return False
    if not testValue("smallTestCase", 5, 2, 100):
        return False
    if not testValue("BigTestCase", 1, 100, 2000, True):
        return False
    return True

def testTP1(file):
    if not testNormalCases():
        print("Failed in a test, check the created file to know which")
