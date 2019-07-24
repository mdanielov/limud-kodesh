using Microsoft.VisualStudio.TestTools.UnitTesting;
using HebrewTexts.Import.EntitiesToImport.TalmudBavli;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Text.RegularExpressions;

namespace HebrewTexts.Import.EntitiesToImport.TalmudBavli.Tests
{
    [TestClass()]
    public class RowInTalmudBavliTests
    {
        [TestMethod()]
        public void RowIsValidTest()
        {
            //שמנו כאן תוכן המכיל מרכאות נקודתיים נקודה וגרש על מנת לכסות את כל סוגי הקרקטרס הרלוונטיים
            var rowContent = "קורין \" את: שמע בערבין. משע'ה שהכהנים";

            var masechet = new MasechetTalmudBavli { Name = "ברכות", SequenceNumber = 1 };
            var amud = new AmudTalmudBavli { Masechet = masechet };
            var row = new RowInTalmudBavli { InAmud = amud, SequenceNumber = 2, Content = rowContent };

            amud.Rows.Add(row);

            Assert.IsTrue(row.IsValid);

            //בדיקת ולידציה כאשר מספר השורה לא ריאלי
            row.SequenceNumber = 0;
            Assert.IsFalse(row.IsValid);
            //בדיקת ולידציה כאשר מספר השורה לא ריאלי
            row.SequenceNumber = 301;
            Assert.IsFalse(row.IsValid);
            row.SequenceNumber = 1;
            Assert.IsTrue(row.IsValid);

            //בדיקה כאשר התוכן לא מתאים לרגולר
            row.Content = "abc";
            Assert.IsFalse(row.IsValid);
            row.Content = rowContent;
            Assert.IsTrue(row.IsValid);

            //בדיקה כאשר אין הפנייה לאובייקט עמוד
            row.InAmud = null;
            Assert.IsFalse(row.IsValid);
            row.InAmud = amud;
            Assert.IsTrue(row.IsValid);




        }

        [TestMethod]
        public void XmlParse()
        {
            var xml = @"<root><row row_number='15' isdata='1'>אדם מן העבירה: <EndMishna/><StartGemara/>גמ' תנא היכא קאי דקתני</row></root>";
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(xml);
            var rows = doc.SelectNodes("/root/row");
        
          
            var input = ":אדם מן  העבירה";
            
           
            var wordss = Regex.Split(input.Trim(), @"\s+").ToArray();
           
            //ביטוי רגולרי שאומר כך:
            //רווח אחד או יותר
            //בתנאי שאחרי הרווח מגיע א-ת או שזוהי המילה האחרונה ואין אחריה כלום

            var text = " :אדם: מן  העבירה";
            var punctuation = text.Where(Char.IsPunctuation).Distinct().ToArray();
            var words = text.Split().Select(x => x.Trim(punctuation));
            var arr = text.Trim().Split(new string[] { " " }, StringSplitOptions.RemoveEmptyEntries);
            if (rows.Item(0).SelectSingleNode("EndMishna") != null)
            {
                
                var positionEndMishna = Regex.Split(rows.Item(0).FirstChild.InnerText.Trim(), @"\s+").ToArray().Count();
            }
            if (rows.Item(0).SelectSingleNode("StartGemara") != null)
            {
                var positionStartGmara = rows.Item(0).FirstChild.InnerText.Trim().Split(' ').First();
            }



        }
    }
}