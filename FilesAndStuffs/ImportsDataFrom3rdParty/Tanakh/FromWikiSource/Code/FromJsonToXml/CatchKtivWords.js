var checkKtiv = function (sentence) {

    var ktivID = 1;

    var ktiv = []
    var afterWord = []
    var afterWord2 = []
    var beforeWord = []
    var beforeWord2 = []
    var countKtiv = []
    var countAfterWord = []
    var countAfterWord2 = []
    var countBeforeWord = []
    var countBeforeWord2 = []


    for (var w = 0; w <= sentence.length - 1; w++) {

        if (w < sentence.length - 1 && sentence[w].match(/^[א-ת]+$/) && sentence[w + 1].match(/^[א-ת]+$/)) {
            var prektiv2 = []

            for (var l = 0; l <= sentence[w].length - 1; l++) {

                if (sentence[w][l].match(/[י]|[א]|[ה]|[ו]|[־]|[׀]/)) {
                    prektiv2.push({ ID: ktivID, Letterktiv: sentence[w][l], letterType: 0 })
                    ktivID += 1
                    continue
                }
                else {
                    prektiv2.push({ ID: ktivID, Letterktiv: sentence[w][l], letterType: 1 })
                    ktivID += 1
                }
            }

            for (var l in sentence[w + 1]) {
                if (sentence[w + 1][l].match(/[א-ת]+/)) {
                    if (sentence[w + 1][l].match(/[י]|[א]|[ה]|[ו]|[־]|[׀]/)) {
                        prektiv2.push({ ID: ktivID, Letterktiv: sentence[w + 1][l], letterType: 0 })
                        ktivID += 1
                        continue
                    }
                    else {
                        prektiv2.push({ ID: ktivID, Letterktiv: sentence[w + 1][l], letterType: 1 })
                        ktivID += 1
                    }
                }
            }

            ktivID = 1

            var preafterWord2 = []

            for (var l in sentence[w + 2]) {
                if (sentence[w + 2][l].match(/[א-ת]+/)) {
                    if (sentence[w + 2][l].match(/[י]|[א]|[ה]|[ו]|[־]|[׀]/)) {
                        preafterWord2.push({ ID: ktivID, Letterktiv: sentence[w + 2][l], letterType: 0, numWord: w + 2 })
                        ktivID += 1
                        continue
                    }
                    else {
                        preafterWord2.push({ ID: ktivID, Letterktiv: sentence[w + 2][l], letterType: 1, numWord: w + 2 })
                        ktivID += 1
                    }
                }
            }

            ktivID = 1

            var precount2Ktiv = []

            var precount2AfterWord = []

            for (var i in prektiv2) {
                if (prektiv2[i].letterType == 1) {
                    precount2Ktiv.push('1')
                }
            }

            for (var i in preafterWord2) {
                if (preafterWord2[i].letterType == 1) {
                    precount2AfterWord.push('1')
                }
            }

            var pre2afterWord2 = []

            for (var l in sentence[w + 2]) {
                if (sentence[w + 2][l].match(/[א-ת]+/)) {
                    if (sentence[w + 2][l].match(/[י]|[א]|[ה]|[ו]|[־]|[׀]/)) {
                        pre2afterWord2.push({ ID: ktivID, Letterktiv: sentence[w + 2][l], letterType: 0, numWord: [w + 2, w + 3] })
                        ktivID += 1
                        continue
                    }
                    else {
                        pre2afterWord2.push({ ID: ktivID, Letterktiv: sentence[w + 2][l], letterType: 1, numWord: [w + 2, w + 3] })
                        ktivID += 1
                    }
                }
            }

            for (var l in sentence[w + 3]) {
                if (sentence[w + 3][l].match(/[א-ת]+/)) {
                    if (sentence[w + 3][l].match(/[י]|[א]|[ה]|[ו]|[־]|[׀]/)) {
                        pre2afterWord2.push({ ID: ktivID, Letterktiv: sentence[w + 3][l], letterType: 0, numWord: [w + 2, w + 3] })
                        ktivID += 1
                        continue
                    }
                    else {
                        pre2afterWord2.push({ ID: ktivID, Letterktiv: sentence[w + 3][l], letterType: 1, numWord: [w + 2, w + 3] })
                        ktivID += 1
                    }
                }
            }
            ktivID = 1

            var precount2AfterWord2 = []

            for (var i in pre2afterWord2) {
                if (pre2afterWord2[i].letterType == 1) {
                    precount2AfterWord2.push('1')
                }
            }

            var pre2beforeWord = []

            for (var l in sentence[w - 1]) {
                if (sentence[w - 1][l].match(/[א-ת]+/)) {
                    if (sentence[w - 1][l].match(/[י]|[א]|[ה]|[ו]|[־]|[׀]/)) {
                        pre2beforeWord.push({ ID: ktivID, Letterktiv: sentence[w - 1][l], letterType: 0, numWord: w - 1 })
                        ktivID += 1
                        continue
                    }
                    else {
                        pre2beforeWord.push({ ID: ktivID, Letterktiv: sentence[w - 1][l], letterType: 1, numWord: w - 1 })
                        ktivID += 1
                    }
                }
            }

            ktivID = 1

            var pre2countBeforeWord = []

            for (var i in pre2beforeWord) {
                if (pre2beforeWord[i].letterType == 1) {
                    pre2countBeforeWord.push('1')
                }
            }

            var pre2beforeWord2 = []

            for (var l in sentence[w - 2]) {

                if (sentence[w - 2][l].match(/[א-ת]+/)) {

                    if (sentence[w - 2][l].match(/[י]|[א]|[ה]|[ו]|[־]|[׀]/)) {
                        pre2beforeWord2.push({ ID: ktivID, Letterktiv: sentence[w - 2][l], letterType: 0, numWord: [w - 2, w - 1] })
                        ktivID += 1
                        continue
                    }
                    else {
                        pre2beforeWord2.push({ ID: ktivID, Letterktiv: sentence[w - 2][l], letterType: 1, numWord: [w - 2, w - 1] })
                        ktivID += 1
                    }
                }
            }

            for (var l in sentence[w - 1]) {
                if (sentence[w - 1][l].match(/[א-ת]+/)) {
                    if (sentence[w - 1][l].match(/[י]|[א]|[ה]|[ו]|[־]|[׀]/)) {
                        pre2beforeWord2.push({ ID: ktivID, Letterktiv: sentence[w - 1][l], letterType: 0, numWord: [w - 2, w - 1] })
                        ktivID += 1
                        continue
                    }
                    else {
                        pre2beforeWord2.push({ ID: ktivID, Letterktiv: sentence[w - 1][l], letterType: 1, numWord: [w - 2, w - 1] })
                        ktivID += 1
                    }
                }
            }

            ktivID = 1

            var pre2countBeforeWord2 = []

            for (var i in pre2beforeWord2) {
                if (pre2beforeWord2[i].letterType == 1) {
                    pre2countBeforeWord2.push('1')
                }
            }




            ktiv.push(prektiv2)
            countKtiv.push(precount2Ktiv)
            afterWord.push(preafterWord2)
            countAfterWord.push(precount2AfterWord)
            afterWord2.push(pre2afterWord2)
            countAfterWord2.push(precount2AfterWord2)
            beforeWord.push(pre2beforeWord)
            countBeforeWord.push(pre2countBeforeWord)
            beforeWord2.push(pre2beforeWord2)
            countBeforeWord2.push(pre2countBeforeWord2)
            continue
        }

        if (w <= sentence.length - 1 && sentence[w].match(/^[א-ת]+$/)) {

            var preKtiv = []

            for (var l = 0; l <= sentence[w].length - 1; l++) {

                if (sentence[w][l].match(/[י]|[א]|[ה]|[ו]|[־]|[׀]/)) {
                    preKtiv.push({ ID: ktivID, Letterktiv: sentence[w][l], letterType: 0 })
                    ktivID += 1
                    continue
                }
                else {
                    preKtiv.push({ ID: ktivID, Letterktiv: sentence[w][l], letterType: 1 })
                    ktivID += 1
                }
            }

            ktivID = 1

            var preafterWord = []

            for (var l in sentence[w + 1]) {
                if (sentence[w + 1][l].match(/[א-ת]+/)) {
                    if (sentence[w + 1][l].match(/[י]|[א]|[ה]|[ו]|[־]|[׀]/)) {
                        preafterWord.push({ ID: ktivID, Letterktiv: sentence[w + 1][l], letterType: 0, numWord: w + 1 })
                        ktivID += 1
                        continue
                    }
                    else {
                        preafterWord.push({ ID: ktivID, Letterktiv: sentence[w + 1][l], letterType: 1, numWord: w + 1 })
                        ktivID += 1
                    }
                }
            }


            ktivID = 1

            var precountKtiv = []

            var precountAfterWord = []

            for (var i in preKtiv) {
                if (preKtiv[i].letterType == 1) {
                    precountKtiv.push('1')
                }
            }

            for (var i in preafterWord) {
                if (preafterWord[i].letterType == 1) {
                    precountAfterWord.push('1')
                }
            }

            var preafterWord2 = []

            for (var l in sentence[w + 1]) {
                if (sentence[w + 1][l].match(/[א-ת]+/)) {
                    if (sentence[w + 1][l].match(/[י]|[א]|[ה]|[ו]|[־]|[׀]/)) {
                        preafterWord2.push({ ID: ktivID, Letterktiv: sentence[w + 1][l], letterType: 0, numWord: [w + 1, w + 2] })
                        ktivID += 1
                        continue
                    }
                    else {
                        preafterWord2.push({ ID: ktivID, Letterktiv: sentence[w + 1][l], letterType: 1, numWord: [w + 1, w + 2] })
                        ktivID += 1
                    }
                }
            }

            for (var l in sentence[w + 2]) {
                if (sentence[w + 2][l].match(/[א-ת]+/)) {
                    if (sentence[w + 2][l].match(/[י]|[א]|[ה]|[ו]|[־]|[׀]/)) {
                        preafterWord2.push({ ID: ktivID, Letterktiv: sentence[w + 2][l], letterType: 0, numWord: [w + 1, w + 2] })
                        ktivID += 1
                        continue
                    }
                    else {
                        preafterWord2.push({ ID: ktivID, Letterktiv: sentence[w + 2][l], letterType: 1, numWord: [w + 1, w + 2] })
                        ktivID += 1
                    }
                }
            }

            ktivID = 1

            var precountAfterWord2 = []

            for (var i in preafterWord2) {
                if (preafterWord2[i].letterType == 1) {
                    precountAfterWord2.push('1')
                }
            }

            var prebeforeWord = []

            for (var l in sentence[w - 1]) {
                if (sentence[w - 1][l].match(/[א-ת]+/)) {
                    if (sentence[w - 1][l].match(/[י]|[א]|[ה]|[ו]|[־]|[׀]/)) {
                        prebeforeWord.push({ ID: ktivID, Letterktiv: sentence[w - 1][l], letterType: 0, numWord: w - 1 })
                        ktivID += 1
                        continue
                    }
                    else {
                        prebeforeWord.push({ ID: ktivID, Letterktiv: sentence[w - 1][l], letterType: 1, numWord: w - 1 })
                        ktivID += 1
                    }
                }
            }

            ktivID = 1

            var precountBeforeWord = []

            for (var i in prebeforeWord) {
                if (prebeforeWord[i].letterType == 1) {
                    precountBeforeWord.push('1')
                }
            }

            var prebeforeWord2 = []

            for (var l in sentence[w - 2]) {

                if (sentence[w - 2][l].match(/[א-ת]+/)) {

                    if (sentence[w - 2][l].match(/[י]|[א]|[ה]|[ו]|[־]|[׀]/)) {
                        prebeforeWord2.push({ ID: ktivID, Letterktiv: sentence[w - 2][l], letterType: 0, numWord: [w - 2, w - 1] })
                        ktivID += 1
                        continue
                    }
                    else {
                        prebeforeWord2.push({ ID: ktivID, Letterktiv: sentence[w - 2][l], letterType: 1, numWord: [w - 2, w - 1] })
                        ktivID += 1
                    }
                }
            }

            for (var l in sentence[w - 1]) {
                if (sentence[w - 1][l].match(/[א-ת]+/)) {
                    if (sentence[w - 1][l].match(/[י]|[א]|[ה]|[ו]|[־]|[׀]/)) {
                        prebeforeWord2.push({ ID: ktivID, Letterktiv: sentence[w - 1][l], letterType: 0, numWord: [w - 2, w - 1] })
                        ktivID += 1
                        continue
                    }
                    else {
                        prebeforeWord2.push({ ID: ktivID, Letterktiv: sentence[w - 1][l], letterType: 1, numWord: [w - 2, w - 1] })
                        ktivID += 1
                    }
                }
            }

            ktivID = 1

            var precountBeforeWord2 = []

            for (var i in prebeforeWord2) {
                if (prebeforeWord2[i].letterType == 1) {
                    precountBeforeWord2.push('1')
                }
            }

            ktiv.push(preKtiv)
            countKtiv.push(precountKtiv)
            afterWord.push(preafterWord)
            countAfterWord.push(precountAfterWord)
            afterWord2.push(preafterWord2)
            countAfterWord2.push(precountAfterWord2)
            beforeWord.push(prebeforeWord)
            countBeforeWord.push(precountBeforeWord)
            beforeWord2.push(prebeforeWord2)
            countBeforeWord2.push(precountBeforeWord2)
            continue
        }


        else {
            continue
        }
    }

    if (ktiv.length   == 0) {
        return false
    }

    return {
        countKtiv,
        ktiv,
        countAfterWord,
        afterWord,
        countAfterWord2,
        afterWord2,
        countBeforeWord,
        beforeWord,
        countBeforeWord2,
        beforeWord2
    }
}

module.exports = {
    checkKtiv
}


