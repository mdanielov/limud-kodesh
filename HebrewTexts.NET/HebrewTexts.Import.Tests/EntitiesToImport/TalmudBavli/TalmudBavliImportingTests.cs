using Microsoft.VisualStudio.TestTools.UnitTesting;
using HebrewTexts.Import.EntitiesToImport.TalmudBavli;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Xml;

namespace HebrewTexts.Import.EntitiesToImport.TalmudBavli.Tests
{
    [TestClass()]
    public class TalmudBavliImportingTests
    {
        [TestMethod()]
        public void CreateFromXmlTest()
        {

            //var xmlstring = "<xml><row row_number=\"15\" isdata=\"1\">אדם מן העבירה: <EndMishna/><StartGemara/>גמ' תנא היכא קאי דקתני</row></xml>";
            //var xmlDoc = new XmlDocument();
            //xmlDoc.LoadXml(xmlstring);
            //var nodes = xmlDoc.SelectNodes("xml/row");
            //var t = nodes[0].SelectSingleNode("EndMishna").NextSibling.NextSibling;

            //return;
            var dic = TalmudBavliImporting.MasechtotKeyWord;
            var dir = @"C:\Matarah\KodeshRepository\FilesAndStuffs\parsed_shas";
            var masechtotDirectories = Directory.GetDirectories(dir).ToList();
            var xmlFiles = Directory.GetFiles(dir, "*.xml", SearchOption.AllDirectories).ToList();

            var amudim = new List<AmudTalmudBavli>();

            xmlFiles.ForEach(xmlFileName =>
            {
                var xml = File.ReadAllText(xmlFileName);
                amudim.Add(TalmudBavliImporting.CreateFromXml(xml));
            });

            //var withStart = amudim.Where(amud => amud.Rows.First().StartMishnaBeforePositionInContent != null ||
            // amud.Rows.First().StartGmaraBeforePositionInContent != null);
            var rowsForUpdate = amudim
                .Where(a => a.Rows.Count > 0)
                .SelectMany(a => a.Rows).ToList();

            var importing = new TalmudBavliImporting();
            importing.UpdateRowsInRawTable(rowsForUpdate);
            return;
            //amudim.ForEach(amud =>
            //{
            //    importing.ImportAmudToRawTable(amud);
            //});

            // var xml = File.ReadAllText(@"C:\Matarah\KodeshRepository\HebrewTexts\HebrewTexts.Import\Stuff\TalmudBavli\01-berachot\003-berachot.3.1.xml");
            //var xml = File.ReadAllText(@"C:\Matarah\KodeshRepository\FilesAndStuffs\parsed_shas\01-berachot\001-berachot.2.1.xml");
            //var amud = TalmudBavliImporting.CreateFromXml(xml);
            //var importing = new TalmudBavliImporting();
            //importing.ImportAmudToRawTable(amud);
        }

        [TestMethod()]
        public void ImportFromRawToMainContentTest()
        {
            var importing = new TalmudBavliImporting();
            importing.ImportFromRawToMainContent();
        }
    }
}