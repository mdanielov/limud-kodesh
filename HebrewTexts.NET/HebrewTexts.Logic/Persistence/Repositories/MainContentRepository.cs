using HebrewTexts.DAL;
using HebrewTexts.Logic.DTOs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HebrewTexts.Logic.Persistence.Repositories
{

    /// <summary>
    /// רפוזיטורי המטפל בתוכן ראשי
    /// </summary>
    public class MainContentRepository : RepositoryBase<MainContent>
    {
        /// <summary>
        /// בנאי המקבל יוזר
        /// </summary>
        /// <param name="user"></param>
        public MainContentRepository(AppUser user) : base(user)
        {

        }

        /// <summary>
        /// קבל רשימת תכנים לפי מזהה קבוצה
        /// </summary>
        /// <param name="groupID">מזהה קבוצה</param>
        /// <param name="take">כמה למשוך</param>
        /// <param name="skip">כמה לדלג עבור פייג'ינג</param>
        /// <returns></returns>
        public IEnumerable<MainContent> GetByGroupID(int groupID, int take = 1000, int skip = 0)
        {

            if (take < 0 || skip < 0)
            {
                throw new ArgumentException("arguments >>>take and >>>skip must be equal or greater than zero");
            }

            // עלינו לברר מיהו הגרופ הזה בהיררכייה והאם יש לו ילדים ונכדים ונינים
            // במידה ויש לו כאלו עלינו לבנות אסקיואל שאין כדוגמתו על מנת לחלץ את הטכסט משם
            var db = new DB(user: User);
            var hasContentDirectly = db.Entities.MainContents.Any(c => c.GroupID == groupID);

            if (hasContentDirectly)
            {
                return db.Entities.MainContents.Where(c => c.GroupID == groupID).OrderBy(c => c.SequenceNumber);
            }
            // אם הגענו הנה ייתכן שהגרופ שהתבקש הוא גרופ אלטרנטיבי המשמש כסופר גרופ
            // לדוגמא פרשת השבוע שהיא עשויה לחצות פרקים ופרקים חוצים אותה
            // יש פונקציה מיוחדת שמאחזרת גרופ אלטרנטיבי
            // אז הבה ונבדוק אם זה שייך לגרופ אלטרנטיבי
            if (db.Entities.ContentToAlternateGroups.Any(g=>g.GroupID==groupID))
            {
                return GetByAlternateGroup(groupID, take, skip);
            }

            // אם אין תוכן ישיר תחת הגרופ הזה או אז יש להתחיל במלאכת השירשור וההשתלשלות עד להגעה לכל התוכן הנדרש
            var isParent = db.Entities.ContentGroups.Any(g => g.ParentGroupID == groupID);
            // אם בשלב זה כבר מתברר שהוא איננו הורה יש לנו כאן שגיאה
            if (!isParent)
            {
                throw new Exception("מזהה קבוצה שנשלח איננו הורה ואין תוכן המשוייך אליו");
            }


            var counter = 1;
            var currentGroups = db.Entities.ContentGroups.Where(g => g.ParentGroupID == groupID).Select(g => g.GroupID).ToList();
            // יותר מעשרים שכבות לא סביר שקיים
            while (counter <= 20)
            {
                hasContentDirectly = db.Entities.MainContents.Any(c => currentGroups.Contains(c.GroupID));
                if (hasContentDirectly)
                {
                    break;
                }
                counter++;
                currentGroups = db.Entities.ContentGroups.Where(g => g.ParentGroupID != null && currentGroups.Contains(g.ParentGroupID ?? 0)).Select(g => g.GroupID)
                    .ToList();
            }
            // כאן מתחילים לבנות את האסקיואל המיוחד שיכיל את כל השכבות עד לטקסט עצמו
            var sql = $@" FROM
Contents.ContentGroups AS Level1 ";

            for (int i = 2; i <= counter; i++)
            {
                sql += $@"
JOIN Contents.ContentGroups AS Level{i} ON Level{i - 1}.GroupID=Level{i}.ParentGroupID";
            }

            sql += $@"
JOIN Contents.MainContent AS mainContent ON Level{counter}.GroupID=mainContent.GroupID
WHERE level1.ParentGroupID={groupID}
ORDER BY mainContent.SequenceNumberByRootGroup
";
            var sqlForSelect = "SELECT mainContent.MainContentID,mainContent.Content,mainContent.GroupID " + sql;
            if (take > 0)
            {
                sqlForSelect += $@"OFFSET {skip} ROWS
FETCH NEXT {take}  ROWS ONLY";
            }

            var result = db.SqlCommander.GetEntityListFromSql<MainContent>(sqlForSelect);
            //Entities.Database.SqlQuery<MainContent>(sqlForSelect).ToList();
            return result;

        }

        private IEnumerable<MainContent> GetByAlternateGroup(int groupID, int take = 100, int skip = 0)
        {

            var sqlForSelect = $@"SELECT 
(select top 1 c.RootGroupID from Contents.MainContent c where MainContentID=FromContentID ) as RootGroupID , 
(select top 1 c.SequenceNumberByRootGroup from Contents.MainContent c where MainContentID=FromContentID ) as FromSequenceNumberByRootGroup, 
(select top 1 c.SequenceNumberByRootGroup from Contents.MainContent c where MainContentID=ToContentID ) as ToSequenceNumberByRootGroup
INTO #rootAndSequence
FROM Contents.ContentToAlternateGroups g 
where g.GroupID={groupID};
SELECT  c.MainContentID,c.Content ,c.GroupID 
FROM Contents.MainContent c
JOIN #rootAndSequence s on c.RootGroupID=s.RootGroupID
WHERE  c.SequenceNumberByRootGroup >= s.FromSequenceNumberByRootGroup AND c.SequenceNumberByRootGroup <=s.ToSequenceNumberByRootGroup
ORDER BY c.SequenceNumberByRootGroup
";
            // הוא גובה כרגע מחיר יקר מידי עבור המשיכה החלקית משום מה ולכן זה פשוט מבוטל עדיף שיחזיר הכל מאשר שיתקשקש על הטייק והסקיפ
//            if (take > 0)
//            {
//                sqlForSelect += $@" OFFSET {skip} ROWS
//FETCH NEXT {take}  ROWS ONLY ";
//            }

            var db = new DB(User);
            var result = db.SqlCommander.GetEntityListFromSql<MainContent>(sqlForSelect);
            return result;
        }
    }
}
