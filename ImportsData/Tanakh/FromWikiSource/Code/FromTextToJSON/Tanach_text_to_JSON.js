var fs = require("fs");

fs.readdir('./Tanach-TEXT', (err, dataTxt) => {
    if (err) throw err;

    for (var txt in dataTxt) {
        var data = fs.readFileSync(`./Tanach-TEXT/${dataTxt[txt]}`,'utf-8')
            if (err) throw err;
            var tabData = data.split('\n')
            var finalData = tabData.slice(0, tabData.length - 1)



            result = []

            for (var i in finalData) {
                result.push(finalData[i].split("׃"))
            }

            result2 = []

            result.filter((tab) => {
                return result2.push(tab.slice(Math.round((tab.length / 2) - 1), Math.round((tab.length / 2) - 1) * 2))
            })

            var result3 = [result2]

            var resultFinal = JSON.stringify(result3).replace(/"\s\s\s/g,'"').replace(/\s\s\s\s/g,'').replace(/"\s\s/g,'"').replace(/\s׀\s/g,"׀ ").replace(/־/g,"־ ").replace(/\s׆\s/g,"").replace(/׆\s/g,"").replace(/"\s/g,'"').replace(/"]/g,'"]\n\r')
            var file = dataTxt[txt].replace(/\.[^\.]+$/, '.json');
            

            fs.writeFile(`./Tanach_JSON/${file}`, resultFinal, (err) => {
                if (err) throw err
            })

    }
})