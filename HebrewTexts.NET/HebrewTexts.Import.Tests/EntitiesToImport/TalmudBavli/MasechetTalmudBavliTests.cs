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
    public class MasechetTalmudBavliTests
    {
        delegate void Operation();

        [TestMethod()]
        public void MasechetIsValidTest()
        {
            var masechet = new MasechetTalmudBavli { Name = "ברכות", SequenceNumber = 1 };
            var amudim = new List<AmudTalmudBavli>();
            //יוצר 8 עמודים בכדי לעבור את הולידציה הדורשת 8 עמודים מינימום
            for (int i = 2; i < 17; i++)
            {
                amudim.Add(
                    new AmudTalmudBavli
                    {
                        Masechet = masechet,
                        DafNumber = (i / 2) + 1,
                        AmudNumber = (i % 2) + 1
                    }
                    );
            }

            //לא להשתמש בהשוואה גמורה כי אז יווצר רפרנס למשתנה עמודים וכל משחק שנעשה עם העמודים שבתוך המסכת ישפיע על המשתנה המקומי
            //אנחנו רוצים להיות במצב שבו אפשר לבצע מניפולציות שונות ולהחזיר את המצב לקדמותו
            Operation resetAmudim = delegate
            {
                masechet.Amudim.Clear();
                masechet.Amudim.AddRange(amudim);
                Assert.IsTrue(masechet.IsValid);
            };

            resetAmudim();

            //בדיקה כאשר מספר המסכת הוא אפס או מעל 37
            masechet.SequenceNumber = 0;
            Assert.IsFalse(masechet.IsValid);
            masechet.SequenceNumber = 38;
            Assert.IsFalse(masechet.IsValid);
            //החזרת המצב לקדמותו
            masechet.SequenceNumber = 1;
            Assert.IsTrue(masechet.IsValid);

            //בדיקה של תקינות הדפים והעמודים
            //מסיר את הדף הראשון ומקבל איולידציה של חסר דף ב
            masechet.Amudim.RemoveAll(a => a.DafNumber == 2);
            Assert.IsFalse(masechet.IsValid);
            //בודק שהשגיאה היא אכן לגבי מסכת שלא מתחילה בדף ב
            Assert.IsTrue(masechet.ValidationsMessages.Any(m => m == "המסכת לא מתחילה בדף ב"));

            //מחזיר את המצב לקדמותו
            resetAmudim();

            //משמיט דף אחד מהרצף ומאמת שהולידציה של הרצף עובדת
            masechet.Amudim.RemoveAll(a => a.DafNumber == 4);
            Assert.IsFalse(masechet.IsValid);
            //בודק שהשגיאה היא אכן לגבי מסכת שלא מתחילה בדף ב
            Assert.IsTrue(masechet.ValidationsMessages.Any(m => m == "אין רצף של דפים נמצא דילוג של דפים"));
            //אם אנחנו כבר כאן, נבדוק גם שישנה שגיאה של מעט מידי דפים במסכת
            Assert.IsTrue(masechet.ValidationsMessages.Any(m => m == "מעט מידי או יותר מידי דפים למסכת זו"));
            //מחזיר את המצב לקדמותו
            resetAmudim();
            //בודק אם ולידציה של עמודים כפולים עובדת


            masechet.Amudim.Add(
                new AmudTalmudBavli { DafNumber = 2, AmudNumber = 1 }
                );
            Assert.IsFalse(masechet.IsValid);
            Assert.IsTrue(masechet.ValidationsMessages.Any(m => m == "נמצאו עמודים כפולים לפי מספר דף ועמוד"));
            //מחזיר את המצב לקדמותו
            resetAmudim();



            masechet.Amudim.RemoveAll(a => a.DafNumber == 5 && a.AmudNumber == 1);
            Assert.IsFalse(masechet.IsValid);
            Assert.IsTrue(masechet.ValidationsMessages.Any(m => m == "חסר עמוד א באחד מהדפים"));
            resetAmudim();


            masechet.Amudim.RemoveAll(a => a.DafNumber == 5 && a.AmudNumber == 2);
            Assert.IsFalse(masechet.IsValid);
            Assert.IsTrue(masechet.ValidationsMessages.Any(m => m == "חסר עמוד ב באחד מהדפים"));
            resetAmudim();





        }
    }
}