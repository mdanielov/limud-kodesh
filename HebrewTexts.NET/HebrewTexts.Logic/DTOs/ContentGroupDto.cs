using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HebrewTexts.Logic.DTOs
{
    /// <summary>
    ///  אובייקט של גרופ
    /// </summary>
    public class ContentGroupDto
    {
        /// <summary>
        /// מזהה של הגרופ הנוכחי
        /// </summary>
        public int GroupID { get; set; }
        /// <summary>
        /// סוג הגרופ
        /// </summary>
        public int? GroupType { get; set; }
        /// <summary>
        /// סוג הגרופ לתצוגה
        /// </summary>
        public string GroupTypeDisplay { get; set; }
        /// <summary>
        /// שם הגרופ
        /// </summary>
        public string GroupName { get; set; }
        /// <summary>
        /// הסדר של הגרופ הלזה בתוך הלוול של עצמו
        /// </summary>
        public int? SequenceNumber { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public int? SequenceNumberByRootGroup { get; set; }

        public int? ParentGroupID { get; set; }
        public string GroupTypeKeyWord { get; internal set; }

        #region UIIssues
        /// <summary>
        /// האם לאפשר קריאה ישירה מתוך הגרופ הלזה
        /// זה נוגע ליואיי
        /// לדוגמא תלמוד בבלי לא רלוונטי לאפשר קריאה ישירה שלו ממסכת ברכות
        /// אבל מסכת ברכות זה הגיוני שמישהו ירצה להתחיל לקרוא
        /// וכן ספר בראשית עוד לפני שיורדים לפרקים
        /// עם זאת עדיין ייתרן שמישהו רוצה לפתוח ספר בראשית בפרק כב וצריך להציע לו פרקים
        /// לכן מאפיין זה רק "מאפשר" קריאה ישירה
        /// אבל עדיין מניח שאם לחצת על הכפתור עצמו שאיננו קריאה הוא יפתח לך את השלב הבא בהיררכיה כגון פרקים בספר בראשית
        /// </summary>
        public bool AllowReadingDirectly { get; set; } = false;

        /// <summary>
        /// מאפיין זה אומר שבמקרה הזה כאשר לחצת על כפתור העץ השלב הבא הוא להתחיל לקרוא
        /// רלוונטי למשל בגרופ של פרקים בספר חומש כגון מי שלוחץ על פרק ג בבראשית לא נותנים לו להמשיך לבחור פסוק אלא מובילים אותו היישר אל הטקסט
        /// כיוצא בזה הבוחר דף בגמרא
        /// וכן הלאה
        /// </summary>
        public bool GoReadingDirectly { get; set; } = false;

        #endregion
    }

    /// <summary>
    /// מידע נוסף המתווסף לריקווסט כאשר מחזירים גרופים
    /// למשל מהו המסלול של הגרופים עד הנה
    /// וזה תלוי בגרופ שהתבקש בריקווסט
    /// </summary>
    public class ContentGroupsAdditionalInformation {
        public List<ContentGroupDto> Ancestors { get; set; }
    }
}
