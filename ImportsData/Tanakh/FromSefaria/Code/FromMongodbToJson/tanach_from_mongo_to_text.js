var fs= require('fs')
var MongoClient = require('mongodb').MongoClient



MongoClient.connect('mongodb://localhost:27017', (err, client) => {

  var db = client.db('sefaria');
  var cursor = db.collection('texts').find({title:'', language:'he', versionTitle:'Tanach with Ta\'amei Hamikra'}).project({chapter:1, _id:0})
  function iterateFunc(doc) {
    fs.writeFile('./all_tanach_in_text/Nehemiah.txt',JSON.stringify(doc,null, 2));
 }
  cursor.forEach(iterateFunc)
}); 
