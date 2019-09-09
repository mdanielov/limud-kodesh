var fs = require('fs')
var check = require('./comparison')

var checkKtiv = check.checkKtiv2

// fs.readdir('./tanach-to-json' , (err, dataTxt) => {
//     if (err) throw err;
//     for (var txt in dataTxt) {
//         var data = fs.readFileSync(`C:\\Test-tanach\\python-api\\test-json\\tanach-to-json\\${dataTxt[txt]}`,'utf-8')
        var data = fs.readFileSync(`C:\\Test-tanach\\python-api\\test-json\\test.json`,'utf-8')

        var newdata = JSON.parse(data)

        // var file_no_extension = dataTxt[txt].replace(/\.[^\.]+$/, '')
        var file_no_extension = 'test'


        var result = [];

        for (var i in newdata) {
            result.push([newdata[i]]);

        }

        var result2 = []

        var stmt = '';

        for (var i in result) {

            for (var a in result[i]) {

                for (var e in result[i][a]) {

                    for (var z = 0; z < (result[i][a][e].length); z++) {
                        
                        var numberLineChapter = result[i][a][e].length
                        result2.push(result[i][a][e][z].split(','))
                        var sentence = result[i][a][e][z].split(' ');

                        var n = 1;

                        for (var w=0 ; w <= sentence.length -1 ; w++) {

                            if(w == sentence.length -1  && z == numberLineChapter - 1 && checkKtiv(sentence) != undefined && (w ==checkKtiv(sentence)[0] || w == checkKtiv(sentence)[1] || w == checkKtiv(sentence)[2] || w == checkKtiv(sentence)[3])){
                                stmt += `<Word Book='${file_no_extension}' EndParashaAfterWord='true' Chapter='${Number(e) + 1}' Verse='${Number(z) + 1}' WordSequence='${n}' Kri='true'>${sentence[w]}</Word>${'\n\r'}`
                                n += 1;
                                continue
                            }
                            if (w == sentence.length -1  && z == numberLineChapter - 1) {
                                stmt += `<Word Book='${file_no_extension}' EndParashaAfterWord='true' Chapter='${Number(e) + 1}' Verse='${Number(z) + 1}' WordSequence='${n}'>${sentence[w]}</Word>${'\n\r'}`
                                n += 1;
                                continue
                            }
                            if (z == 0 && w == 0) {
                                stmt += `<Word Book='${file_no_extension}' StartParashaBeforeWord='true' Chapter='${Number(e) + 1}' Verse='${Number(z) + 1}' WordSequence='${n}'>${sentence[w]}</Word>${'\n\r'}`
                                n += 1;
                                continue
                            }
                            if(checkKtiv(sentence) != undefined && (w ==checkKtiv(sentence)[0] || w == checkKtiv(sentence)[1] || w == checkKtiv(sentence)[2] || w == checkKtiv(sentence)[3])){
                                stmt += `<Word Book='${file_no_extension}' Chapter='${1 + parseInt(e)}' Verse='${parseInt(z) + 1}' WordSequence='${n}' Kri='true' >${sentence[w]}</Word>${'\n\r'}`
                                n += 1;
                                continue
                            }
                            else {
                                if (sentence[w].match(/^[א-ת]+$/) != null) {
                                    stmt += `<Word Book='${file_no_extension}' Chapter='${1 + parseInt(e)}' Verse='${parseInt(z) + 1}' WordSequence='${n}' Ktiv='true' >${sentence[w]}</Word>${'\n\r'}`
                                    n += 1;
                                    continue
                                }
                                
                                stmt += `<Word Book='${file_no_extension}' Chapter='${1 + parseInt(e)}' Verse='${parseInt(z) + 1}' WordSequence='${n}' >${sentence[w]}</Word>${'\n\r'}`
                                n += 1;
                            }
                        }
                    }

                }
            }
        }



        var FinalStatement = `<Tanakh>${'\n\r'}${stmt}</Tanakh>`
        // var file = dataTxt[txt].replace(/\.[^\.]+$/, '.xml');

        // fs.writeFile(`./tanach-to-xml/${file}`, FinalStatement, (err) => {
        //     if (err) throw err
        // })
        fs.writeFile(`./test.xml`, FinalStatement, (err) => {
            if (err) throw err
        })
//     }
// });



