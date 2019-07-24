using HebrewTexts.DAL;
using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;
using MongoDB.Driver;
using MongoDB.Driver.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HebrewTexts.Import.EntitiesToImport.TalmudBavli.RawImport
{
    public class ImportFromSefaria
    {
        public void ImportAll()
        {
            var client = new MongoClient();
            var dbSefaria = client.GetDatabase("sefaria");
            var texts = dbSefaria.GetCollection<SefariaText>("texts");
            var resultOfTexts = texts.AsQueryable<SefariaText>().Where(t => t.language == "he");
           
            
            var bavliTitle = resultOfTexts.Where(t =>
            // t.versionTitleInHebrew.Contains("תלמוד בבלי (ויקיטקסט)")
            t.title.Contains("Malbim")
            // || t.versionTitleInHebrew.Contains("מדרש")
            ).Select(t =>t.versionTitleInHebrew).Distinct().ToList();
            var allBavlies = resultOfTexts.Where(t => bavliTitle.Contains(t.versionTitleInHebrew)).ToList();
            var masechtot = new List<MasechetTalmudBavli>();
            foreach (var masechet in allBavlies)
            {
                var currentMasechet = new MasechetTalmudBavli();
                currentMasechet.SequenceNumber = 1;
                currentMasechet.Name = masechet.title;
                masechtot.Add(currentMasechet);
                // עוברים עמוד עמוד
                for (int amudPosition = 2; amudPosition < masechet.chapter.Count(); amudPosition++)
                {
                    var dafNum = (amudPosition / 2) + 1;
                    // כעת יש ליצור עמוד בתלמוד בבלי ולדחוף לתוכו שורות
                    var currentAmud = new AmudTalmudBavli();
                    currentAmud.Masechet = currentMasechet;
                    currentAmud.DafNumber = dafNum;
                    currentAmud.AmudNumber = (amudPosition % 2) + 1;
                    var currentRows = new List<RowInTalmudBavli>();
                    var AmudInMongo = masechet.chapter.ElementAt(amudPosition).ToList();
                    for (int rNum = 0; rNum < AmudInMongo.Count; rNum++)
                    {
                        var row = new RowInTalmudBavli();
                        row.Content = AmudInMongo[rNum];
                        row.InAmud = currentAmud;
                        row.SequenceNumber = rNum;
                        currentRows.Add(row);
                    }
                    
                    currentAmud.Rows = currentRows;
                    currentMasechet.Amudim.Add(currentAmud);
                }
            }

            var invalid = masechtot.Where(m => !m.IsValid).ToList();

        }


        [BsonIgnoreExtraElements]
        class SefariaText
        {
            public object _id { get; set; }
            // public IEnumerable<IEnumerable<string>> chapter { get; set; }
            public dynamic chapter { get; set; }

            public string status { get; set; }
            public string versionTitle { get; set; }
            public string language { get; set; }
            public string title { get; set; }
            public string versionSource { get; set; }
            public string versionTitleInHebrew { get; set; }
            public string method { get; set; }
            public string versionNotes { get; set; }
            public dynamic license { get; set; }
            public dynamic digitizedBySefaria { get; set; }
            public dynamic priority { get; set; }
        }


        public void ImportMalbimBeurHamilot() {
            var client = new MongoClient();
            var dbSefaria = client.GetDatabase("sefaria");
            var texts = dbSefaria.GetCollection<SefariaText>("texts").AsQueryable();
            var result = texts.Where(t => t.language=="he" && t.title.Contains("Malbim Beur Hamilot")).ToList();  
        }


        public void ImportOnkelos()
        {

            var client = new MongoClient();
            var dbSefaria = client.GetDatabase("sefaria");
            var texts = dbSefaria.GetCollection<SefariaText>("texts").AsQueryable();
            var result = texts.Where(t => t.language == "he" && t.title.Contains("Onkelos") && t.title.Contains("Leviticus")).ToList();
            List<dynamic> text1 = result.First().chapter;
            List<dynamic> text = result.Where(t => t.versionTitle.Contains("Targum Onkelos, vocalized according to the Yemenite Taj")).First().chapter;
            var totalVerses = text1.SelectMany(t => (List<dynamic>) t).ToList();
            var db = new DB(AppUser.GetForTests());
            var rootBook = db.Entities.ContentGroups.Where(g => g.KeyWordIndex == "Onkelos").First();
            var OnkelosBereshit = db.Entities.ContentGroups.Where(g => g.KeyWordIndex == "OnkelosBereshit").First();

            return;
            var newGroups = new List<ContentGroup>();

            var groupTypeChapter = db.Entities.GroupsAndDividingTypes.Where(g => g.KeyWordIndex == "Chapter").Select(g=> g.ID).First();
            var groupTypeVerse = db.Entities.GroupsAndDividingTypes.Where(g => g.KeyWordIndex == "Verse").Select(g=> g.ID).First();
            var newContents = new List<MainContent>();
            for (int chapterNum = 0; chapterNum < text.Count; chapterNum++)
            {
                var currentChapterGroup = new ContentGroup {
                    RootGroupID = rootBook.GroupID,
                    GroupType = groupTypeChapter,
                    SequenceNumber = chapterNum + 1,
                    ParentGroupID = OnkelosBereshit.GroupID,
                };
                db.Entities.ContentGroups.Add(currentChapterGroup);
                db.Entities.SaveChanges();
                newGroups.Add(currentChapterGroup);
                for (int VerseNum = 0; VerseNum < text[chapterNum].Count; VerseNum++)
                {
                    var CurrentVerseGroup = new ContentGroup
                    {
                        RootGroupID = rootBook.GroupID,
                        GroupType = groupTypeVerse,
                        SequenceNumber = VerseNum + 1,
                        ParentGroupID = currentChapterGroup.GroupID
                    };
                    db.Entities.ContentGroups.Add(CurrentVerseGroup);
                    db.Entities.SaveChanges();
                    newGroups.Add(CurrentVerseGroup);
                    string currentText = text[chapterNum][VerseNum];
                    var allWords = currentText.Split(' ').ToList();
                    // עכשיו עוברים על הטקסט ומכניסים כל אחד למיין קונטנט
                    for (int i = 0; i < allWords.Count; i++)
                    {
                        var currentMainContent = new MainContent { GroupID = CurrentVerseGroup.GroupID, Content = allWords[i],
                            RootGroupID =rootBook.GroupID,SequenceNumber=i+1 };
                        db.Entities.MainContents.Add(currentMainContent);
                        newContents.Add(currentMainContent);
                    }
                    db.Entities.SaveChanges();
                }
            }


        }


        public void ImportToRawContent() {
            var client = new MongoClient();
            var dbSefaria = client.GetDatabase("sefaria");
            var texts = dbSefaria.GetCollection<SefariaText>("texts").AsQueryable();
            var result = texts.Where(t => t.language == "he" && t.title.Contains("Onkelos") && t.title.Contains("Deuteronomy")).ToList();
            // var result = texts.Where(t => t.language == "he" && t.title.Contains("Deuteronomy") && t.versionTitle.Contains("Tanach with Nikkud")).ToList();
            List<dynamic> text1 = result.Last().chapter;
            var totalVerses = text1.SelectMany(t => (List<dynamic>)t).ToList();
            var newContents = new List<RawImportStuff>();
            for (int i = 0; i < text1.Count; i++)
            {
                var groupSecenceLevel1 = i + 1;
                for (int v = 0; v < text1[i].Count; v++)
                {
                    var groupSecwneceLevel2 = v + 1;
                    var content = text1[i][v];
                    var rawImport = new RawImportStuff
                    {
                        Content = content,
                        GroupSequenceLevel1 = groupSecenceLevel1,
                        GroupSequenceLevel2 = groupSecwneceLevel2,
                        Source = "Onkelos Deuteronomy"
                    };
                    newContents.Add(rawImport);
                }
            }
            var db = new DB(AppUser.GetForTests());
            db.Entities.RawImportStuffs.AddRange(newContents);
            db.Entities.SaveChanges();
        }

        public void ImportFromRawTable() {

            var db = new DB(AppUser.GetForTests());
            var rawPsukim = db.Entities.RawImportStuffs.ToList();

            var bookKey = "Devarim";
            var groupTypeChapter = db.Entities.GroupsAndDividingTypes.Where(g => g.KeyWordIndex == "Chapter")
                .Select(g => g.ID).First();
            var groupTypeVerse = db.Entities.GroupsAndDividingTypes.Where(g => g.KeyWordIndex == "Verse")
                .Select(g => g.ID).First();
            var rootGroup = db.Entities.ContentGroups.Where(g => g.KeyWordIndex == "Onkelos").First();
            var bookIndex = $"Onkelos.{bookKey}";
            var currentBook = db.Entities.ContentGroups.Where(g => g.KeyWordIndex == bookIndex).First();


            var prakim = rawPsukim.Select(p => p.GroupSequenceLevel1).Distinct().ToList();
            var newPrakim = new List<ContentGroup>();

            foreach (var perekSequence in prakim)
            {
                var newPerek = new ContentGroup
                {
                    SequenceNumber = perekSequence,
                    RootGroupID=rootGroup.GroupID,
                    ParentGroupID = currentBook.GroupID, 
                    GroupType=groupTypeChapter,
                    KeyWordIndex = $"Onkelos.{bookKey}.{perekSequence}"
                };
                newPrakim.Add(newPerek);
            }

            db.Entities.ContentGroups.AddRange(newPrakim);
            db.Entities.SaveChanges();


            var newPsukim = new List<ContentGroup>();
            foreach (var item in rawPsukim)
            {
                var perekParent = newPrakim.Where(p => p.SequenceNumber == item.GroupSequenceLevel1).First();
                var newPasuk = new ContentGroup {
                    SequenceNumber = item.GroupSequenceLevel2,
                    RootGroupID=currentBook.GroupID,
                    ParentGroupID = perekParent.GroupID,
                    GroupType= groupTypeVerse,
                    KeyWordIndex = $"Onkelos.{bookKey}.{perekParent.SequenceNumber}.{item.GroupSequenceLevel2}"
                };
                newPsukim.Add(newPasuk);
            }
            db.Entities.ContentGroups.AddRange(newPsukim);
            db.Entities.SaveChanges();
            var newContents = new List<MainContent>();
            foreach (var pasuk in rawPsukim)
            {
                var words = pasuk.Content.Split(' ');
                var currentPasukGroup = newPsukim.First(p => p.KeyWordIndex == $"Onkelos.{bookKey}.{pasuk.GroupSequenceLevel1}.{pasuk.GroupSequenceLevel2}");
                for (int i = 0; i < words.Length; i++)
                {
                    var currentMainContent = new MainContent
                    {
                        GroupID = currentPasukGroup.GroupID,
                        Content = words[i],
                        SequenceNumber =i+1,
                        RootGroupID = rootGroup.GroupID
                    };
                    newContents.Add(currentMainContent);
                }
            }
            db.Entities.MainContents.AddRange(newContents);
            db.Entities.SaveChanges();
            
        }
    }
}
