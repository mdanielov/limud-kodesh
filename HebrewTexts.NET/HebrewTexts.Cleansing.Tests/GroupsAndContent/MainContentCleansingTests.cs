using Microsoft.VisualStudio.TestTools.UnitTesting;
using HebrewTexts.Cleansing.GroupsAndContent;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HebrewTexts.Cleansing.GroupsAndContent.Tests
{
    [TestClass()]
    public class MainContentCleansingTests
    {
        [TestMethod()]
        public void UpdateRootGroupIDTest()
        {

            var g = new MainContentCleansing();
            g.UpdateRootGroupID();

        }

        [TestMethod()]
        public void UpdateSequenceNumberLastNodeByRootGroupTest()
        {
            var c = new MainContentCleansing();
            c.UpdateSequenceNumberLastNodeByRootGroup(1);
        }

        [TestMethod()]
        public void UpdateNextGroupIDInLevelTest()
        {
            var c = new MainContentCleansing();
            c.UpdateNextGroupIDInLevel(24171,true);
        }
    }
}