using Microsoft.VisualStudio.TestTools.UnitTesting;
using HebrewTexts.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HebrewTexts.DAL.Tests
{
    [TestClass()]
    public class ContentGroupTests
    {
        [TestMethod()]
        public void MoveNextTest()
        {

            var context = new HebrewTextsEntities(HebrewTextsEntities.HebrewTextsConnectionStrings.Default);
            //סוגים של גרופים ספר פרק ופסוק
            var groupTypeBook = context.GroupsAndDividingTypes.Where(g => g.KeyWordIndex == "Book").First().ID;
            var groupTypeChapter = context.GroupsAndDividingTypes.Where(g => g.KeyWordIndex == "Chapter").First().ID;
            var groupTypeVerse = context.GroupsAndDividingTypes.Where(g => g.KeyWordIndex == "Verse").First().ID;

            //הגרופ של ספר בראשית
            var bereshitGroup = context.ContentGroups.First(g => g.GroupType == groupTypeBook && g.GroupName == "בראשית");
            //הפרק האחרון בספר בראשית
            var lastChapterInBereshit = context.ContentGroups.Where(g => g.GroupType == groupTypeChapter && g.ParentGroupID == bereshitGroup.GroupID).OrderByDescending(g => g.SequenceNumber).First();
            //הפסוק האחרון בספר בראשית
            var lastVerseInBereshit = context.ContentGroups
                .Where(g =>
                g.GroupType == groupTypeVerse && g.ParentGroupID == lastChapterInBereshit.GroupID)
                .OrderByDescending(g => g.SequenceNumber)
                .First();

            //הגרופ של ספר שמות
            var shmotGroup = context.ContentGroups.First(g => g.GroupType == groupTypeBook && g.GroupName == "שמות");
            //הפרק הראשון בספר שמות
            var firstChapterInShmot = context.ContentGroups.Where(g => g.GroupType == groupTypeChapter && g.ParentGroupID == shmotGroup.GroupID).OrderBy(g => g.SequenceNumber).First();
            //הפסוק הראשון בפרק הראשון בספר שמות
            var firstVerseInShmot = context.ContentGroups
                .Where(g =>
                g.GroupType == groupTypeVerse && g.ParentGroupID == firstChapterInShmot.GroupID)
                .OrderBy(g => g.SequenceNumber)
                .First();
            //בודק האם מדלג מהפסוק האחרון של בראשית לפסוק הראשון של שמות
            var verseResult = lastVerseInBereshit.MoveNext(context: context);
            Assert.AreEqual(verseResult.GroupID, firstVerseInShmot.GroupID);
            //כעת בודק אם מדלג מהפרק האחרון של בראשית לפרק הראשון של שמות
            var chapterResult = lastChapterInBereshit.MoveNext(context: context);
            Assert.AreEqual(chapterResult.GroupID, firstChapterInShmot.GroupID);
            //כעת בודק אם מדלג מספר בראשית לספר שמות
            var bookResult = bereshitGroup.MoveNext(context: context);
            Assert.AreEqual(bookResult.GroupID, shmotGroup.GroupID);

            //בדיקה בספר דברים האם הוא יודע לדלג לספר יהושע
            var dvarimGroup = context.ContentGroups.First(g => g.GroupType == groupTypeBook && g.GroupName == "דברים");
            var yehoshuaGroup = context.ContentGroups.First(g => g.GroupType == groupTypeBook && g.GroupName == "יהושע");
            Assert.AreEqual(dvarimGroup.MoveNext(context: context).GroupID, yehoshuaGroup.GroupID);


            //בדיקה בספר שמואל ומלכים הואיל ויש שם כמה לוולים לא שגרתיים אנו מעוניינים לבדוק אותם
            //הגרופ של ספר שופטים
            var shoftimGroup = context.ContentGroups.First(g => g.GroupType == groupTypeBook && g.GroupName == "שופטים");
            var shmuelAGroup = context.ContentGroups.First(g => g.GroupType == groupTypeBook && g.GroupName == "שמואל א");
            var nextAfterShoftimResult = shoftimGroup.MoveNext(context: context);
            Assert.AreEqual(shmuelAGroup.GroupID, nextAfterShoftimResult.GroupID);


            //בדיקה בספר שמואל ב האם הוא יודע להחזיר את ספר מלכים א למרות ששמואל מפריד ביניהם
            var shmuelBGroup = context.ContentGroups.First(g => g.GroupType == groupTypeBook && g.GroupName == "שמואל ב");
            var melachimAGroup = context.ContentGroups.First(g => g.GroupType == groupTypeBook && g.GroupName == "מלכים א");

            var nextAfterShmuelBResult = shmuelBGroup.MoveNext(context: context);

            Assert.AreEqual(melachimAGroup.GroupID, nextAfterShmuelBResult.GroupID);


            //בדיקה בספר מלכים ב האם הוא יודע להחזיר את ספר ישעיהו למרות שמלכים ב מופרד על ידי גרופ של מלכים
            var melachimBGroup = context.ContentGroups.First(g => g.GroupType == groupTypeBook && g.GroupName == "מלכים ב");
            var yeshayahuGroup = context.ContentGroups.First(g => g.GroupType == groupTypeBook && (g.GroupName == "ישעיהו" || g.GroupName == "ישעיה"));

            var nextAfterMelachimBResult = melachimBGroup.MoveNext(context: context);

            Assert.AreEqual(yeshayahuGroup.GroupID, nextAfterMelachimBResult.GroupID);



        }

        [TestMethod()]
        public void GetContentTest()
        {
            var context = new HebrewTextsEntities(HebrewTextsEntities.HebrewTextsConnectionStrings.Default);
            var sqlGenerated = new List<string>();
            context.Database.Log = s => sqlGenerated.Add(s);

            var grp = context.ContentGroups.Find(24193);
            //var result = grp.GetContent(context: context).ToList();

            //כעת חיפוש על מציאת כל ספר בראשית
            var groupTypeBook = context.GroupsAndDividingTypes.Where(g => g.KeyWordIndex == "Book").First().ID;
            grp = context.ContentGroups.First(g => g.GroupType == groupTypeBook && g.GroupName == "בראשית");
            var result = grp.GetContent(context: context).ToList();


        }
    }
}