using Microsoft.VisualStudio.TestTools.UnitTesting;
using HebrewTexts.Logic.UIServices.Search;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HebrewTexts.Logic.UIServices.Search.Tests
{
    [TestClass()]
    public class AutoCompleteContentTests
    {
        [TestMethod()]
        public void GetByInputTest()
        {
            var ac = new AutoCompleteContent();
            ac.GetByInput("ביום ההוא יהיה אור",distanceBetweenWords:2);

        }
    }
}