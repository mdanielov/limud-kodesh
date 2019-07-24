using Microsoft.VisualStudio.TestTools.UnitTesting;
using HebrewTexts.Import.VersionsImport;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DiffMatchPatch;
using HebrewTexts.Logic.TextProcessing;

namespace HebrewTexts.Import.VersionsImport.Tests
{
    [TestClass()]
    public class MergerNewVersionsTests
    {
        [TestMethod()]
        public void MergeListContentsAsVersionTest()
        {

            //var text1 = "אלף גימל דלת הא";
            //var text2 = "אלף בית גמל דלת";

            var text1 = "אלףגימלדלתהא";
            var text2 = "אלףביתגמלדלת";

            var dmp = new diff_match_patch();
            var diffs = dmp.diff_main(text1, text2);
            var html = dmp.diff_prettyHtml(diffs);

            var difProcessor = new DiffByUnitContentProcessor();
            var result = difProcessor.MainDiff(oldText: text1, newText: text2);

        }
    }
}