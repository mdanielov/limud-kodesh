using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HebrewTexts.DAL
{
    public partial class ContentGroup
    {

        #region ParentsAndChildren

        /// <summary>
        /// הילד הראשון של הגרופ הנוכחי
        /// אם לא נמצאו ילדים יחזיר את הנוכחי בעצמו
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public ContentGroup FirstChild(HebrewTextsEntities context, int? routePriority = null)
        {
            return context.ContentGroups
                .Where(g => g.ParentGroupID == this.GroupID && (g.RoutePriority == routePriority))
                .OrderBy(g => g.RoutePriority)
                .ThenBy(g => g.SequenceNumber)
                .FirstOrDefault() ?? this;
        }

        /// <summary>
        /// הילד האחרון של הגרופ הנוכחי
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public ContentGroup LastChild(HebrewTextsEntities context, int? routePriority = null)
        {
            return context.ContentGroups
                .Where(g => g.ParentGroupID == this.GroupID && (g.RoutePriority == routePriority))
                .OrderBy(g => g.RoutePriority)
                .ThenByDescending(g => g.SequenceNumber)
                .FirstOrDefault() ?? this;
        }


        /// <summary>
        /// מחזיר את האבא של הגרופ הנוכחי
        /// אם אין אבא הוא יחזור בעצמו
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public ContentGroup Parent(HebrewTextsEntities context)
        {
            return context.ContentGroups.Find(ParentGroupID) ?? this;
        }

        /// <summary>
        /// בודק האם יש הורה לגרופ הנוכחי
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public bool HasParent(HebrewTextsEntities context)
        {
            return context.ContentGroups.Any(g => g.GroupID == ParentGroupID);
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
        public ContentGroup NextBrother(HebrewTextsEntities context)
        {

            if (IsLastBrother(context: context))
                return this;
            else
                return context.ContentGroups
            //.Find(NextBrotherID(context: context));
            .Where(g => g.ParentGroupID == this.ParentGroupID && g.SequenceNumber > this.SequenceNumber && g.RoutePriority == RoutePriority)
            .OrderBy(g => g.SequenceNumber)
            .First();
        }

        public int NextBrotherID(HebrewTextsEntities context)
        {

            if (IsLastBrother(context: context))
                return this.GroupID;
            else
                return context.ContentGroups
                .Where(g => g.ParentGroupID == this.ParentGroupID && g.SequenceNumber > this.SequenceNumber && g.RoutePriority == RoutePriority)
                .OrderBy(g => g.SequenceNumber)
                .Take(1).Select(g => g.GroupID)
                .First();
        }


        /// <summary>
        /// מתשאל האם זהו האחרון באחים במסגרת הגרופ הנוכחי
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public bool IsLastBrother(HebrewTextsEntities context)
        {
            return !context.ContentGroups.Any(g => g.ParentGroupID == ParentGroupID && g.SequenceNumber > SequenceNumber && g.RoutePriority == RoutePriority);
        }



        /// <summary>
        /// האח הקודם ראה תיעוד בפונקצייה האח הבא
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public ContentGroup PreviousBrother(HebrewTextsEntities context)
        {
            return context.ContentGroups
                .Where(g => g.ParentGroupID == this.ParentGroupID && g.SequenceNumber < this.SequenceNumber && g.RoutePriority == RoutePriority)
                .OrderBy(g => g.SequenceNumber)
                .FirstOrDefault() ?? this;
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
        public ContentGroup MoveNext(HebrewTextsEntities context)
        {

            //במידה וכבר קיים במסד הנתונים מידע אודות הפריט הבא הרלוונטי אין טעם להפעיל אלגוריתמים אלא פשוט לגשת אליו ישירות
            if (NextGroupIDInLevel != null)
            {
                var result = context.ContentGroups.Find(NextGroupIDInLevel);
                if (result != null)
                {
                    return result;
                }
            }


            //קובע את הלבל הנוכחי של הגרופ על פי הסוג שלו ועומק הקינון 

            //ראשית מחפש את הגרופ הבא לפי הרצף שלו ומנסה להבין האם יש לו אחד רציף אחריו

            //אם זהו לא האח האחרון הרי שבנקל ניתן למצוא את אחיו הבא
            var nextBrother = NextBrother(context: context);
            if (nextBrother != this && nextBrother.GroupType == GroupType)
            {
                return nextBrother;
            }
            //אם האח האב נמצא אולם הוא איננו מאותו סוג
            // לדוגמא אחרי ספר שופטים מגיע שמואל אולם בעצם שמואל א הוא הספר הבא בתור ואילו שמואל הוא גרופ מסוג אחר
            //במקרה כזה עלינו להמשיך לרדת במורד העץ עד למציאת אח דומה ולחפש את הילדים הראשונים של כל הורה והורה כזה
            else if (nextBrother.GroupType != GroupType)
            {
                var currentResult = nextBrother.FirstChild(context: context);
                while (currentResult.GroupType != GroupType)
                {
                    var newChild = currentResult.FirstChild(context: context);
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
            var currentParent = Parent(context: context);
            while (currentParent.IsLastBrother(context: context) && currentParent.HasParent(context: context))
            {
                currentParent = currentParent.Parent(context: context);
            }


            //אם הגענו עד לסבא המוקדם ביותר שאין לו עוד אבא סימן שאנחנו נמצאים בנכד האחרון ביותר
            //כגון אם מישהו נמצא בפסוק האחרון בתנ"ך שאין אחריו עוד פסוקים 
            //במצב כזה כמה שלא נטפס במעלה העץ לחפש את הבא בתור בסופו של דבר נגיע לסבא שהוא התנך
            //במקרה שכזה אין להחזיר לו אלא את אותו הפסוק בעצמו מכיוון שהפקודה הבא איננה זמינה
            if (!currentParent.HasParent(context: context))
            {
                return this;

            }
            //כעת אנו צריכים להשיג את האח הבא בתור לאחר שהגענו מספיק גבוה למקום שבו יש אח אחר כך
            //אם אנו עומדים בנקודה זו חייב להיות שישנו אח קטן יותר בלוול הנוכחי
            //כגון שאנו נמצאים בלוול של תורה נביאים וכתובים ועמדים כעת בנביאים הרי אות היא שעלינו לעבור מכאן אל כתובים
            //ולכן במקרה הזה יגיע לכאן ערך של גרופ של כתובים
            var currentGroup = currentParent.NextBrother(context: context);

            //כעת הלולאה רודפת אחרי הילדים עד שנגיע ללוול הרלוונטי
            //לפי הדוגמא לעיל אנחנו כאן בכתובים ומתחילים לרדת לתהילים שהוא הראשון בכתובים
            // אולם מכיוון שחיפשנו גרופ מסוג פסוק עלינו לרדת מספיק עד שנגיע לפרק א פסוק א בספר תהילים

            var i = 1;
            while (currentGroup.GroupType != GroupType)
            {
                currentGroup = currentGroup.FirstChild(context: context);
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
        /// <param name="context"></param>
        /// <returns></returns>
        public int MoveNextID(HebrewTextsEntities context)
        {
            //קובע את הלבל הנוכחי של הגרופ על פי הסוג שלו ועומק הקינון 

            //ראשית מחפש את הגרופ הבא לפי הרצף שלו ומנסה להבין האם יש לו אחד רציף אחריו

            //אם זהו לא האח האחרון הרי שבנקל ניתן למצוא את אחיו הבא
            if (!IsLastBrother(context))
            {
                return NextBrotherID(context: context);
            }

            return MoveNext(context: context).GroupID;


        }




        #endregion

        #region ContentAccess
        /// <summary>
        /// מחזיר רשימת תוכן של הגרופ הנוכחי 
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public IQueryable<MainContent> GetContent(HebrewTextsEntities context)
        {
            if (context.MainContentForAllGroups.Any(g => g.GroupID == GroupID))
            {

                return
                    (from mc in context.MainContents
                     from ctsg in context.ContentToAlternateGroups
                     join cf in context.MainContents on ctsg.FromContentID equals cf.MainContentID
                     join ct in context.MainContents on ctsg.ToContentID equals ct.MainContentID
                     where
                     (mc.RootGroupID == ct.RootGroupID
                     && mc.SequenceNumberByRootGroup >= cf.SequenceNumberByRootGroup
                     && mc.SequenceNumberByRootGroup <= ct.SequenceNumberByRootGroup
                     && ctsg.GroupID == GroupID)
                     select mc)
                     .Union(
                        from mc in context.MainContents
                        where mc.GroupID == GroupID
                        select mc
                        );
            }
            else
            {
                var firstGroup = this;
                var i = 0;
                while (!context.MainContentForAllGroups.Any(g => g.GroupID == firstGroup.GroupID))
                {
                    firstGroup = firstGroup.FirstChild(context: context);
                    if (firstGroup == this)
                    {
                        return null;
                    }
                    i++;
                    if (i > 100)
                    {
                        throw new Exception("לולאת חיפוש עברה יותר מידי צעדים");
                    }

                }
                var lastGroup = this;
                i = 0;
                while (!context.MainContentForAllGroups.Any(g => g.GroupID == lastGroup.GroupID))
                {
                    lastGroup = lastGroup.LastChild(context: context);
                    if (lastGroup == this)
                    {
                        return null;
                    }
                    i++;
                    if (i > 100)
                    {
                        throw new Exception("לולאת חיפוש עברה יותר מידי צעדים");
                    }

                }
                var listOfGroups = new List<int>() { firstGroup.GroupID };
                var currentGroup = firstGroup;
                i = 0;
                do
                {
                    currentGroup = currentGroup.MoveNext(context: context);
                    listOfGroups.Add(currentGroup.GroupID);
                    i++;
                    if (i > 10000)
                    {
                        throw new Exception("לולאת עדכון עברה יותר מידי צעדים");
                    }
                }
                while (currentGroup != lastGroup);


                return from mc in context.MainContents
                       join c in context.MainContentForAllGroups
                       on mc.MainContentID equals c.MainContentID
                       where listOfGroups.Contains(c.GroupID)
                       select mc;


            }


        }


        #endregion


    }
}
