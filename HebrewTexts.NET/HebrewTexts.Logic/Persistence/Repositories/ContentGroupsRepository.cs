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
    /// רפוזיטורי האחראי על גרופים
    /// </summary>
    public class ContentGroupsRepository : RepositoryBase<ContentGroup>
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="user"></param>
        public ContentGroupsRepository(AppUser user) : base(user)
        {
        }

        /// <summary>
        /// קבל את הגרופים הראשיים
        /// </summary>
        /// <returns></returns>
        public IEnumerable<ContentGroup> GetMainGroups()
        {
            var db = new DB(user: User);
            var result = db.Entities.ContentGroups.Where(g => g.RootGroupID == null || g.RootGroupID == g.GroupID).ToList();
            return result;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="parentGroupID"></param>
        /// <returns></returns>
        public IEnumerable<ContentGroup> GetChildren(int parentGroupID)
        {
            var db = new DB(user: User);
            var result = db.Entities.ContentGroups.Where(g => g.ParentGroupID == parentGroupID).ToList();
            return result;
        }
        /// <summary>
        /// קבל את ההיררכייה המובילה עד לגרופ מסויים
        /// לדוגמא אם אתה נמצא בפרשת בראשית תקבל כאן את ספר בראשית>>תורה>>תנך
        /// זוהי שאילתה רקורסיבית העוקבת אחרי האבא והסבא וכו
        /// </summary>
        /// <param name="childGroupID"></param>
        /// <returns></returns>
        public IEnumerable<ContentGroup> GetAncestors(int childGroupID)
        {

            var db = new DB(user: User);

            var currentChild = GetByID(childGroupID);
            var result = new List<ContentGroup> { currentChild};
            var currentParent = Parent(currentChild);
            if (currentParent==currentChild)
            {
                return result;
            }
            result.Insert(0,currentParent);
            for (int i = 0; i < 20; i++)
            {
                currentParent = Parent(currentParent);
                if (currentParent == result.First())
                {
                    break;
                }
                result.Insert(0, currentParent);
            }

            return result;
        }



        #region ParentsAndChildren

        /// <summary>
        /// הילד הראשון של גרופ
        /// אם לא נמצאו ילדים יחזיר את הגרופ בעצמו
        /// </summary>
        /// <returns></returns>
        public ContentGroup FirstChild(ContentGroup group, int? routePriority = null)
        {
            var db = new DB(User);
            return db.Entities.ContentGroups
                .Where(g => g.ParentGroupID == group.GroupID && (g.RoutePriority == routePriority))
                .OrderBy(g => g.RoutePriority)
                .ThenBy(g => g.SequenceNumber)
                .FirstOrDefault() ?? group;
        }

        /// <summary>
        /// הילד האחרון של הגרופ הנוכחי
        /// </summary>
        /// <returns></returns>
        public ContentGroup LastChild(ContentGroup group, int? routePriority = null)
        {
            var db = new DB(User);
            return db.Entities.ContentGroups
                .Where(g => g.ParentGroupID == group.GroupID && (g.RoutePriority == routePriority))
                .OrderBy(g => g.RoutePriority)
                .ThenByDescending(g => g.SequenceNumber)
                .FirstOrDefault() ?? group;
        }


        /// <summary>
        /// מחזיר את האבא של הגרופ הנוכחי
        /// אם אין אבא הוא יחזור בעצמו
        /// </summary>
        /// <returns></returns>
        public ContentGroup Parent(ContentGroup group)
        {
            var db = new DB(User);
            return db.Entities.ContentGroups.Find(group.ParentGroupID) ?? group;
        }

        /// <summary>
        /// בודק האם יש הורה לגרופ הנוכחי
        /// </summary>
        /// <param name="group"></param>
        /// <returns></returns>
        public bool HasParent(ContentGroup group)
        {
            var db = new DB(User);
            return db.Entities.ContentGroups.Any(g => g.GroupID == group.ParentGroupID);
        }




        #endregion


        #region Brothers

        /// <summary>
        /// האח הבא של הגרופ הנוכחי לפי הסדר הרציף
        /// לדוגמא תורה האח הבא נביאים והאח הבא כתובים
        /// הואיל וכולם תחת אותו אבא שהוא תנך
        /// אם לא נמצא אח כגון שאנחנו בכתובים הוא יחזיר את עצמו
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public ContentGroup NextBrother(ContentGroup group)
        {

            if (IsLastBrother(group))
                return group;
            else
            {
                var db = new DB(User);
                return db.Entities.ContentGroups
            //.Find(NextBrotherID(context: context));
            .Where(g => g.ParentGroupID == group.ParentGroupID && g.SequenceNumber > group.SequenceNumber && g.RoutePriority == group.RoutePriority)
            .OrderBy(g => g.SequenceNumber)
            .First();
            }
        }

        public int NextBrotherID(ContentGroup group)
        {

            if (IsLastBrother(group))
                return group.GroupID;
            else
            {
                var db = new DB(User);
                return db.Entities.ContentGroups
                .Where(g => g.ParentGroupID == group.ParentGroupID && g.SequenceNumber > group.SequenceNumber && g.RoutePriority == group.RoutePriority)
                .OrderBy(g => g.SequenceNumber)
                .Take(1).Select(g => g.GroupID)
                .First();
            }
        }


        /// <summary>
        /// מתשאל האם זהו האחרון באחים במסגרת הגרופ הנוכחי
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public bool IsLastBrother(ContentGroup group)
        {
            var db = new DB(User);
            return !db.Entities.ContentGroups.Any(g => g.ParentGroupID == group.ParentGroupID && g.SequenceNumber > group.SequenceNumber && g.RoutePriority == group.RoutePriority);
        }



        /// <summary>
        /// האח הקודם ראה תיעוד בפונקצייה האח הבא
        /// </summary>
        /// <returns></returns>
        public ContentGroup PreviousBrother(ContentGroup group)
        {
            var db = new DB(User);
            return db.Entities.ContentGroups
                .Where(g => g.ParentGroupID == group.ParentGroupID && g.SequenceNumber < group.SequenceNumber && g.RoutePriority == group.RoutePriority)
                .OrderBy(g => g.SequenceNumber)
                .FirstOrDefault() ?? group;
        }


        #endregion


        #region Sequence

        /// <summary>
        /// תפקידה של פונקציה זו להחזיר את הבא בתור בהתקבל גרופ מסויים
        /// לדוגמא אם ניתן לו את בראשית פרק א פסוק א נקבל את פסוק ב
        /// אם ניתן לו את הפסוק האחרון בפרק א נקבל את הפסוק הראשון בפרק ב וכן הלאה
        /// אם ניתן לו פרק הוא יבצע את אותה התנהגות כלפי הפרק
        /// אם ניתן לו לדוגמא את ספר שופטים הוא ירוץ לספר שמואל א - למרות שישנו באמצע עוד צומת של שמואל שתחתיו יש שמואל א ושמואל ב
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public ContentGroup MoveNext(ContentGroup group)
        {

            //במידה וכבר קיים במסד הנתונים מידע אודות הפריט הבא הרלוונטי אין טעם להפעיל אלגוריתמים אלא פשוט לגשת אליו ישירות
            if (group.NextGroupIDInLevel != null)
            {
                var db = new DB(User);
                var result = db.Entities.ContentGroups.Find(group.NextGroupIDInLevel);
                if (result != null)
                {
                    return result;
                }
            }


            //קובע את הלבל הנוכחי של הגרופ על פי הסוג שלו ועומק הקינון 

            //ראשית מחפש את הגרופ הבא לפי הרצף שלו ומנסה להבין האם יש לו אחד רציף אחריו

            //אם זהו לא האח האחרון הרי שבנקל ניתן למצוא את אחיו הבא
            var nextBrother = NextBrother(group);
            if (nextBrother != group && nextBrother.GroupType == group.GroupType)
            {
                return nextBrother;
            }
            //אם האח האב נמצא אולם הוא איננו מאותו סוג
            // לדוגמא אחרי ספר שופטים מגיע שמואל אולם בעצם שמואל א הוא הספר הבא בתור ואילו שמואל הוא גרופ מסוג אחר
            //במקרה כזה עלינו להמשיך לרדת במורד העץ עד למציאת אח דומה ולחפש את הילדים הראשונים של כל הורה והורה כזה
            else if (nextBrother.GroupType != group.GroupType)
            {
                var currentResult = FirstChild(nextBrother);
                while (currentResult.GroupType != group.GroupType)
                {
                    var newChild = FirstChild(currentResult);
                    if (newChild == currentResult)
                    {
                        break;
                    }
                    currentResult = newChild;
                }

                return currentResult;
            }


            //אם זהו האח האחרון עלינו להתחיל לחפש בלולאה את האבא הראשון שיש לו אח אחריו
            //לדוגמא אם אנו נמצאים בפסוק האחרון בספר בראשית הרי שיש לחפש את הפרק והוא גם אחרון ואז יש לחפש את הספר ונמצא שיש לו אחר אחריו
            //נרוץ לספר שמות ונתחיל לחפש את הילד הראשון ונגיע לפרק א ואז לילד הראשון שהוא פסוק א
            var currentParent = Parent(group);
            while (IsLastBrother(currentParent) && HasParent(currentParent))
            {
                currentParent = Parent(currentParent);
            }


            //אם הגענו עד לסבא המוקדם ביותר שאין לו עוד אבא סימן שאנחנו נמצאים בנכד האחרון ביותר
            //כגון אם מישהו נמצא בפסוק האחרון בתנ"ך שאין אחריו עוד פסוקים 
            //במצב כזה כמה שלא נטפס במעלה העץ לחפש את הבא בתור בסופו של דבר נגיע לסבא שהוא התנך
            //במקרה שכזה אין להחזיר לו אלא את אותו הפסוק בעצמו מכיוון שהפקודה הבא איננה זמינה
            if (!HasParent(currentParent))
            {
                return group;

            }
            //כעת אנו צריכים להשיג את האח הבא בתור לאחר שהגענו מספיק גבוה למקום שבו יש אח אחר כך
            //אם אנו עומדים בנקודה זו חייב להיות שישנו אח קטן יותר בלוול הנוכחי
            //כגון שאנו נמצאים בלוול של תורה נביאים וכתובים ועמדים כעת בנביאים הרי אות היא שעלינו לעבור מכאן אל כתובים
            //ולכן במקרה הזה יגיע לכאן ערך של גרופ של כתובים
            var currentGroup = NextBrother(currentParent);

            //כעת הלולאה רודפת אחרי הילדים עד שנגיע ללוול הרלוונטי
            //לפי הדוגמא לעיל אנחנו כאן בכתובים ומתחילים לרדת לתהילים שהוא הראשון בכתובים
            // אולם מכיוון שחיפשנו גרופ מסוג פסוק עלינו לרדת מספיק עד שנגיע לפרק א פסוק א בספר תהילים

            var i = 1;
            while (currentGroup.GroupType != group.GroupType)
            {
                currentGroup = FirstChild(currentGroup);
                i++;
                if (i >= 100)
                {
                    throw new Exception("צעדים רבים מידי בלולאת חיפוש צאצאים, משהו לא הגיוני");
                }
            }

            return currentGroup;


        }


        /// <summary>
        /// מתנהג כמו MoveNext 
        /// אבל מחזיר אינט בלבד על מנת לחסוך בביצועים
        /// </summary>
        /// <returns></returns>
        public int MoveNextID(ContentGroup group)
        {
            //קובע את הלבל הנוכחי של הגרופ על פי הסוג שלו ועומק הקינון 

            //ראשית מחפש את הגרופ הבא לפי הרצף שלו ומנסה להבין האם יש לו אחד רציף אחריו

            //אם זהו לא האח האחרון הרי שבנקל ניתן למצוא את אחיו הבא
            if (!IsLastBrother(group))
            {
                return NextBrotherID(group);
            }

            return MoveNext(group).GroupID;


        }




        #endregion




    }
}
