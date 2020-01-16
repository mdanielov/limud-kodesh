var fs = require('fs')


fs.readdir('../../JsonFiles', (err, dataTxt) => {
    if (err) throw err;
    for (var txt in dataTxt) {
        var data = fs.readFileSync(`../../JsonFiles/${dataTxt[txt]}`)
        

        var newdata = JSON.parse(data)

        var file_no_extension = dataTxt[txt].replace(/\.[^\.]+$/, '')

        var result = [];

        for (var i in newdata) {
            result.push([newdata[i]]);

        }

        var result2 = []

        var stmt = '';

        var indice = false;

        for (var i in result) {

            for (var a in result[i]) {

                for (var e in result[i][a]) {

                    for (var z in result[i][a][e]) {
                        
                        removeSpaceInSquareBrackets = result[i][a][e][z].replace(' ]',']')
                        correctString = removeSpaceInSquareBrackets.replace(' ]',']')

                        var numberLineChapter= result[i][a][e].length -1
                        result2.push(correctString.split(','))
                        var sentence = correctString.split(' ');
                        
                        

                        for (var w in sentence) {
                            if (sentence[w] == '(פ)') {
                                continue
                            }
                            if (sentence[w] == '(ס)') {
                                continue
                            }
                            if (sentence[w].match(/^[־א-ת]+$/) != null){
                                stmt += `<Word Book='${file_no_extension}' Chapter='${Number(e) + 1}' Verse='${Number(z) + 1}' WordSequence='${parseInt(w) + 1}' Kri='true'>${sentence[w]}</Word>${'\r'}`
                                continue
                            }
                            if(sentence[w].match(/\[.+\]/)){
                                stmt += `<Word Book='${file_no_extension}' Chapter='${Number(e) + 1}' Verse='${Number(z) + 1}' WordSequence='${parseInt(w) + 1}' Ktiv='true'>${sentence[w]}</Word>${'\r'}`
                                continue 
                            }
                            if(w == sentence.length-1 && z == numberLineChapter && indice == false){
                                stmt += `<Word Book='${file_no_extension}' EndParashaAfterWord='true' Chapter='${Number(e) + 1}' Verse='${Number(z) + 1}' WordSequence='${parseInt(w) + 1}'>${sentence[w]}</Word>${'\r'}`
                                continue
                            }
                            if(z == 0 && w == 0 && indice == false){
                                stmt += `<Word Book='${file_no_extension}' StartParashaBeforeWord='true' Chapter='${Number(e) + 1}' Verse='${Number(z) + 1}' WordSequence='${parseInt(w) + 1}'>${sentence[w]}</Word>${'\r'}`
                                continue
                            }
                            if (w == sentence.length - 2 && w == sentence.indexOf('(פ)') - 1) {
                                stmt += `<Word Book='${file_no_extension}' EndParashaAfterWord='true' Chapter='${Number(e) + 1}' Verse='${Number(z) + 1}' WordSequence='${sentence.length - 1}'>${sentence[w]}</Word>${'\r'}`
                                indice = true;
                                continue
                            }
                            if (w == sentence.length - 2 && w == sentence.indexOf('(ס)') - 1) {
                                stmt += `<Word Book='${file_no_extension}' EndParashaAfterWord='true' Chapter='${Number(e) + 1}' Verse='${Number(z) + 1}' WordSequence='${sentence.length - 1}' >${sentence[w]}</Word>${'\r'}`
                                indice = true;
                                continue
                            }
                            if(w == 0 && indice == true){
                                stmt += `<Word Book='${file_no_extension}' StartParashaBeforeWord='true' Chapter='${Number(e) + 1}' Verse='${Number(z) + 1}' WordSequence='${parseInt(w) + 1}' IsParashaPtuchah='true' >${sentence[w]}</Word>${'\r'}`
                                indice = false;
                                continue
                            }
                            else {
                                stmt += `<Word Book='${file_no_extension}' Chapter='${1 + parseInt(e)}' Verse='${parseInt(z) + 1}' WordSequence='${parseInt(w) + 1}' >${sentence[w]}</Word>${'\r'}`

                            }
                        }
                    }

                }
            }
        }



        var FinalStatement = `<Tanakh>${'\r'}${stmt}</Tanakh>`
        var file = dataTxt[txt].replace(/\.[^\.]+$/, '.xml');

        fs.writeFile(`../../XMLFilesProcessed/${file}`, FinalStatement, (err) => {
            if (err) throw err
        })
    }
});



