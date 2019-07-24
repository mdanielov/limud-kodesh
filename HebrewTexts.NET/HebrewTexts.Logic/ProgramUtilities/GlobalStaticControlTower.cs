using AutoMapper;
using HebrewTexts.Logic.DTOs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HebrewTexts.Logic
{
    /// <summary>
    /// מגדל פיקוח סינגלטון אחד ויחיד העושה מגוון דברים שהם כלליים ביותר 
    /// לדוגמא אם יש צורך במשימה מתוזמנת טיימר וכדומה זה ינוהל כאן
    /// כל האיתחולים שיש לבצע פעם אחת בתחילת ריצת האפליקצה קורים דווקא כאן
    /// </summary>
    public static class GlobalStaticControlTower
    {
        #region Constructor
        static GlobalStaticControlTower()
        {
            //אוטו מפר מאותחל כאן
            Mapper.Initialize(cfg =>
            {
                cfg.AllowNullCollections = true;
                cfg.CreateMap<DAL.ContentGroup, ContentGroupDto>();
            }
            );
            
        }

        /// <summary>
        /// זוהי כרגע הדרך לנגוע בקלאס הזה
        /// ולגרום לו להפעיל את הקונסטרקטור שלו פעם אחת
        /// מה שיגרום לפעולות רבות וטובות עבור המערכת כולה
        /// כגון איתחול של אוטו מפר
        /// ושלל דברים אחרים
        /// כשאתה קורא למאפיין הזה אתה למעשה מאלץ את הקונסטרקטור לרוץ אם זו פעם ראשונה 
        /// וזו המטרה
        /// </summary>
        public static bool TouchMe { get { return true; } }

        #endregion
    }
}
