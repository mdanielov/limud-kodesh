using HebrewTexts.DAL;
using HebrewTexts.DAL.Persistence.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HebrewTexts.Cleansing.GroupsAndContent
{
    /// <summary>
    /// תפקידה של מחלקה זו לדאוג לניקוי וטיוב של מיין קונטנט
    /// </summary>
    public class MainContentCleansing
    {
        /// <summary>
        /// מעדכן את הגרופ השורשי בטבלת
        /// MainContent
        /// </summary>
        public void UpdateRootGroupID()
        {
            var db = new HebrewTextsEntities(HebrewTextsEntities.HebrewTextsConnectionStrings.Default);

            //עובר על כל הרשומות הריקות על מנת למצוא להם את השורש
            var contents = db.MainContents.Where(c => c.RootGroupID == null).ToList();

            

            var repo = new GroupsRepository();

            foreach (var cntnt in contents)
            {
                cntnt.RootGroupID = repo.FindRootByGroupID(cntnt.GroupID);
            }
            db.SaveChanges();

        }

        /// <summary>
        /// מעדכן את הצומת האחרונה בגרופים בסדר רציף עקבי המתייחס לגרופ הראשי כלומר הצומת הראשי ביותר בעץ הגרופים
        /// משמעות הדבר שלדוגמא אם אנו מדברים על התנ"ך אזי כל פסוק יקבל מספור רציף ביחס לכל התנך
        /// הואיל והגרופ של תנך הוא הגרופ הראשי ביותר ואילו הגרופ פסוק הוא הקטן ביותר הרי שעלינו למספר את הפסוקים יחסית לתנך כולו
        /// </summary>
        /// <param name="rootGroupID"></param>
        public void UpdateSequenceNumberLastNodeByRootGroup(int rootGroupID)
        {
            var db = new HebrewTextsEntities(HebrewTextsEntities.HebrewTextsConnectionStrings.Default);


            //מתחילים לספור מהשורש של הגרופ וכך בונים ספירה לפי הסדר של כל גרופ עד לגרופ הרלוונטי

            //הספירה הראשונה ממוספרת בספרה אחת
            var currentnum = db.MainContents
                .Where(c => c.RootGroupID == rootGroupID && c.SequenceNumberByRootGroup != null)
                .OrderByDescending(c => c.SequenceNumberByRootGroup)
                .FirstOrDefault()?.SequenceNumberByRootGroup;

            var firtsNum = (currentnum ?? 0) + 1;
            currentnum = firtsNum;
            ContentGroup currentGroup;
            //עלינו להשיג את הראשון בתור וממנו להתקדם הלאה
            if (firtsNum == 1)
            {
                currentGroup = db.ContentGroups.Find(rootGroupID);
                while (!db.MainContents.Any(c => c.GroupID == currentGroup.GroupID))
                {
                    var child = currentGroup.FirstChild(context: db);
                    if (child == currentGroup)
                    {
                        throw new Exception("לא נמצא התוכן הראשון");
                    }
                    currentGroup = child;
                }

            }
            else
            {
                var lastGroupID = db.MainContents.Where(c => c.RootGroupID == rootGroupID && c.SequenceNumberByRootGroup == (firtsNum - 1)).First().GroupID;
                currentGroup = db.ContentGroups.Find(lastGroupID).MoveNext(context: db);
            }
            //TODO להשלים את הפונקציה
            for (int i = 0; i < 5; i++)
            {
                var dbUpdate = new HebrewTextsEntities(HebrewTextsEntities.HebrewTextsConnectionStrings.Default);

                var contentForUpdate = dbUpdate.MainContents.Where(c => c.GroupID == currentGroup.GroupID).OrderBy(c => c.SequenceNumber);
                foreach (var content in contentForUpdate)
                {
                    content.SequenceNumberByRootGroup = currentnum;
                    currentnum++;
                }

                dbUpdate.SaveChanges();

                currentGroup = currentGroup.MoveNext(context: db);
            }

        }


        /// <summary>
        /// מעדכן את השדה 
        /// NextGroupIDInLevel
        /// שהוא בעצם אמור לתת את אותו שירות של הפונקציה 
        /// MoveNext
        /// אבל אחרי עדכון במסד הנתונים תהיה לנו אפשרות הרבה יותר מהירה לקבל את הבא בתור
        /// </summary>
        /// <param name="groupIDStart">מאיזה גרופ להתחיל</param>
        /// <param name="startInMiddleLevel">האם להתחיל באמצע הלוול 
        /// כלומר לדוגמא אם עשינו כבר חצי ואנחנו מעוניינים להמשיך את החצי הבא נוכל לציין לו את אותו אחד שכבר הוא באמצע במקום להתחיל הכל מההתחלה
        /// כגון אם כבר עשינו חצי תנ"ך בפסוקים ועכשיו רוצים להמשיך, נוכל לציין את הפסוק האחרון שבו יש ציון לפסוק הבא והוא ימשיך אותו הלאה
        /// </param>
        public void UpdateNextGroupIDInLevel(int groupIDStart, bool startInMiddleLevel = false)
        {
            var context = new HebrewTextsEntities(HebrewTextsEntities.HebrewTextsConnectionStrings.Default);

            var firstGroup = context.ContentGroups.Find(groupIDStart);


            var currentParent = firstGroup.Parent(context: context);

            var currentGroup = firstGroup;

            //אם לא הייתה הכוונה להתחיל ממש מאותו אחד שצויין  אזי צריך להתחיל מהילד הראשון של ההורה הנ"ל
            if (!startInMiddleLevel)

            {
                currentGroup = currentParent.FirstChild(context: context);
            }

            var i = 1;
            while (currentGroup != currentParent)
            {
                if (i >= 2)
                {
                    break;
                }
                i++;

                //כעת מעדכן את כולם עד לילד האחרון

                ContentGroup nextGroup = currentGroup.MoveNext(context: context);
                var changes = 0;
                while (true)
                {

                    currentGroup.NextGroupIDInLevel = nextGroup.GroupID;
                    changes++;
                    //כל 100 שינויים הוא מעדכן את מסד הנתונים
                    if (changes >= 100 || currentGroup == nextGroup)
                    {
                        context.SaveChanges();
                        changes = 0;
                    }

                    if (currentGroup == nextGroup)
                        break;

                    currentGroup = nextGroup;
                    nextGroup = nextGroup.MoveNext(context: context);




                }



                currentParent = currentGroup.Parent(context: context).FirstChild(context: context);
                currentGroup = currentParent.FirstChild(context: context);
            }






        }


    }
}
