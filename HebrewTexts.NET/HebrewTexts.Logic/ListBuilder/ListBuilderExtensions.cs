using IntelligentListBuilder.Interop.ToSql;
using System.Collections.Generic;
using System.Linq;

namespace HebrewTexts.Logic.ListBuilder
{
    /// <summary>
    /// אקסטנשנים סטטיים הנוגעים לנושא של ליסט בילדר
    /// 
    /// </summary>
    public static class ListBuilderExtensions
    {
        /// <summary>
        /// פונקציה זו יוצרת ריפקטורינג לפקודות של ליסט בילדר
        /// לדוגמא אם הפקודה הראשונה היא ניוטרל ולאחריה באות עוד סידרה של פקודות שכולן ניוטרל 
        /// זהו דבר בלתי הגיוני כי יוצא שכל פקודה מאפסת את הפקודות הקודמות לה ונמצא שרק הפקודה האחרונה צריכה להתבצע
        /// לכן אנו מניחים שיתר הפקודות באות לבצע ריסטריקט לפקודה הראשנה
        ///פעולה נוספת שמתבצעת כאן
        ///כאשר נשלח דיספליי או קיוורד לפקודה יש לעבד אותה כראוי לשאילתה למשלוח למסד הנתונים
        /// </summary>
        /// <param name="source"></param>
        /// <returns></returns>
        public static IEnumerable<UnitFilterCommandToSql> Refactor(this IEnumerable<UnitFilterCommandToSql> source)
        {
            //טיפול במקרה שבו נשלחו כל הפקודות כניוטרל
            //במקרה כזה רק הפקודה הראשנה תיחשב ניוטרל ואילו יתר הפקודות תחשבנה כריסטריקט
            if (source.Count() > 1 && source.All(c => c.CommandType == IntelligentListBuilder.Interop.ListBuilderCommandType.Neutral))
            {
                var cmdsToRefactor = source.Skip(1);
                foreach (var command in cmdsToRefactor)
                {
                    command.CommandType = IntelligentListBuilder.Interop.ListBuilderCommandType.RestrictList;
                }
            }

            //TODO כאן יש לטפל במקרה שנשלח קיוורד כחלק מהפקודה
            //הטיפול יהיה פשוט מאוד
            //נאתר את הקולומן המתאים של הקיוורד
            //נגדיר אותו כג'וין לוויו הנוכחי

            return source;

        }

    }
}
