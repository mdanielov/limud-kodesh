var array = require('./ktiv')

var checkKtiv2 = function (sentence) {
    var checkKtiv = array.checkKtiv(sentence)

    if (checkKtiv == false) {
        return
    }

    var result = []

    var countKtiv = checkKtiv.countKtiv
    var ktiv = checkKtiv.ktiv
    var countAfterWord = checkKtiv.countAfterWord
    var afterWord = checkKtiv.afterWord
    var countAfterWord2 = checkKtiv.countAfterWord2
    var afterWord2 = checkKtiv.afterWord2
    var countBeforeWord = checkKtiv.countBeforeWord
    var beforeWord = checkKtiv.beforeWord
    var countBeforeWord2 = checkKtiv.countBeforeWord2
    var beforeWord2 = checkKtiv.beforeWord2

    for (var i = 0; i <= ktiv.length - 1; i++) {

        if (countAfterWord[i].length == countKtiv[i].length) {
            var array1 = ktiv[i].map(a => {
                if (a.letterType == 1) {
                    return a.Letterktiv
                }
            }).sort()
            var array2 = afterWord[i].map(a => {
                if (a.letterType == 1) {
                    return a.Letterktiv
                }
            }).sort()
            var arr2 = array2.filter((el) => {
                return el != undefined
            })
            var arr1 = array1.filter((el) => {
                return el != undefined
            })
            if (JSON.stringify(arr1) == JSON.stringify(arr2)) {
                result.push(afterWord[i][0].numWord)
                continue
            }
            for (var l in arr1) {
                if (arr1[l] == 'ן') {
                    arr1[l] = 'נ'
                }
                if (arr1[l] == 'ץ') {
                    arr1[l] = 'צ'
                }
                if (arr1[l] == 'ף') {
                    arr1[l] = 'פ'
                }
                if (arr1[l] == 'ם') {
                    arr1[l] = 'מ'
                }
                if (arr1[l] == 'ך') {
                    arr1[l] = 'כ'
                }
            }
            for (var l in arr2) {
                if (arr2[l] == 'ן') {
                    arr2[l] = 'נ'
                }
                if (arr2[l] == 'ץ') {
                    arr2[l] = 'צ'
                }
                if (arr2[l] == 'ף') {
                    arr2[l] = 'פ'
                }
                if (arr2[l] == 'ם') {
                    arr2[l] = 'מ'
                }
                if (arr2[l] == 'ך') {
                    arr2[l] = 'כ'
                }
            }
            if (JSON.stringify(arr1) == JSON.stringify(arr2)) {
                result.push(afterWord[i][0].numWord)
                continue
            }
        }



        if (countAfterWord[i].length < countKtiv[i].length) {
            if (countAfterWord2[i].length == countKtiv[i].length) {
                var array1 = ktiv[i].map(a => {
                    if (a.letterType == 1) {
                        return a.Letterktiv
                    }
                }).sort()
                var array2 = afterWord2[i].map(a => {
                    if (a.letterType == 1) {
                        return a.Letterktiv
                    }
                }).sort()
                var arr1 = array1.filter((el) => {
                    return el != undefined
                })
                var arr2 = array2.filter((el) => {
                    return el != undefined
                })
                if (JSON.stringify(arr1) == JSON.stringify(arr2)) {
                    result.push(afterWord2[i][0].numWord[0])
                    result.push(afterWord2[i][0].numWord[1])
                    continue
                }
                for (var l in arr1) {
                    if (arr1[l] == 'ן') {
                        arr1[l] = 'נ'
                    }
                    if (arr1[l] == 'ץ') {
                        arr1[l] = 'צ'
                    }
                    if (arr1[l] == 'ף') {
                        arr1[l] = 'פ'
                    }
                    if (arr1[l] == 'ם') {
                        arr1[l] = 'מ'
                    }
                    if (arr1[l] == 'ך') {
                        arr1[l] = 'כ'
                    }
                }
                for (var l in arr2) {
                    if (arr2[l] == 'ן') {
                        arr2[l] = 'נ'
                    }
                    if (arr2[l] == 'ץ') {
                        arr2[l] = 'צ'
                    }
                    if (arr2[l] == 'ף') {
                        arr2[l] = 'פ'
                    }
                    if (arr2[l] == 'ם') {
                        arr2[l] = 'מ'
                    }
                    if (arr2[l] == 'ך') {
                        arr2[l] = 'כ'
                    }
                }
                if (JSON.stringify(arr1) == JSON.stringify(arr2)) {
                    result.push(afterWord2[i][0].numWord[0])
                    result.push(afterWord2[i][0].numWord[1])
                    continue
                }
            }
        }

        if (countBeforeWord[i].length == countKtiv[i].length) {
            var array1 = ktiv[i].map(a => {
                if (a.letterType == 1) {
                    return a.Letterktiv
                }
            }).sort()
            var array2 = beforeWord[i].map(a => {
                if (a.letterType == 1) {
                    return a.Letterktiv
                }
            }).sort()
            var arr1 = array1.filter((el) => {
                return el != undefined
            })
            var arr2 = array2.filter((el) => {
                return el != undefined
            })
            if (JSON.stringify(arr1) == JSON.stringify(arr2)) {
                result.push(beforeWord[i][0].numWord)
                continue
            }
            for (var l in arr1) {
                if (arr1[l] == 'ן') {
                    arr1[l] = 'נ'
                }
                if (arr1[l] == 'ץ') {
                    arr1[l] = 'צ'
                }
                if (arr1[l] == 'ף') {
                    arr1[l] = 'פ'
                }
                if (arr1[l] == 'ם') {
                    arr1[l] = 'מ'
                }
                if (arr1[l] == 'ך') {
                    arr1[l] = 'כ'
                }
            }
            for (var l in arr2) {
                if (arr2[l] == 'ן') {
                    arr2[l] = 'נ'
                }
                if (arr2[l] == 'ץ') {
                    arr2[l] = 'צ'
                }
                if (arr2[l] == 'ף') {
                    arr2[l] = 'פ'
                }
                if (arr2[l] == 'ם') {
                    arr2[l] = 'מ'
                }
                if (arr2[l] == 'ך') {
                    arr2[l] = 'כ'
                }
            }
            if (JSON.stringify(arr1) == JSON.stringify(arr2)) {
                result.push(beforeWord[i][0].numWord)
                continue
            }

        }

        if (countBeforeWord[i].length < countKtiv[i].length) {
            if (countBeforeWord2[i].length == countKtiv[i].length) {
                var array1 = ktiv[i].map(a => {
                    if (a.letterType == 1) {
                        return a.Letterktiv
                    }
                }).sort()
                var array2 = beforeWord2[i].map(a => {
                    if (a.letterType == 1) {
                        return a.Letterktiv
                    }
                }).sort()
                var arr1 = array1.filter((el) => {
                    return el != undefined
                })
                var arr2 = array2.filter((el) => {
                    return el != undefined
                })
                if (JSON.stringify(arr1) == JSON.stringify(arr2)) {
                    result.push(beforeWord2[i][0].numWord[0])
                    result.push(beforeWord2[i][0].numWord[1])
                    continue
                }
                for (var l in arr1) {
                    if (arr1[l] == 'ן') {
                        arr1[l] = 'נ'
                    }
                    if (arr1[l] == 'ץ') {
                        arr1[l] = 'צ'
                    }
                    if (arr1[l] == 'ף') {
                        arr1[l] = 'פ'
                    }
                    if (arr1[l] == 'ם') {
                        arr1[l] = 'מ'
                    }
                    if (arr1[l] == 'ך') {
                        arr1[l] = 'כ'
                    }
                }
                for (var l in arr2) {
                    if (arr2[l] == 'ן') {
                        arr2[l] = 'נ'
                    }
                    if (arr2[l] == 'ץ') {
                        arr2[l] = 'צ'
                    }
                    if (arr2[l] == 'ף') {
                        arr2[l] = 'פ'
                    }
                    if (arr2[l] == 'ם') {
                        arr2[l] = 'מ'
                    }
                    if (arr2[l] == 'ך') {
                        arr2[l] = 'כ'
                    }
                }
                if (JSON.stringify(arr1) == JSON.stringify(arr2)) {
                    result.push(beforeWord2[i][0].numWord[0])
                    result.push(beforeWord2[i][0].numWord[1])
                    continue
                }
            }
        }
    }

    return result
}

module.exports = { checkKtiv2 }
