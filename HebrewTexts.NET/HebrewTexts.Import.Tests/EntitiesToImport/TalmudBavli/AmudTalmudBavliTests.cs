using Microsoft.VisualStudio.TestTools.UnitTesting;
using HebrewTexts.Import.EntitiesToImport.TalmudBavli;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HebrewTexts.Import.EntitiesToImport.TalmudBavli.Tests
{
    [TestClass()]
    public class AmudTalmudBavliTests
    {
        [TestMethod()]
        public void AmudIsValidTest()
        {
            var masechet = new MasechetTalmudBavli { Name = "ברכות", SequenceNumber = 1 };
            var amud = new AmudTalmudBavli { Masechet = masechet, DafNumber = 2, AmudNumber = 1 };
            var row = new RowInTalmudBavli { InAmud = amud, SequenceNumber = 1, Content = "מאימתי" };
            amud.Rows.Add(row);
            var row2 = new RowInTalmudBavli { InAmud = amud, SequenceNumber = 2, Content = "קורין את שמע בערבין. משעה שהכהנים" };
            amud.Rows.Add(row2);

            //בשלב זה הכל אמור להיות בסדר
            Assert.IsTrue(amud.IsValid);
            //בדיקת ולידציה של שם המסכת ריק
            amud.Masechet = null;
            Assert.IsFalse(amud.IsValid);
            amud.Masechet = masechet;
            Assert.IsTrue(amud.IsValid);


            //מכשיל את הולידציה על ידי ריקון הרשומות
            amud.Rows.Clear();
            Assert.IsFalse(amud.IsValid);
            //מוסיף בחזרה שורה ובודק שהכל תקין
            amud.Rows.Add(row);
            amud.Rows.Add(row2);
            Assert.IsTrue(amud.IsValid);


            //מכשיל על ידי רשומה כפולה
            amud.Rows.Add(row);
            Assert.IsFalse(amud.IsValid);
            //בודק שהשגיאה היא אכן לגבי רשומה כפולה
            Assert.IsTrue(amud.ValidationsMessages.Any(m => m == "נמצאו שורות כפולות לפי מספר השורה"));

            //מחזיר את המצב לקדמותו ובודק שהאימות עובר
            amud.Rows.Clear();
            amud.Rows.Add(row);
            amud.Rows.Add(row2);
            Assert.IsTrue(amud.IsValid);


            //מנקה את השורות ומכשיל על ידי העדר רצף של שורות
            amud.Rows.Clear();
            amud.Rows.Add(row);
            row2.SequenceNumber = 3;
            amud.Rows.Add(row2);
            Assert.IsFalse(amud.IsValid);
            //בודק שהשגיאה היא אכן לגבי רצף שורות
            Assert.IsTrue(amud.ValidationsMessages.Any(m => m == "אין רצף של שורות נמצא דילוג של שורות"));

        }
 
    }
}