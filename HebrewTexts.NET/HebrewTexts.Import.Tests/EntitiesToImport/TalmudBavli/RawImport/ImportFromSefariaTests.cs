using Microsoft.VisualStudio.TestTools.UnitTesting;
using HebrewTexts.Import.EntitiesToImport.TalmudBavli.RawImport;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HebrewTexts.Import.EntitiesToImport.TalmudBavli.RawImport.Tests
{
    [TestClass()]
    public class ImportFromSefariaTests
    {
        [TestMethod()]
        public void ImportAllTest()
        {
            var importer = new ImportFromSefaria();
            importer.ImportAll();
        }

        [TestMethod()]
        public void ImportMalbimBeurHamilotTest()
        {
            var importer = new ImportFromSefaria();
            importer.ImportMalbimBeurHamilot();
        }

        [TestMethod()]
        public void ImportToRawContentTest()
        {
            var importer = new ImportFromSefaria();
            importer.ImportToRawContent();
            // importer.ImportOnkelos();
        }

        [TestMethod()]
        public void ImportFromRawTableTest()
        {
            var importer = new ImportFromSefaria();
            importer.ImportFromRawTable();
        }
    }
}