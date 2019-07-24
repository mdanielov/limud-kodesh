using DiffMatchPatch;
using MatarahExtensions;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HebrewTexts.Logic.TextProcessing
{

    #region Structs


    /// <summary>
    /// מחלקה זו אחראית לספק מידע אודות שינויים בטקסט אולם ברמת המילה ולא ברמת האות
    /// במחלקה של גוגל המצורפת כאן הדיפרנציה היא ברמת האות 
    /// וזה לא טוב לעניינים שאנחנו צריכים בניהול גירסאות
    /// אצלנו ניהול גירסה ברמת מילה ולכן עשינו מחלקה חדשה שיודעת לבצע את זה 
    /// אמנם משתמשים באלגוריתמים של גוגל הישנים והטובים
    /// </summary>
    public class DiffByUnitContent
    {
        public enum UnitContentOperation { Delete, Insert, Change, Equal }

        public string ContentStr { get; private set; }

        public UnitContentOperation Operation { get; private set; }

        public UnitContent OldUnitContent { get; internal set; }
        public UnitContent NewUnitContent { get; internal set; }

        internal DiffByUnitContent(string contentStr, UnitContentOperation operation)
        {
            ContentStr = contentStr;
            Operation = operation;
        }

        internal DiffByUnitContent(UnitContent oldContent, UnitContent newContent, UnitContentOperation operation)
        {
            OldUnitContent = oldContent;
            NewUnitContent = newContent;
            ContentStr = ((newContent?.Content) ?? oldContent.Content);
        }

    }


    /// <summary>
    /// מחלקה זו מאפשרת ליצור אובייקט של מילה עם הצמדה של מזהה לאותה מילה
    /// הרעיון הוא שכאשר נרצה להשוות טקסטים נוכל לזהות כל יחידת תוכן בשהוואה ליחידת תוכן אחרת
    /// במקרה שלנו יחידת תוכן היא מילה בדרך כלל
    /// </summary>
    public class UnitContent
    {
        /// <summary>
        /// יחידת התוכן
        /// </summary>
        public string Content { get; set; }
        /// <summary>
        /// מזהה ליחידת התוכן
        /// </summary>
        public int ID { get; set; }

        internal List<Diff> GoogleDiffs { get; set; }

    }

    #endregion

    /// <summary>
    /// מחלקה זו אחראית לעבד שינויים בטקסט אולם ברמת המילה ולא ברמת האות
    /// במחלקה של גוגל המצורפת כאן הדיפרנציה היא ברמת האות 
    /// וזה לא טוב לעניינים שאנחנו צריכים בניהול גירסאות
    /// אצלנו ניהול גירסה ברמת מילה ולכן עשינו מחלקה חדשה שיודעת לבצע השוואה לפי יחידות תוכן
    /// כלומר השוואה של מילה שהתווסה בה אות היא "שינוי" של המילה הישנה ולא מחיקה וכתיבת מילה חדשה וכן הלאה
    /// אמנם משתמשים באלגוריתמים של גוגל באופן חלקי
    /// </summary>
    public class DiffByUnitContentProcessor
    {
        public DiffByUnitContentProcessor()
        {

        }
        /// <summary>
        /// הכנסת טקסט חופשי
        /// כברירת מחדל המערכת תחלק את התוכן למילים ותבצע השוואה לפי מילים בלבד
        /// </summary>
        /// <param name="oldText">הטקסט הישן להשוואה</param>
        /// <param name="newText">הטקסט החדש שאותו רוצים להשוות מול הטקסט הישן</param>
        /// <returns></returns>
        public List<DiffByUnitContent> MainDiff(string oldText, string newText)
        {
            var i = 0;
            var oldContents = oldText.ToWords().Select(w => new UnitContent { Content = w, ID = ++i }).ToList();
            i = 0;
            var newContents = newText.ToWords().Select(w => new UnitContent { Content = w, ID = ++i }).ToList();

            return MainDiff(oldContents: oldContents, newContents: newContents);
        }

        public List<DiffByUnitContent> MainDiff(List<UnitContent> oldContents, List<UnitContent> newContents)
        {
            //שולחים את הטקסט לבדיקה ללא רווחים
            //הרווחים יוצאים אחר כך בעיות במורד הקוד
            var oldText = string.Join(" ", oldContents.Select(c => c.Content).ToList());
            var newText = string.Join(" ", newContents.Select(c => c.Content).ToList());

            //משיגים קודם כל את הכל הדיפרנטים של גוגל
            var dmp = new diff_match_patch();
            var googleDiffs = dmp.diff_main(text1: oldText, text2: newText);



            #region SplitToUnitsContents


            //כעת יש לעבור עליהם לבודד אותם ליחידות טקסט כפי שאנו קיבלנו אותם ולקבוע את הדיפרנטים שלנו
            //לצורך כך נשתמש בפרופרטי בתוך כל יחידת תוכן הפרופרטי הזה יושב בתוך היוניט קונטט

            //עוברים על הקונטנט הישן ואנו אמורים לחפש את כל הדיפנרטים שעושים איקוול או דיליט

            // כל הדיפנרטים הללו ביחד מכילים בהכרח את התכנים של הקונטנט הישן
            //כל האופרציות מלבד מה שנוסף כתוכן חדש מן ההכרח קיים שם
            var difsToOldContent = googleDiffs.Where(d => d.operation != Operation.INSERT).ToList();

            //מציאת הדיפרנטים היא מלאכה לא כל כך פשוטה
            //מכיוון שעלינו לרוץ אך ורק לפי סדר המילים שהוכנס
            //ולכן אנחנו קובעים פוזישן בכל פעם בלולאה נשים לב ששלחנו את הטקסט כאובייקטים צמודים ולא הוספנו רווחים ביניהם
            var currentFirstPosition = 1;
            foreach (var oldCntnt in oldContents)
            {

                //סיום של הפוזישן הנוכחי
                var currentLastPosition = (currentFirstPosition - 1) + (oldCntnt.Content.Length);//מוסיפים אחד עבור הרווח שאחרי המילה שהוא נחשב חלק מהמילה הקודמת

                //ניקח את אובייקטי הדיפרנט שמהמיקום הנוכחי ועד לסוף הסטרינג של הקונטנט הנוכחי
                //יש הרחבה מיוחדת שנכתבה לצורך כך עיבוד של הדיפרנטים
                oldCntnt.GoogleDiffs = difsToOldContent.GetRangeByStringPositions(startPosition: currentFirstPosition, endPosition: currentLastPosition);

                currentFirstPosition += (oldCntnt.Content.Length);  //עדכון שהפירסט פוזישן הוא עכשיו מתחיל מהמילה הבאה
            }

            //ביצוע הפעולה הנ"ל על הטקסט החדש

            // כל הדיפנרטים הללו ביחד מכילים בהכרח את התכנים של הקונטנט הישן
            //כל האופרציות מלבד מה שנוסף כתוכן חדש מן ההכרח קיים שם
            var difsToNewContent = googleDiffs.Where(d => d.operation != Operation.DELETE).ToList();


            currentFirstPosition = 1;
            foreach (var newCntnt in newContents)
            {
                //סיום של הפוזישן הנוכחי
                var currentLastPosition = (currentFirstPosition - 1) + newCntnt.Content.Length;

                //ניקח את אובייקטי הדיפרנט שמהמיקום הנוכחי ועד לסוף הסטרינג של הקונטנט הנוכחי
                //יש הרחבה מיוחדת שנכתבה לצורך כך עיבוד של הדיפרנטים
                newCntnt.GoogleDiffs = difsToNewContent.GetRangeByStringPositions(startPosition: currentFirstPosition, endPosition: currentLastPosition);

                currentFirstPosition += (newCntnt.Content.Length);
            }

            #endregion


            #region BuildResults


            var result = new List<DiffByUnitContent>();

            foreach (var content in oldContents)
            {
                //אם היה כאן אירוע מחיקה בלבד יש להוסיף את זה כמחיקה מוחלטת
                if (content.GoogleDiffs.All(d => d.operation == Operation.DELETE))
                {
                    result.Add(new DiffByUnitContent(content, null, operation: DiffByUnitContent.UnitContentOperation.Delete));
                }
                else if (content.GoogleDiffs.All(d => d.operation == Operation.EQUAL))
                {

                    var newContentEqual = newContents.Where(n => n.GoogleDiffs.ContainsOneOrMore(content.GoogleDiffs)).First();
                    result.Add(new DiffByUnitContent(
                        oldContent: content,
                        newContent: newContentEqual,
                        operation: DiffByUnitContent.UnitContentOperation.Equal
                        ));
                }
                else if (content.GoogleDiffs.Select(d => d.operation).ContainsAll(new List<Operation> { Operation.DELETE, Operation.EQUAL }))
                {
                    var newContentEqual = newContents.Where(n => n.GoogleDiffs.ContainsOneOrMore(content.GoogleDiffs)).First();
                    result.Add(new DiffByUnitContent(
                        oldContent: content,
                        newContent: newContentEqual,
                        operation: DiffByUnitContent.UnitContentOperation.Change
                        ));
                }
            }



            #endregion



            return result;
        }

    }

    #region Extesnins

    internal static class DiffExtenssinHelpers
    {
        /// <summary>
        /// קבל אובייקטים של דיף לפי פוזיציה של טקסט
        /// פוזיציה לפי אובייקטי הדיפ שיש בליסט הוא סופר מ 1 וממשיך
        /// </summary>
        /// <param name="source">הליסט המקורי של אובייקטי הדיף</param>
        /// <param name="startPosition">מאיזה פוזישן להתחיל הפוזישן הראשון הוא 1 והוא מתקדם עם הקרקטרס</param>
        /// <param name="endPosition">באיזה פוזישן ברצונך לסיים</param>
        /// <returns></returns>
        public static List<Diff> GetRangeByStringPositions(this List<Diff> source, int startPosition, int endPosition)
        {

            var result = new List<Diff>();
            var currentFirstPosition = 1;
            foreach (var df in source)
            {
                var currentLastPosition = (currentFirstPosition - 1) + df.text.Length;
                //כל עוד אנחנו נמצאים לפני ההתחלה שאנו צריכים אין לבצע דבר אלא לעבור לדיפנרט הבא
                if (currentLastPosition < startPosition)
                {
                    //do nothing
                }
                else
                {
                    //אם הגענו לכאן פירושו שאנחנו כבר נמצאים אחרי הדרישה של ההתחלה
                    //(בדיקה בנוגע לסוף מטופלת בהמשך הלולאה)
                    result.Add(df);
                }

                //עדכון ההתחלה החדשה לפי האורך של האובייקט הנוכחי
                currentFirstPosition += (df.text.Length);

                //אם עברנו את הסוף אין לנו מה לחפש כאן ואפשר לצאת מהלולאה
                if (currentFirstPosition > endPosition)
                {
                    break;
                }
            }
            return result;
        }
    }

    #endregion


}
