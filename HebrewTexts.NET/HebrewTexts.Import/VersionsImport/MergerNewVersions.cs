using DiffMatchPatch;
using HebrewTexts.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HebrewTexts.Import.VersionsImport
{
   public class MergerNewVersions
    {

        /// <summary>
        /// ממזג ליסט של תכנים לתוך הדטה בייס בתור גירסה חלופית
        /// </summary>
        /// <param name="listToMerge">ליסט של אובייקטים של קונטנט</param>
        /// <param name="groupID">לפעמים ייתכן שלגירסאות יש שינוי ברמת סדר הגרופים ולא תמיד התוכן יתחרה בגרופ עצמו ממש</param>
        /// 
        public void MergeListContentsAsVersion(List<MainContent> listToMerge, int groupID = 0)
        {

            //ראשית אם התוכן הזה לא מעודכן כלל ועיקר כלומר שהגרופ הזה אין לו שום תוכן מעודכן אזי זה ייכנס כתוכן הראשי המרכזי
            //var df = new Diff(operation:Operation.)
          

            //קודם כל אם מדובר בגירסה המרכזית שכבר מעודכנת לגמרי ובעצם יש כאן חזרה על אותה גירסה ככל הנראה עם עדכונים כלשהן
            //אזי יש למחוק את המיותר, להשאיר את הזהים ולהוסיף את החדשים


            //אם מדובר בגירסה חדשה אזי יש להשוות בין הגירסאות כלומר בין הגירסה הקיימת לבין הגירסה החדשה המוצעת
            //האופציות של גירסה חילופית הן תמיכה מחיקה החלפה והוספה כל אלו מתועדים בסכימה של מסד הנתונים


        }

    }
}
