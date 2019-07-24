// using MatarahExtensions;
using MatarahExtensions;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HebrewTexts.DAL.Persistence.Repositories
{
    public class GroupsRepository
    {
        public GroupsRepository()
        {
            context = new HebrewTextsEntities(connetion: HebrewTextsEntities.HebrewTextsConnectionStrings.Default);
        }

        HebrewTextsEntities context;

        public ContentGroup GetByName(string name)
        {
            return context.ContentGroups.FirstOrDefault(g => g.GroupName == name);
        }

        /// <summary>
        /// להכניס תוכן חדש בתוך גרופ קיים
        /// מוחק את כל התוכן הקודם אם קיים ומכניס בתוכו את התוכן החדש
        /// כל מילה היא רשומת תוכן בדטה בייס ולכן יש להכניס תכנים תמיד בגרופים הכי קטנים שאפשר 
        /// בכדי לאפשר לנהל גרופים נוספים חופפים
        /// </summary>
        /// <param name="group"></param>
        /// <param name="innerTextContent"></param>
        public void SetNewContent(ContentGroup group, string innerTextContent)
        {

        }

        #region FindGroups

        /// <summary>
        /// מספק את קבוצת השורש לפי מזהה קבוצה כלשהי
        /// </summary>
        /// <param name="groupID">הכנס כאן מזהה של קבוצה כלשהי</param>
        /// <returns>מחזיר מזהה של קבוצת שורש</returns>
        public int FindRootByGroupID(int groupID)
        {

            if (groupsAndRoots.ContainsKey(groupID))
            {
                return groupsAndRoots[groupID];
            }

            var db = context; // new HebrewTextsEntities(connetion: HebrewTextsEntities.HebrewTextsConnectionStrings.Default);

            var groups = new List<ContentGroup>();
            ContentGroup currentGroup = db.ContentGroups.Find(groupID);
            if (currentGroup == null)
            {
                throw new Exception("מזהה קבוצה לא חוקי הוכנס כפרמטר");
            }


            groups.Add(currentGroup);

            int counter = 0;
            int result = 0;
            //מטפס במעלה העץ כל עוד הוא מוצא שישנו אבא לקבוצה הנוכחית
            //על מנת להגן מפני באגים ולא להיכנס ללולאה אינסופית עשינו כאן מונה שמגביל ל 100 את הטיפוס במעלה העץ
            while (currentGroup.ParentGroupID != null)
            {
                counter++;
                if (counter > 100)
                {
                    throw new Exception("קינון עמוק מידי עברנו מאה צעדים בלולאה, משהו לא הגיוני כאן!!!");
                }
                //אם מצאנו את האבא בדיקשנרי וכבר יש לו שורש אין טעם להמשיך אולם נשמור את מה שכבר משכנו ממסד הנתונים כאן בקאש
                if (groupsAndRoots.ContainsKey((int)currentGroup.ParentGroupID))
                {
                    result = groupsAndRoots[(int)currentGroup.ParentGroupID];
                    groupsAndRoots.Merge(groups.Select(g => g.GroupID).ToDictionary(g => g, g => result));
                    return result;
                }
                //מטפסים על מנת למצוא את האבא של הגרופ הנוכחי
                var parentOfCurrentGroup = db.ContentGroups.Find(currentGroup.ParentGroupID);
                if (parentOfCurrentGroup == null)
                {
                    throw new Exception("מזהה לא חוקי הוגדר כמזהה אב של גרופ במסד הנתונים לא נמצאה רשומה תואמת, המזהה הוא: " + currentGroup.ParentGroupID);
                }
                currentGroup = parentOfCurrentGroup;
                groups.Add(currentGroup);
            }

            result = currentGroup.GroupID;
            //מוסיף למילון של הקאש את כל מה שמצאנו כעת
            groupsAndRoots.Merge(groups.Select(g => g.GroupID).ToDictionary(g => g, g => result));

            return result;
        }

        /// <summary>
        /// דיקשנרי סטטי עבור גישה למה שכבר נאסף באמצעות הדטה בייס
        /// זה בעצם ניהול קאשינג של קבוצות והשורשים שלהם
        /// בצד של המפתח נמצא הגרופ ובצד של הערך נמצא הגרופ השורש
        /// </summary>
        static Dictionary<int, int> groupsAndRoots { get; set; } = new Dictionary<int, int>();

        


            #endregion


        }
}
